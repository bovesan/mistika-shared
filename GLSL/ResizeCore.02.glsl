#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2013
// bove@bengtove.com/bengtove@hocusfocus.no

uniform sampler2DRect image1;
uniform sampler2DRect image2;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    vec2 res = textureSize(image1);
    vec4 tp;
    float x = gl_TexCoord[0].x - param3.x;
    float y = gl_TexCoord[0].y - param3.y;
    float tx, ty;
    float corex = param2.x+(res.x*0.5);
    float corey = param2.y+(res.y*0.5);
    if (distance(x, corex) < param1.x) {
	tx = corex;
    } else if (x < corex) {
	tx = x+param1.x;
    } else if (x > corex) {
	tx = x-param1.x;
    }
    if (distance(y, corey) < param1.y) {
	ty = corey;
    } else if (y < corey) {
	ty = y+param1.y;
    } else if (y > corey) {
	ty = y-param1.y;
    }
    tp = texture2DRect(image1, vec2(tx, ty));
    gl_FragColor = tp;
}
