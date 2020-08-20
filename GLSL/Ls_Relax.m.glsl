// Relaxxxx
// This actually is mostly just mixing incoming pixels with
// the target colours, which is equivalent to a pivoted contrast
// sort of operator.  I really miss ContrastRGB from Shake, basically
// lewis@lewissaunders.com

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param8;
vec3 mastercolour = vec3(param8.x, param8.y, param8.z) * 0.01;
uniform vec3 param9;
vec3 shadowcolour = vec3(param9.x, param9.y, param9.z) * 0.01;
uniform vec3 param10;
vec3 midtonecolour = vec3(param10.x, param10.y, param10.z) * 0.01;
uniform vec3 param11;
vec3 highlightcolour = vec3(param11.x, param11.y, param11.z) * 0.01;
uniform vec3 param5;
float mastercontrast = float(param5.z) * 0.01;
uniform vec3 param1;
float shadowtweak = float(param1.y) * 0.01;
uniform vec3 param2;
float midtonetweak = float(param2.z) * 0.01;
uniform vec3 param4;
float highlighttweak = float(param4.y) * 0.01;
float shadowrestore = float(param1.x) * 0.01;
float highlightrestore = float(param4.x) * 0.01;
uniform vec3 param7;
float midtonesat = float(param7.x) * 0.01;
float mixx = float(param7.z) * 0.01;
bool showranges = bool(param7.y);
uniform sampler2DRect image1;
uniform sampler2DRect image2;

float adsk_getLuminance(vec3 rgb);
float adsk_highlights(float lum, float mid);
float adsk_shadows(float lum, float mid);

void main() {
  vec2 uv = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);
  vec3 f = texture2DRect(image1, res * uv).rgb;
  float m = texture2DRect(image2, res * uv).b;

  vec3 mastermisted = mix(f, mastercolour, 1.0 - mastercontrast);

  float fluma = adsk_getLuminance(f);
  float shadowness = adsk_shadows(fluma, mix(midtonesat, 0.0, 0.5));
  float highlightness = adsk_highlights(fluma, mix(midtonesat, 1.0, 0.5));
  float midtoneness = 1.0 - (shadowness + highlightness);

  vec3 shadowrestored = mix(mastermisted, f, shadowrestore * shadowness);
  vec3 restored = mix(shadowrestored, f, highlightrestore * highlightness);

  vec3 shadowtweaked = mix(restored, shadowcolour, shadowtweak);
  vec3 midtonetweaked = mix(restored, midtonecolour, midtonetweak);
  vec3 highlighttweaked = mix(restored, highlightcolour, highlighttweak);

  vec3 alltonestweaked = shadowness * shadowtweaked + midtoneness * midtonetweaked + highlightness * highlighttweaked;

  vec3 matted = mix(f, alltonestweaked, m * mixx);

  if(showranges) {
    matted = vec3(shadowness, midtoneness, highlightness);
  }

  gl_FragColor = vec4(matted, m);
}
