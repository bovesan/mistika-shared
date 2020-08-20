#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2012-2015
// bove@bengtove.com

uniform sampler2DRect image1;
uniform sampler2DRect image2;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

struct Jitter
{
  float first;
  float second;
};

void main()
{
    float scaleX = param1.y * 0.01;
    float scaleY = param1.z * 0.01;
    float xChannel = param2.x;
    bool xInvert = param2.y == 1;
    float xOffset = param2.z * 0.01;
    float yChannel = param3.x;
    bool yInvert = param3.y == 1;
    float yOffset = param3.z * 0.01;
    vec2 res = textureSize(image1);
    vec4 p = texture2DRect(image1, gl_TexCoord[0].xy);
    vec4 tp;
    float x;
    if (xChannel < 1) {
        x = p.r;
    } else if  (xChannel < 2) {
        x = p.g;
    } else if  (xChannel < 3) {
        x = p.b;
    } else {
        x = p.a;
    }
    if (xInvert) {
        x = 1.0-x;
    }
    x /= scaleX;
    x += xOffset;
    float y;
    if (yChannel < 1) {
        y = p.r;
    } else if  (yChannel < 2) {
        y = p.g;
    } else if  (yChannel < 3) {
        y = p.b;
    } else {
        y = p.a;
    }
    if (yInvert) {
        y = 1.0-y;
    }
    y /= scaleY;
    y += yOffset;
    vec2 xy = vec2(x*res.x, y*res.y);
    if (param1.r < 1) {
        tp = texture2DRect(image2, xy);
	} else if (param1.r < 2) {
		tp = vec4(0);
		vec2 jitter[2] = vec2[2](
			vec2( 0.246490,  0.249999),
			vec2(-0.246490, -0.249999)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else if (param1.r < 3) {
		vec2 jitter[3] = vec2[3](
			vec2(-0.373411, -0.250550),
			vec2( 0.256263,  0.368119),
			vec2( 0.117148, -0.117570)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else if (param1.r < 4) {
		vec2 jitter[4] = vec2[4](
			vec2(-0.208147,  0.353730),
			vec2( 0.203849, -0.353780),
			vec2(-0.292626, -0.149945),
			vec2( 0.296924,  0.149994)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else if (param1.r < 5) {
		vec2 jitter[8] = vec2[8](
			vec2(-0.334818,  0.435331),
			vec2( 0.286438, -0.393495),
			vec2( 0.459462,  0.141540),
			vec2(-0.414498, -0.192829),
			vec2(-0.183790,  0.082102),
			vec2(-0.079263, -0.317383),
			vec2( 0.102254,  0.299133),
			vec2( 0.164216, -0.054399)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else if (param1.r < 6) {
		vec2 jitter[15] = vec2[15](
			vec2( 0.285561,  0.188437),
			vec2( 0.360176, -0.065688),
			vec2(-0.111751,  0.275019),
			vec2(-0.055918, -0.215197),
			vec2(-0.080231, -0.470965),
			vec2( 0.138721,  0.409168),
			vec2( 0.384120,  0.458500),
			vec2(-0.454968,  0.134088),
			vec2( 0.179271, -0.331196),
			vec2(-0.307049, -0.364927),
			vec2( 0.105354, -0.010099),
			vec2(-0.154180,  0.021794),
			vec2(-0.370135, -0.116425),
			vec2( 0.451636, -0.300013),
			vec2(-0.370610,  0.387504)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else if (param1.r < 7) {
		vec2 jitter[24] = vec2[24](
			vec2( 0.030245,  0.136384),
			vec2( 0.018865, -0.348867),
			vec2(-0.350114, -0.472309),
			vec2( 0.222181,  0.149524),
			vec2(-0.393670, -0.266873),
			vec2( 0.404568,  0.230436),
			vec2( 0.098381,  0.465337),
			vec2( 0.462671,  0.442116),
			vec2( 0.400373, -0.212720),
			vec2(-0.409988,  0.263345),
			vec2(-0.115878, -0.001981),
			vec2( 0.348425, -0.009237),
			vec2(-0.464016,  0.066467),
			vec2(-0.138674, -0.468006),
			vec2( 0.144932, -0.022780),
			vec2(-0.250195,  0.150161),
			vec2(-0.181400, -0.264219),
			vec2( 0.196097, -0.234139),
			vec2(-0.311082, -0.078815),
			vec2( 0.268379,  0.366778),
			vec2(-0.040601,  0.327109),
			vec2(-0.234392,  0.354659),
			vec2(-0.003102, -0.154402),
			vec2( 0.297997, -0.417965)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	} else {
		vec2 jitter[66] = vec2[66](
			vec2( 0.266377, -0.218171),
			vec2(-0.170919, -0.429368),
			vec2( 0.047356, -0.387135),
			vec2(-0.430063,  0.363413),
			vec2(-0.221638, -0.313768),
			vec2( 0.124758, -0.197109),
			vec2(-0.400021,  0.482195),
			vec2( 0.247882,  0.152010),
			vec2(-0.286709, -0.470214),
			vec2(-0.426790,  0.004977),
			vec2(-0.361249, -0.104549),
			vec2(-0.040643,  0.123453),
			vec2(-0.189296,  0.438963),
			vec2(-0.453521, -0.299889),
			vec2( 0.408216, -0.457699),
			vec2( 0.328973, -0.101914),
			vec2(-0.055540, -0.477952),
			vec2( 0.194421,  0.453510),
			vec2( 0.404051,  0.224974),
			vec2( 0.310136,  0.419700),
			vec2(-0.021743,  0.403898),
			vec2(-0.466210,  0.248839),
			vec2( 0.341369,  0.081490),
			vec2( 0.124156, -0.016859),
			vec2(-0.461321, -0.176661),
			vec2( 0.013210,  0.234401),
			vec2( 0.174258, -0.311854),
			vec2( 0.294061,  0.263364),
			vec2(-0.114836,  0.328189),
			vec2( 0.041206, -0.106205),
			vec2( 0.079227,  0.345021),
			vec2(-0.109319, -0.242380),
			vec2( 0.425005, -0.332397),
			vec2( 0.009146,  0.015098),
			vec2(-0.339084, -0.355707),
			vec2(-0.224596, -0.189548),
			vec2( 0.083475,  0.117028),
			vec2( 0.295962, -0.334699),
			vec2( 0.452998,  0.025397),
			vec2( 0.206511, -0.104668),
			vec2( 0.447544, -0.096004),
			vec2(-0.108006, -0.002471),
			vec2(-0.380810,  0.130036),
			vec2(-0.242440,  0.186934),
			vec2(-0.200363,  0.070863),
			vec2(-0.344844, -0.230814),
			vec2( 0.408660,  0.345826),
			vec2(-0.233016,  0.305203),
			vec2( 0.158475, -0.430762),
			vec2( 0.486972,  0.139163),
			vec2(-0.301610,  0.009319),
			vec2( 0.282245, -0.458671),
			vec2( 0.482046,  0.443890),
			vec2(-0.121527,  0.210223),
			vec2(-0.477606, -0.424878),
			vec2(-0.083941, -0.121440),
			vec2(-0.345773,  0.253779),
			vec2( 0.234646,  0.034549),
			vec2( 0.394102, -0.210901),
			vec2(-0.312571,  0.397656),
			vec2( 0.200906,  0.333293),
			vec2( 0.018703, -0.261792),
			vec2(-0.209349, -0.065383),
			vec2( 0.076248,  0.478538),
			vec2(-0.073036, -0.355064),
			vec2( 0.145087,  0.221726)
		);
		float m = 1.0 / jitter.length();
		for(int i=0;i<jitter.length();i++)
		{
		  tp += texture2DRect(image2, xy+jitter[i]) * m;
		}
	}
    gl_FragColor = vec4(tp);
}
