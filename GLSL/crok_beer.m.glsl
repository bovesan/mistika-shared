uniform vec3 param7;
float adsk_time = float(param7.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

float time = adsk_time*.05;

uniform sampler2DRect image1;

uniform vec3 param4;
float sphsize = float(param4.y) * 0.01;
uniform vec3 param1;
float dist = float(param1.z) * 0.01;
float perturb = float(param1.y) * 0.1;
float stepsize = float(param4.z) * 0.01;
uniform vec3 param6;
float brightness = float(param6.x) * 0.01;
uniform vec3 param8;
vec3 tint = vec3(param7.y, param7.z, param8.x) * 0.01;
uniform vec3 param9;
vec3 Speed = vec3(param8.y, param8.z, param9.x) * 0.01;
float fade = float(param6.z) * 0.01;
float glow = float(param6.y) * 0.01;
int iterations = int(param1.x);
vec2 center = vec2(param9.y, param9.z) * 0.01;
float size = float(param4.x) * 0.01;
uniform vec3 param2;
float fractparam = float(param2.x) * 0.01;

const vec3 offset=vec3(20.54,142.,-1.55);
const float steps = 16.0;
const float displacement = 1.0;


float wind(vec3 p) {
    float d=max(0.,dist-max(0.,length(p)-sphsize)/sphsize)/dist;
    float x=max(0.2,p.x*2.);
    p.y*=1.+max(0.,-p.x-sphsize*.25)*1.5;
    p-=d*normalize(p)*perturb;
    p+=vec3(time*Speed.x,time*Speed.y,time*Speed.z);
    p=abs(fract((p+offset)*.1)-.5);
    for (int i=0; i<iterations; i++) {  
        p=abs(p)/dot(p,p)-fractparam;
    }
    return length(p)*(1.2+d*glow*x)+d*glow*x;
}

void main(void)
{
    vec2 uv = 0.15 * size * ( 2.0 * gl_FragCoord.xy - resolution.xy ) / (0.5 * (resolution.x + resolution.y)) - center;
    vec3 dir=vec3(uv,1.);
    dir.x*=resolution.x/resolution.y;
    vec3 from=vec3(0., res *0., res *-2.+texture2DRect(image1,uv*.5+time).x*0.07*stepsize); //from+dither
    float v=0., l=-0.0001, t=time*Speed.x*.2;
    vec3 p;
    float tx;
    for (float r=10.;r<steps;r++) {
        p=from+r*dir*0.07*stepsize;
        tx=texture2DRect(image1, res *uv*.2+vec2(t,0.)).x*displacement;
        
        v+=min(50.,wind(p))*max(0.,1. - 0.7 - r*0.015*fade); 
    }
    
    v/=steps; v*=brightness;
    vec3 col=vec3(v*tint.r,v*tint.g,v*tint.b);

    col *= (0.75-length(sqrt(3.0 * uv*uv)));
    col *= length(col) * 50.0;
    gl_FragColor = vec4(col,1.0);
}