#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2011 - 2012
// bove@bengtove.com

uniform sampler2DRect image;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    if(gl_TexCoord[0].y > 1.0)
    {
	gl_FragColor = vec4(0, 0, 0, 0);
    }
    else
    { 
    int count = 0;
    vec4 total = vec4(0);
    vec2 res = vec2(textureSize(image));
    for(int y = 0; y <= res.y; y++)
	{
	    total += (texture2DRect(image, vec2(1, y)));
	    count ++;
	}
    
    gl_FragColor = total / float(count);
    }
}
