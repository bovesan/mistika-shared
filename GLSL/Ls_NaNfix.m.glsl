// NaNfix - interpolate NaN pixels from surroundings
// lewis@lewissaunders.com 

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect image1;
uniform vec3 param2;
uniform vec3 param3;
vec3 tempcolour = vec3(param2.y, param2.z, param3.x) * 0.01;
uniform vec3 param1;
int radius = int(param1.x);

bool isnan(float f) {
  // Try a few things.  Some drivers optimise some of them away :/
  if(f != f) {
    return true;
  }
  if(f < 0.0 || 0.0 < f || f == 0.0) {
    return false;
  } else {
    return true;
  }
}

bool anynans(vec3 v) {
  if(isnan(v.r)) return true;
  if(isnan(v.g)) return true;
  if(isnan(v.b)) return true;
  return false;
}

void main() {
    vec2 xy = gl_FragCoord.xy;

    vec3 o = texture2DRect(image1, res * xy / res).rgb;
    float m = 0.0;
    
    if(anynans(o)) {
      o = vec3(0.0);
      m = 1.0;
      float count = 0.0;
      float r = float(radius);
      for(float i = -r; i <= r; i += 1.0) {
        for(float j = -r; j <= r; j += 1.0) {
          vec3 here = texture2DRect(image1, res * (xy + vec2(i, j))/res).rgb;
          if(!anynans(here)) {
            o += here;
            count += 1.0;
          }
        }
      }
      if(count == 0.0) {
        // Couldn't find any good pixels in surroundings! Output black.
        o = vec3(0.0);
      } else {
        o /= count;
      }
    }
    
    gl_FragColor = vec4(o, m);
}
