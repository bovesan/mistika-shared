#version 330 compatibility

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2012-2013
// bove@bengtove.com

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform sampler2DRect image4;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;


void main()
{
    float rand = param1.r;
    if (rand < 1) {
        gl_FragColor = texture2DRect(image1, gl_TexCoord[0].xy);
    } else if (rand < 2) {
        gl_FragColor = texture2DRect(image2, gl_TexCoord[0].xy);
    } else if (rand < 3) {
        gl_FragColor = texture2DRect(image3, gl_TexCoord[0].xy);
    } else {
        gl_FragColor = texture2DRect(image4, gl_TexCoord[0].xy);
    }
}
