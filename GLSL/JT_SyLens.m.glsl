#version 120
  
/*
  Original Lens Distortion Algorithm from SSontech (Syntheyes)
  http://www.ssontech.com/content/lensalg.htm
  
  r2 is radius squared.
  
  r2 = image_aspect*image_aspect*u*u + v*v
  f = 1 + r2*(k + kcube*sqrt(r2))
  u' = f*u
  v' = f*v
 
*/

// Controls 
uniform vec3 param1;
float kCoeff = float(param1.x) * 0.01;
float kCube = float(param1.y) * 0.01;
uniform vec3 param2;
float uShift = float(param2.x) * 0.01;
float vShift = float(param2.y) * 0.01;
float chroma_red = float(param2.z) * 0.01;
uniform vec3 param3;
float chroma_green = float(param3.x) * 0.01;
float chroma_blue = float(param3.y) * 0.01;
bool apply_disto = bool(param1.z);

// Front texture
uniform sampler2DRect image1;
// Matte
uniform sampler2DRect image3;


// uniform float adsk_input1_w, adsk_input1_h, 
// DO NOT WORK due to a bug in AE and up, so we allow for an override
// from the UI for these. Shame shame shame.
int override_w = int(param3.z);
uniform vec3 param4;
int override_h = int(param4.x);

// THESE DO WORK
float adsk_input1_aspect = float(param4.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_input1_frameratio = res.x/res.y;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

float distortion_f(float r) {
    float f = 1 + (r*r)*(kCoeff + kCube * r);
    return f;
}

// Returns the F multiplier for the passed distorted radius
float inverse_f(float r_distorted)
{
    
    // Build a lookup table on the radius, as a fixed-size table.
    // We will use a vec2 since we will store the F (distortion coefficient at this R)
    // and the result of F*radius
    vec2[48] lut;
    
    // Since out LUT is shader-global check if it's been computed alrite
    // Flame has no overflow bbox so we can safely max out at the image edge, plus some cushion
    float max_r = sqrt((adsk_input1_frameratio * adsk_input1_frameratio) + 1) + 1;
    float incr = max_r / 48;
    float lut_r = 0;
    float f;
    for(int i=0; i < 48; i++) {
        f = distortion_f(lut_r);
        lut[i] = vec2(f, lut_r * f);
        lut_r += incr;
    }
    
    float t;
    // Now find the nehgbouring elements
    // only iterate to 46 since we will need
    // 47 as i+1
    for(int i=0; i < 47; i++) {
        if(lut[i].y < r_distorted && lut[i+1].y > r_distorted) {
            // BAM! our distorted radius is between these two
            // get the T interpolant and mix
            t = (r_distorted - lut[i].y) / (lut[i+1].y - lut[i]).y;
            return mix(lut[i].x, lut[i+1].x, t );
        }
    }
    // Rolled off the edge
    return lut[47].x;
}

float aberrate(float f, float chroma)
{
   return f + (f * chroma);
}

vec3 chromaticize_and_invert(float f)
{
   vec3 rgb_f = vec3(aberrate(f, chroma_red), aberrate(f, chroma_green), aberrate(f, chroma_blue));
   // We need to DIVIDE by F when we redistort, and x / y == x * (1 / y)
   if(apply_disto) {
      rgb_f = 1 / rgb_f;
   }
   return rgb_f;
}

void main(void)
{
   vec2 px, uv;
   float f = 1;
   float r = 1;
   
   px = gl_FragCoord.xy;
   
   // Make sure we are still centered
   // and account for overscan
   px.x -= (adsk_result_w - override_w) / 2;
   px.y -= (adsk_result_h - override_h) / 2;
   
   // Push the destination coordinates into the [0..1] range
   uv.x = px.x / override_w;
   uv.y = px.y / override_h;
       
   // And to Syntheyes UV which are [1..-1] on both X and Y
   uv.x = (uv.x *2 ) - 1;
   uv.y = (uv.y *2 ) - 1;
   
   // Add UV shifts
   uv.x += uShift;
   uv.y += vShift;
   
   // Make the X value the aspect value, so that the X coordinates go to [-aspect..aspect]
   uv.x = uv.x * adsk_input1_frameratio;
   
   // Compute the radius
   r = sqrt(uv.x*uv.x + uv.y*uv.y);
   
   // If we are redistorting, account for the oversize plate in the input, assume that
   // the input aspect is the same
   if(apply_disto) {
      r = r / (float(adsk_result_w) / float(override_w));
      f = inverse_f(r);
   } else {
      f = distortion_f(r);
   }
   
   vec2[3] rgb_uvs = vec2[](uv, uv, uv);
   
   // Compute distortions per component
   vec3 rgb_f = chromaticize_and_invert(f);
   
   // Apply the disto coefficients, per component
   rgb_uvs[0] = rgb_uvs[0] * rgb_f.rr;
   rgb_uvs[1] = rgb_uvs[1] * rgb_f.gg;
   rgb_uvs[2] = rgb_uvs[2] * rgb_f.bb;
   
   // Convert all the UVs back to the texture space, per color component
   for(int i=0; i < 3; i++) {
       uv = rgb_uvs[i];
       
       // Back from [-aspect..aspect] to [-1..1]
       uv.x = uv.x / adsk_input1_frameratio;
       
       // Remove UV shifts
       uv.x -= uShift;
       uv.y -= vShift;
       
       // Back to OGL UV
       uv.x = (uv.x + 1) / 2;
       uv.y = (uv.y + 1) / 2;
       
       rgb_uvs[i] = uv;
   }
   
   // Sample the input plate, per component
   vec4 sampled;
   sampled.r = texture2DRect(image1, res * rgb_uvs[0]).r;
   sampled.g = texture2DRect(image1, res * rgb_uvs[1]).g;
   sampled.b = texture2DRect(image1, res * rgb_uvs[2]).b;
   
   // Alpha from the image3's R channel
   sampled.a = texture2DRect(image3, res * rgb_uvs[0]).r;
   
   // and assign to the output
   gl_FragColor.rgba = sampled;
}
