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
    float y = p.r;
    float u = p.g;
    float v = p.b;
    float a = p.a;
    
    u -= 0.5;
    v -= 0.5;
    float r = y * 1.0 + u *  0.0     + v *  1.13983; 
    float g = y * 1.0 + u * -0.39465 + v * -0.58060; 
    float b = y * 1.0 + u *  2.03211 + v *  0.0; 

    gl_FragColor = vec4(r, g, b, a);
}
