uniform vec3 param3;
float adsk_time = float(param3.y) * 1.0;
uniform vec3 param1;
float speed = float(param1.z) * 0.01;
uniform vec3 param2;
float offset = float(param2.x) * 0.01;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param4;
vec3 color_1 = vec3(param3.z, param4.x, param4.y) * 0.01;
float zoom = float(param1.y) * 0.01;
float itterations = float(param1.x) * 0.001;
float time = adsk_time*.025 * speed + offset;
#define PI 3.14159
#define TWO_PI (PI*2.0)
void main(void) 
{
    vec2 center = (gl_FragCoord.xy);
    center.x=-0.12*sin(time/200.0);
    center.y=-100.12*cos(time/200.0);
    vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * zoom;
    v.x=v.x-200.0;
    v.y=v.y-200.0;
    float col = 0.0;
    for(float i = 0.0; i < itterations; i++) 
    {
          float a = i * (TWO_PI/itterations) * 61.95;
        col += cos(TWO_PI*(v.y * cos(a) + v.x * sin(a) + sin(time*0.004)*100.0 ));
    }
    gl_FragColor = vec4(col*color_1.r, col*color_1.g, col*color_1.b, 1.0);
}