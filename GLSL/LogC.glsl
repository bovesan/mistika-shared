#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2DRect image;

float logC(float x2)
{
   float x1 = (x2 + 0.00937677) / 0.18;
   float t = (x1 > 0.11111111) ? log(x1) * 0.107353233 + 0.385537 : (x1 + 0.04378604) * 0.9661776;
   return t;
}

void main()
{
    vec4 p = texture2DRect(image, gl_TexCoord[0].xy);
    gl_FragColor = vec4(logC(p.r), logC(p.g), logC(p.b), p.a);
}
