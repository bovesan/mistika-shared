#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2013
// bove@bengtove.com/bengtove@hocusfocus.no

uniform sampler2DRect image1;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    vec2 res = textureSize(image1);
    vec4 tp;
    float cropLeft = param1.x * 0.01 * res.x;
    float cropRight = param1.y * 0.01 * res.x;
    float cropUp = param1.z * 0.01 * res.y;
    float cropDown = param2.x * 0.01 * res.y;
    float x = gl_TexCoord[0].x;
    float y = gl_TexCoord[0].y;
    float tx, ty;
    if (x < cropLeft){
        tx = cropLeft;
        }
    tx = min(max(x, cropLeft), cropRight);
    ty = min(max(y, cropDown), cropUp);
    tp = texture2DRect(image1, vec2(tx, ty));
    gl_FragColor = tp;
}
