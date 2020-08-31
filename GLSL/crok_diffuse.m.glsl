#version 120
// based on https://www.shadertoy.com/view/MdXXWr

uniform sampler2DRect image1;
uniform sampler2DRect image2;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float adsk_time = float(param1.z) * 1.0;
int itteration = int(param1.y);
float size = float(param1.x) * 0.1;


float time = adsk_time *.05;
float cent = 0.0;



float rand1(vec2 a, out float r)
{
    vec3 p = vec3(a,1.0);
    r = fract(sin(dot(p,vec3(37.1,61.7, 12.4)))*3758.5453123);
    return r;
}

float rand2(inout float b)
{
    b = fract((134.324324) * b);
    return (b-0.5)*2.0;
}

void main(void)
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    
    float strength = texture2DRect(image2, res * uv).r;
    float n = size * strength / resolution.x;
    rand1(uv, cent);
    vec4 col = vec4(0.0);
    for(int i=0;i<itteration;i++)
    {
        float noisex = rand2(cent);
        float noisey = rand2(cent);
        col += texture2DRect(image1, res * uv - vec2(noisex, noisey) * n) / float(itteration);
    }
    gl_FragColor = col;
}