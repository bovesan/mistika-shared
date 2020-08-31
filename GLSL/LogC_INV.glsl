#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2DRect image;

float logCi(float t)
{
    float x1 =  (t > 0.149658) ? exp((t - 0.385537) / 0.107353233) : (t / 0.9661776 - 0.04378604);
    float x2 = x1 * 0.18 - 0.00937677;
    return x2;
}

void main()
{
    vec4 p = texture2DRect(image, gl_TexCoord[0].xy);   
    gl_FragColor = vec4(logCi(p.r), logCi(p.g), logCi(p.b), p.a);
}
