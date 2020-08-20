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
    vec4 p = texture2DRect(image1, gl_TexCoord[0].xy);
    p.a = p.r + p.g + p.b;
    gl_FragColor = p;
}
