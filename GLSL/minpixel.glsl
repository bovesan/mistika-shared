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
    if((gl_TexCoord[0].x > 1.0) || (gl_TexCoord[0].y > 1.0))
    {
	gl_FragColor = vec4(0, 0, 0, 0);
    }
    else
    {
    int count = 0;
    vec4 firstpixel = texture2DRect(image, vec2(0, 0));
    float minR = firstpixel.r;
    float minG = firstpixel.g;
    float minB = firstpixel.b;
    float minA = firstpixel.a;
    vec2 res = vec2(textureSize(image));
    for(int x = 0; x <= res.x; x++)
    {
	for(int y = 0; y <= res.y; y++)
	{
	    vec4 pixel = texture2DRect(image, vec2(x, y));
	    if (pixel.r < minR) {
		minR = pixel.r;
	    }
	    if (pixel.g < minG) {
		minG = pixel.g;
	    }
	    if (pixel.b < minB) {
		minB = pixel.b;
	    }
	    if (pixel.a < minA) {
		minA = pixel.a;
	    }
	}
    }
    gl_FragColor = vec4(minR, minG, minB, minA);
    }
}
