#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2013
// bove@bengtove.com/bengtove@hocusfocus.no
// based off of: https://bitbucket.org/druidsbane/ibex/src/79833cff837e/resources/shaders/distortions.f.glsl

uniform sampler2DRect image1;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    vec2 res = textureSize(image1);
	bool ignoreleft = param1.r;
	bool ignoreright = param1.g;
	bool ignoretop = param1.b;
	bool ignorebottom = param2.r;
	float alphaoutput = param2.g;
    vec4 tpix;
	vec2 pos = gl_TexCoord[0].xy;
    vec2 p = pos / res;
	vec4 ipix = texture2DRect(image1, gl_TexCoord[0].xy);
	if (ipix.a >= 1.0) {
		tpix = ipix;
	} else {
		vec4 spix = ipix;
		
		vec2 search;
		vec4 sourcepix;
		float sourcew;
		
		if (ignoreleft < 1) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.x > 0.0) {
				search += vec2(-1.0, 0.0);
				spix = texture2DRect(image1, search);
				if (spix.a >= 1.0) {
					sourcepix = spix;
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (ignoreright < 1) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.x < res.x) {
				search += vec2(1.0, 0.0);
				spix = texture2DRect(image1, search);
				if (spix.a >= 1.0) {
					sourcepix = spix;
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (ignoretop < 1) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.y > 0.0) {
				search += vec2(0.0, -1.0);
				spix = texture2DRect(image1, search);
				if (spix.a >= 1.0) {
					sourcepix = spix;
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (ignorebottom < 1) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.y < res.y) {
				search += vec2(0.0, 1.0);
				spix = texture2DRect(image1, search);
				if (spix.a >= 1.0) {
					sourcepix = spix;
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (tpix.a > 0.0) {
			tpix /= tpix.a;
			tpix = tpix * (1.0 - ipix.a) + ipix*ipix.a;
		} else {
			tpix = ipix*ipix.a;
		}			
		
	}
	if (alphaoutput == 0) {
		tpix.a  = ipix.a;
	} else if (alphaoutput <= 1) {
		tpix.a = (1.0 - ipix.a);
	} else {
		tpix.a = 1.0;
	}
    gl_FragColor = tpix;
}
