
// based on http://glslsandbox.com/e#17361.0

// quick mod :) @paulofalcao
// too many damn distance fields on glsl sandbox,
// how about some volume rendering?!
// @simesgreen

vec3 adsk_getVertexPosition();
vec3 adsk_getCameraPosition();
vec3 adsk_getLightPosition();
vec3 adsk_getLightDirection();
vec3 adsk_getLightTangent();
vec3 adsk_getLightColour();
mat4 adsk_getModelViewMatrix();
mat4 adsk_getModelViewInverseMatrix();
vec3 adsk_getComputedDiffuse();
vec4 adsk_getBlendedValue( int blendType, vec4 srcColor, vec4 dstColor ); 

float adsk_getTime();
float adsk_getLuminance( vec3 rgb );
vec3  adsk_hsv2rgb( vec3 hsv );

uniform vec3 param10;
vec3 adskUID_colourWheel1 = vec3(param10.x, param10.y, param10.z) * 0.1;
uniform vec3 param11;
vec3 adskUID_colourWheel2 = vec3(param11.x, param11.y, param11.z) * 0.1;
uniform vec3 param12;
vec3 adskUID_colourWheel3 = vec3(param12.x, param12.y, param12.z) * 0.1;

uniform vec3 param4;
float adskUID_Speed = float(param4.y) * 0.01;
uniform vec3 param13;
float adskUID_Offset = float(param13.x) * 1.0;
float adskUID_Noise = float(param13.y) * 1.0;
uniform vec3 param5;
float adskUID_brightness = float(param5.x) * 0.01;
float adskUID_contrast = float(param4.z) * 0.01;
float adskUID_saturation = float(param5.y) * 0.01;
uniform vec3 param6;
float adskUID_tint = float(param6.z) * 0.01;
uniform vec3 param14;
vec3 adskUID_tint_col = vec3(param13.z, param14.x, param14.y) * 0.01;

uniform vec3 param1;
int adskUID_VolumeSteps = int(param1.x);
float adskUID_StepSize = float(param1.z) * 0.01;
float adskUID_Density = float(param1.y) * 0.01;
uniform vec3 param3;
float adskUID_NoiseFreq = float(param3.x) * 0.01;
uniform vec3 param2;
float adskUID_NoiseAmp = float(param2.z) * 0.01;
uniform vec3 param15;
vec3 adskUID_NoiseAnim = vec3(param14.z, param15.x, param15.y) * 0.01;
float adskUID_SphereRadius = float(param2.x) * 0.01;
int adskUID_blendModes = int(param2.y);


vec2 adskUID_resolution = vec2(1920.0, 1080.0);
float adskUID_time = adsk_getTime() * 0.05 * adskUID_Speed + adskUID_Offset;
const vec3 adskUID_LumCoeff = vec3(0.2125, 0.7154, 0.0721);

// iq's nice integer-less noise function
// matrix to rotate the noise octaves
mat3 adskUID_m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float adskUID_hash( float n )
{
    return fract(sin(n)*43758.5453);
}


float adskUID_noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( adskUID_hash(n+  0.0), adskUID_hash(n+  1.0),f.x),
                        mix( adskUID_hash(n+ 57.0), adskUID_hash(n+ 58.0),f.x),f.y),
                    mix(mix( adskUID_hash(n+113.0), adskUID_hash(n+114.0),f.x),
                        mix( adskUID_hash(n+170.0), adskUID_hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float adskUID_fbm( vec3 p )
{
    float f;
    f = 0.5000*adskUID_noise( p ); p = adskUID_m*p*2.02;
    f += 0.2500*adskUID_noise( p ); p = adskUID_m*p*2.03;
    f += 0.1250*adskUID_noise( p ); p = adskUID_m*p*2.01;
    f += 0.0625*adskUID_noise( p );
    return f;
}


// returns signed distance to surface
float adskUID_distanceFunc(vec3 p)
{    
    float d = length(p) - adskUID_SphereRadius;    // distance to sphere
    
    // offset distance with pyroclastic noise
    d += adskUID_fbm(p*adskUID_NoiseFreq + adskUID_NoiseAnim*adskUID_time) * adskUID_NoiseAmp;
    return d;
}

// We are using this function to map the Hue and Gain of the Colour Wheel in HSV to an RGB value
vec3 adskUID_getRGB( float hue )
{
   return adsk_hsv2rgb( vec3( hue, 1.0, 1.0 ) );
}

// color gradient 
vec4 adskUID_gradient(float x)
{

    vec4 adskUID_c0 = vec4(adskUID_getRGB( adskUID_colourWheel1.x / 360.0 ) * vec3( adskUID_colourWheel1.y * 0.01), adskUID_colourWheel1.z * 0.01);
    vec4 adskUID_c1 = vec4(adskUID_getRGB( adskUID_colourWheel2.x / 360.0 ) * vec3( adskUID_colourWheel2.y * 0.01), adskUID_colourWheel2.z * 0.01);
    vec4 adskUID_c3 = vec4(adskUID_getRGB( adskUID_colourWheel3.x / 360.0 ) * vec3( adskUID_colourWheel3.y * 0.01), adskUID_colourWheel3.z * 0.01);

    const vec4 adskUID_c2 = vec4(0, 0, 0, 0);     // black
    const vec4 adskUID_c4 = vec4(0, 0, 0, 0);     // black
    
    x = clamp(x, 0.0, 0.999);
    float t = fract(x*4.0);
    vec4 c;
    if (x < 0.25) {
        c =  mix(adskUID_c0, adskUID_c1, t);
    } else if (x < 0.5) {
        c = mix(adskUID_c1, adskUID_c2, t);
    } else if (x < 0.75) {
        c = mix(adskUID_c2, adskUID_c3, t);
    } else {
        c = mix(adskUID_c3, adskUID_c4, t);        
    }
    return c;
}

// shade a point based on distance
vec4 adskUID_shade(float d)
{    
    // lookup in color gradient
    return adskUID_gradient(d);
}

// procedural volume
// maps position to color
vec4 adskUID_volumeFunc(vec3 p)
{
    float d = adskUID_distanceFunc(p);
    return adskUID_shade(d);
}

vec4 adskUID_rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos, float z, vec4 lightboxinput)
{
    vec4 sum = vec4(0, 0, 0, 0);
    pos = rayOrigin;
    for(int i=0; i<adskUID_VolumeSteps; i++) {
        vec4 col = adskUID_volumeFunc(pos);
        col.a *= (adskUID_Density * 15.0 ) * adskUID_Density / float( adskUID_VolumeSteps );

        // pre-multiply alpha
        col.rgb *= col.a;
        sum = sum + col*(1.0 - sum.a);


        if(length(pos-rayOrigin) > z) {
            // We've gone beyond our geo depth! Comp the sum so far over the geo
            vec3 bg = lightboxinput.rgb;
            vec3 comp = bg * (1.0 - sum.a) + sum.rgb;
            return vec4(comp, 1.0);
        }

        pos += 10.0*rayStep/float(adskUID_VolumeSteps);
    }
    return sum;
}

vec4 adskUID_lightbox(vec4 i)
{    
    vec3 camera = adsk_getCameraPosition();
    vec3 vertex = adsk_getVertexPosition();
    vec3 light = adsk_getLightPosition();
    vec3 lightdir = adsk_getLightDirection();
    vec3 lighttan = adsk_getLightTangent();
    vec3 lightbitan = cross(lightdir, lighttan);
    mat3 lightbasis = mat3(lighttan, -lightbitan, lightdir);
    vec3 dir = normalize(vertex - camera);
    float z = length(vertex-camera);
    
    vec3 ro = camera - light;
    ro *= lightbasis;
    ro /= 150.0;
    
    vec3 rd = dir * lightbasis;

    ro += rd;

    vec3 hitPos;
    vec4 col = adskUID_rayMarch(ro, rd * adskUID_StepSize, hitPos, z, i);
    
    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(col.rgb, adskUID_LumCoeff));
    vec3 sat_color = mix(intensity, col.rgb, adskUID_saturation);
    vec3 con_color = mix(avg_lum, sat_color, adskUID_contrast);
    vec3 brt_color = con_color - 1.0 + adskUID_brightness;
    vec3 fin_color = mix(brt_color, brt_color * adskUID_tint_col, adskUID_tint);
    fin_color = clamp(fin_color, 0.0, 1.0);
    vec4 out_col = adsk_getBlendedValue( adskUID_blendModes, i, vec4(fin_color.rgb, i.a));
    return vec4(out_col.rgb, i.a) ;
}