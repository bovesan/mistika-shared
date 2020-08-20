#version 120

uniform sampler2DRect image1;
uniform vec3 param3;
float adsk_time = float(param3.y) * 1.0;
float Speed = float(param3.x) * 0.01;
uniform vec3 param2;
float rot = float(param2.z) * 0.01;
uniform vec3 param1;
float intensity = float(param1.x) * 0.01;
float layers = float(param1.z) * 0.01;
float spacing = float(param1.y) * 0.01;
float time = adsk_time *.05 * Speed;

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param4;
vec2 center = vec2(param3.z, param4.x) * 0.01;


void main(void)
{
    vec2 uv = (gl_FragCoord.xy / res.xy) - center;
    vec3 col = vec3(0.0);
    vec3 matte = vec3(1.0);
    
    // rotatation
    float c=cos(rot*0.01),si=sin(rot*0.01);
    uv *=mat2(c,si,-si,c);    

    
    for(float i=0.0; i<layers; i+=1.0) 
    {
        float s=texture2DRect(image1, res *uv*(1.0/i*spacing)+vec2(time)*vec2(0.02,0.501)+vec2(i, i/2.3)).r;
        col=mix(col,vec3(1.0),smoothstep(0.9,1.0, s * intensity));
        matte=mix(matte,vec3(1.0 / i),smoothstep(0.9, 0.91, s * intensity));
    }

    gl_FragColor = vec4(col,matte);
}