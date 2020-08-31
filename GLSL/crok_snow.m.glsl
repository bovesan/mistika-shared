uniform vec3 param3;
float adsk_time = float(param3.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param2;
float rot = float(param2.z) * 0.01;
uniform vec3 param4;
vec2 Position = vec2(param4.x, param4.y) * 0.01;

uniform vec3 param1;
int Layers = int(param1.x);
float Depth = float(param1.y) * 0.001;
float Wind = float(param1.z) * 0.001;
float Speed = float(param2.x) * 0.01;
float size = float(param2.y) * 0.02;


vec2 iResolution = vec2(adsk_result_w, adsk_result_h);
float iGlobalTime = adsk_time*.05;

// Copyright (c) 2013 Andrew Baldwin (twitter: baldand, www: http://thndl.com)
// License = Attribution-NonCommercial-ShareAlike (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

// "Just snow"
// Simple (but not cheap) snow made from multiple parallax layers with randomly positioned 
// flakes and directions. Also includes a DoF effect. Pan around with mouse.

void main(void)
{
    const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);
    vec2 uv = (gl_FragCoord.xy / iResolution.xy) - Position;    
    
    float c=cos(rot*0.01),si=sin(rot*0.01);
    uv=(vec2(uv.x- .5, uv.y-1.))*mat2(c,si,-si,c);    
    
    vec3 acc = vec3(0.0);
    float dof = 5.*sin(iGlobalTime*.1);
    for (int i=0;i<Layers;i++) {
        float fi = float(i);
        vec2 q = uv*(1.+fi * Depth);
        q += vec2(q.y*(Wind*mod(fi*7.238917,1.)-Wind*.5),Speed*iGlobalTime/(1.+fi*Depth*.03));
        vec3 n = vec3(floor(q),31.189+fi);
        vec3 m = floor(n)*.00001 + fract(n);
        vec3 mp = (31415.9+m)/fract(p*m);
        vec3 r = fract(mp);
        vec2 s = abs(mod(q,1.)-.5+.9*r.xy-.45);
        s += .01*abs(2. *fract(10.* q.yx)-1.); 
        float d = .6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-.01;
        float edge = .005+.05*min(.5 * abs(fi-5.-dof),1.);
        acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.0 + size/fi)));
    }
    gl_FragColor = vec4(vec3(acc),1.0);
}