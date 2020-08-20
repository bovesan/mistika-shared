#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2DRect image;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    vec4 p = texture2DRect(image, gl_TexCoord[0].xy);   
    float r = p.r;
    float g = p.g;
    float b = p.b;
    float a = p.a;
    
    float y = r *  0.299   + g * 0.587    + b * 0.114; 
    float u = r * -0.14713 + g * -0.28886 + b * 0.436; 
    float v = r * 0.615    + g * -0.51499 + b * -0.10001; 
    u += 0.5;
    v += 0.5;
 
    gl_FragColor = vec4(y, u, v, a);
}
