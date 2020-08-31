vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform sampler2DRect image1;
uniform vec3 param1;
float Exposure = float(param1.x) * 0.01;
float amount = float(param1.y) * 0.01;

float Red = float(param1.z) * 0.01;
uniform vec3 param2;
float Green = float(param2.x) * 0.01;
float Blue = float(param2.y) * 0.01;

vec3 RGB_lum = vec3(Red, Green, Blue);
const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

void main (void) 
{         
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 tc = texture2DRect(image1, res * uv);
    vec4 tc_new = tc * (exp2(tc)*vec4(Exposure));
    vec4 RGB_lum = vec4(lumcoeff * RGB_lum, 0.0 );
    float lum = dot(tc_new,RGB_lum);
    vec4 luma = vec4(lum);
    gl_FragColor = mix(tc, luma, amount);
} 
