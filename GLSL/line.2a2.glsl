#version 330 compatibility

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2013
// bove@bengtove.com

uniform sampler2DRect image1;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
	vec4 pipe, p1, p2;
    vec2 vab, abl, v1, vp, s,v,w, res, co, cs;
    float d, th, soft, core, m, a, ep1, ep2, tp, t, extend, start, end, athick, bthick, thx;
	
    res = textureSize(image1);
	a = res.x/res.y;
    athick = param1.z;
    bthick = param2.z;
	th = param3.x;
	soft = param3.y;
	extend = param3.z;
	start = param4.x;
	end = param4.y;
	v = vec2((param1.x*0.5 + 50.0*a) * 0.01 * res.y, (param1.y*0.5 + 50.0) * 0.01 * res.y);
	w = vec2((param2.x*0.5 + 50.0*a) * 0.01 * res.y, (param2.y*0.5 + 50.0) * 0.01 * res.y);
    co = gl_FragCoord.xy;
    
    
   float l2 = pow(abs(v.x-w.x),2.0)+pow(abs(v.y-w.y),2.0);
   t = 0.0;
   if (l2 == 0.0) {
   d = distance(co, v);
   } else {
   t = dot(co-v,w-v) / l2;
   
   
   if (t < start) {
       d = distance(co,v);
   } else if (t > end) {
       d = distance(co,w);
   } else {
       vec2 proj = v + t * (w-v);
       d = distance(co,proj);
   }
   }
      thx = athick*(1-t) + bthick*(t);

    if (d<thx){
		tp = min(max(t, 0.0), 1.0);
		if (extend < 1.0) {
			pipe = texture2DRect(image1, vec2(t*res.x, 0.0));
		} else {
			pipe = texture2DRect(image1, vec2(t*distance(v,w), 0.0));
		}
		// pipe = tp * p1 + (1.0-tp) * p2;
        m = (thx-d)/soft;
        if (thx-d < soft) {
            pipe *= m;
            
        } else {
            pipe.a *= 1.0;
        }
    }
    
    gl_FragColor = pipe;
    
}
