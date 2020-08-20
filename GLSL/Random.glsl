#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform sampler2DRect image4;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;
uniform ivec4 randomValues;

void main()
{
    float x = gl_TexCoord[0].x;
    float y = gl_TexCoord[0].y;
    //create random values in scale 0..2*PI
    float scale = 3.14159 * 2.0 / 65535.0;
    float r1 = float(randomValues.x & 65535) * scale;
    float r2 = float(randomValues.y & 65535) * scale;
    float r3 = float(randomValues.z & 65535) * scale;
    float r4 = float(randomValues.w & 65535) * scale;
    float wave = sin((x+0.3*y) * 0.21 + r1) + sin((y+0.3*x) * 0.23 + r2)
               + sin((x-0.3*y) * 0.29 + r3) + sin((y-0.3*x) * 0.31 + r4);
    gl_FragColor = texture2DRect(image1, gl_TexCoord[0].xy) + vec4(wave * 0.25);
}
