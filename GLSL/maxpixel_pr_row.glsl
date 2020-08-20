#version 130

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
    if((gl_TexCoord[0].x > 1.0))
    {
	    gl_FragColor = vec4(0, 0, 0, 0);
    }
    else
    {
        vec2 res = vec2(textureSize(image));
        float maxR = 0.0;
        float maxG = 0.0;
        float maxB = 0.0;
        float maxA = 0.0;
        for(int x = 0; x <= res.x; x++)
        {
            vec4 pixel = texture2DRect(image, vec2(x, gl_TexCoord[0].y));
            if (pixel.r > maxR) {
                maxR = pixel.r;
            }
            if (pixel.g > maxG) {
                maxG = pixel.g;
            }
            if (pixel.b > maxB) {
                maxB = pixel.b;
            }
            if (pixel.a > maxA) {
                maxA = pixel.a;
            }
        }
	}
    gl_FragColor = vec4(maxR, maxG, maxB, maxA);
    }
}
