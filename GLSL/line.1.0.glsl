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
    vec4 pipe = vec4(0.0), p1 = vec4(0.0), p2 = vec4(0.0);
    vec2 vab = vec2(0.0), abl = vec2(0.0), v1 = vec2(0.0), vp = vec2(0.0), s = vec2(0.0),v = vec2(0.0),w = vec2(0.0), res = vec2(0.0), co = vec2(0.0), cs = vec2(0.0);
    float d = 0.0, th = 0.0, soft = 0.0, core = 0.0, m = 0.0, a = 0.0, ep1 = 0.0, ep2 = 0.0, tp = 0.0, t = 0.0, extend = 0.0;
	
    res = textureSize(image1);
	a = res.x/res.y;
	th = param1.x;
	soft = param1.y;
	extend = param1.z;
	ep1 = param2.z;
	ep2 = param3.z;
	v = vec2((param2.x*0.5 + 50.0*a) * 0.01 * res.y, (param2.y*0.5 + 50.0) * 0.01 * res.y);
	w = (param3.xy*0.5 + 50.0) * 0.01 * cs;
	w = vec2((param3.x*0.5 + 50.0*a) * 0.01 * res.y, (param3.y*0.5 + 50.0) * 0.01 * res.y);
    co = gl_FragCoord.xy;
    
    
   float l2 = pow(abs(v.x-w.x),2.0)+pow(abs(v.y-w.y),2.0);
   t = 0.0;
   if (l2 == 0.0) {
   d = distance(co, v);
   } else {
   t = dot(co-v,w-v) / l2;
   
   
   if (ep1 < 1 && t < 0.0) {
       d = distance(co,v);
   } else if (ep2 < 1 && t > 1.0) {
       d = distance(co,w);
   } else {
       vec2 proj = v + t * (w-v);
       d = distance(co,proj);
   }
   }
  
    if (d<th){
		tp = min(max(t, 0.0), 1.0);
		if (extend < 1.0) {
			pipe = texture2DRect(image1, vec2(t*res.x, 0.0));
		} else {
			pipe = texture2DRect(image1, vec2(t*distance(v,w), 0.0));
		}
		// pipe = tp * p1 + (1.0-tp) * p2;
        m = (th-d)/soft;
        if (th-d < soft) {
            pipe *= m;
            
        } else {
            pipe.a *= 1.0;
        }
    }
    
    gl_FragColor = pipe;
    
}