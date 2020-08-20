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
    vec4 pixel = texture2DRect(image, gl_TexCoord[0].xy);   
    
    float r = pow(pixel.r * param1.x + param1.y, param1.z);
    float g = pow(pixel.g * param2.x + param2.y, param2.z);
    float b = pow(pixel.b * param3.x + param3.y, param3.z);
    float a = pixel.a;
    
    gl_FragColor = vec4(r, g, b, a);
}
