#version 120

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param4;
float adsk_result_frameratio = float(param4.y) * 1.0;
uniform vec3 param1;
float rot = float(param1.y) * 0.1;
float zoom = float(param1.x) * 0.01;
float blur = float(param4.x) * 0.01;
float Aspect = float(param1.z) * 0.01;
uniform vec3 param5;
vec3 color1 = vec3(param4.z, param5.x, param5.y) * 0.01;
uniform vec3 param6;
vec3 color2 = vec3(param5.z, param6.x, param6.y) * 0.01;
#define PI 3.14159265359


    
void main(void)
{
    vec2 uv = ((gl_FragCoord.xy / resolution.xy) - 0.5);
    float bl = 0.0;

    if ( rot != 0.0 )
        bl += blur; 

    float b = bl * zoom / resolution.x;

    uv.x *= adsk_result_frameratio;
    // degrees to radians conversion
    float rad_rot = rot * PI / 180.0; 

    // rotation
    mat2 rotation = mat2( cos(-rad_rot), -sin(-rad_rot), sin(-rad_rot), cos(-rad_rot));
    uv *= rotation;
    
    uv.x *= Aspect;
    uv *= zoom;
    
    
    vec2 anti_a = sin(PI * uv);
    vec2 square = smoothstep( -b, b, anti_a );
    square = 2.0 * square - 1.0;                        
    float a = 0.5 * (square.x * square.y) + 0.5;
    vec3 c = mix(color1, color2, a); 
    gl_FragColor = vec4(c, a);
}