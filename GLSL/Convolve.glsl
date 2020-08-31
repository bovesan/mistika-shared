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

void main()
{    
    int r = 5;
    float x = gl_TexCoord[0].x;
    float y = gl_TexCoord[0].y;
    vec4 sum = vec4(0.0);
    for(int dy = -r; dy <= +r; dy++)
    	for(int dx = -r; dx <= +r; dx++) 
    	    sum += texture2DRect(image1, vec2(x+dx, y+dy)); 
    int count = (r*2+1)*(r*2+1);
    sum *= vec4(1.0 / float(count));
    gl_FragColor = sum;
}
