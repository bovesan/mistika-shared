#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2014
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
	vec2 pixelsize = vec2(1.0) / res;
	vec2 coord = gl_TexCoord[0].xy;
	vec2 coordb = coord * pixelsize * 100.0;
	vec4 ip = texture2DRect(image1, coord);
	vec4 op = ip;
	vec2 target = param1.xy;
	float thickness = param1.z * 100;
	float soft = param2.x;
	float opacity = param2.y * 0.01;
	float gapradius = param2.z * 1000.0;
	vec3 color = param3 * 0.01;
    if (abs(coordb.x - target.x) < thickness * pixelsize.x || abs(coordb.y - target.y) < thickness * pixelsize.y) {
		if (abs(coordb.x - target.x) > gapradius * pixelsize.x || abs(coordb.y - target.y) > gapradius * pixelsize.y) {
			op.rgb = ip.rgb * (1.0 - opacity) + color * opacity;
		}
	}
    gl_FragColor = op;
}
