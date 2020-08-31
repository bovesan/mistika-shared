#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 param5;
float adsk_time = float(param5.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
vec2 CENTER = vec2(param5.y, param5.z) * 0.01;
uniform vec3 param2;
float BLADES = float(param2.y) * 1.0;
uniform vec3 param1;
float BIAS = float(param1.x) * 0.01;
uniform vec3 param4;
float SHARPNESS = float(param4.y) * 0.01;
uniform vec3 param6;
vec3 COLOR = vec3(param6.x, param6.y, param6.z) * 0.01;
uniform vec3 param7;
vec3 BKG = vec3(param7.x, param7.y, param7.z) * 0.01;
float SPEED = float(param4.z) * 0.01;
float time = adsk_time * SPEED;
vec2 rezolution = vec2 (adsk_result_w, adsk_result_h);

void main( void ) {

vec2 position = (( gl_FragCoord.xy / rezolution.xy ) - CENTER) / vec2(rezolution.y/rezolution.x,1.0);
vec3 color = vec3(0.);

float blade = clamp(pow(sin(time+atan(position.y,position.x)*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);

color = mix(vec3(COLOR), vec3(BKG), blade);

gl_FragColor = vec4( color, 1.0 );

}
