#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2014
// bovesan.com
// bengtove@hocusfocus.no

uniform sampler2DRect image1;
uniform sampler2DRect image2;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    vec2 res = gl_TexCoord[0].zw;
	bool ignoreleft = bool(param1.r);
	bool ignoreright = bool(param1.g);
    // Top and bottom are switched. Will not fix in this version.
	bool ignoretop = bool(param1.b);
	bool ignorebottom = bool(param2.r);
	bool secondaryInput = bool(param2.g);
	float alphaoutput = param2.b;
	bool flipmask = bool(param4.g);
    vec4 tpix = vec4(0.0);
	vec2 pos = gl_TexCoord[0].xy;
    vec2 p = pos / res;
	vec4 ipix = texture2DRect(image1, gl_TexCoord[0].xy);
	if (flipmask) {
		ipix.a = 1.0 - ipix.a;
	}
	if (ipix.a >= 1.0) {
		tpix = ipix;
	} else {
		vec4 spix = ipix;
		
		vec2 search;
		vec4 sourcepix;
		float sourcew;
		
		if (!ignoreleft) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.x > 0.0) {
				search += vec2(-1.0, 0.0);
				spix = texture2DRect(image1, search);
				if (flipmask) {
					spix.a = 1.0 - spix.a;
				}
				if (spix.a >= 1.0) {
					if (secondaryInput) {
						sourcepix = texture2DRect(image2, search);
					} else {
						sourcepix = texture2DRect(image1, search);
					}
					if (flipmask) {
						sourcepix.a = 1.0 - sourcepix.a;
					}
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (!ignoreright) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.x < res.x) {
				search += vec2(1.0, 0.0);
				spix = texture2DRect(image1, search);
				if (flipmask) {
					spix.a = 1.0 - spix.a;
				}
				if (spix.a >= 1.0) {
					if (secondaryInput) {
						sourcepix = texture2DRect(image2, search);
					} else {
						sourcepix = texture2DRect(image1, search);
					}
					if (flipmask) {
						sourcepix.a = 1.0 - sourcepix.a;
					}
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (!ignoretop) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.y > 0.0) {
				search += vec2(0.0, -1.0);
				spix = texture2DRect(image1, search);
				if (flipmask) {
					spix.a = 1.0 - spix.a;
				}
				if (spix.a >= 1.0) {
					if (secondaryInput) {
						sourcepix = texture2DRect(image2, search);
					} else {
						sourcepix = texture2DRect(image1, search);
					}
					if (flipmask) {
						sourcepix.a = 1.0 - sourcepix.a;
					}
					sourcew = distance(pos, search);
					tpix += sourcepix / sourcew;
					break;
				}
			}
		}
		
		if (!ignorebottom) {
			search = pos;
			sourcepix = vec4(0.0);
			sourcew = 0.0;
			while (search.y < res.y) {
				search += vec2(0.0, 1.0);
				spix = texture2DRect(image1, search);
				if (flipmask) {
					spix.a = 1.0 - spix.a;
				}
				if (spix.a >= 1.0) {
					if (secondaryInput) {
						sourcepix = texture2DRect(image2, search);
					} else {
						sourcepix = texture2DRect(image1, search);
					}
					if (flipmask) {
						sourcepix.a = 1.0 - sourcepix.a;
					}
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
