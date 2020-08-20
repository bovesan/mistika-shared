uniform vec3 param3;
float adsk_time = float(param3.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect image1;
uniform vec3 param1;
float Width = float(param1.x) * 0.01;
uniform vec3 param2;
float Speed = float(param2.x) * 0.001;
float Offset = float(param2.y) * 0.001;
float Detail = float(param1.y) * 0.01;
uniform vec3 param4;
vec2 position = vec2(param3.z, param4.x) * 0.01;
float Softness = float(param1.z) * 0.001;



vec2 iResolution = vec2(adsk_result_w, adsk_result_h);
float time = adsk_time*.0005 * Speed + Offset*.2;

// based on https://www.shadertoy.com/view/4dSGDW
// created by Kali in 2013-Dec-22

float Shape=0.;
float Zoom=.18;

vec3 color=vec3(0.),randcol;

void formula(vec2 z, float c) {
    float minit=0.;
    float o,ot2,ot=ot2=10.;
    for (int i=0; i<13; i++) {
        z=abs(z)/clamp(dot(z,z),.1,.5)-c;
        float l=length(z);
        o=min(max(abs(min(z.x,z.y)),-l+.25),abs(l-.25));
        ot=min(ot,o);
        ot2=min(l*.1,ot2);
        minit=max(minit,float(i)*(1.-abs(sign(ot-o))));
    }
    minit+=1.;
    float w=Width*.01*minit*2.;
    float circ=pow(max(0.,w-ot2)/w,6.);
    Shape+=max(pow(max(0.,w-ot)/w,.25),circ);
    vec3 col=normalize(.1+texture2DRect(image1,vec2(minit*.1)).rgb);
    color+=col*(.4+mod(minit/9.-time*10.+ot2*2.,1.)*1.6);
    color+=vec3(1.,.7,.3)*circ*(10.-minit)*3.*smoothstep(0.,.5,.15);
}


void main(void)
{
    vec2 pos = gl_FragCoord.xy / iResolution.xy - .5;
    pos.x*=iResolution.x/iResolution.y;
    vec2 uv=pos + position;
    vec2 luv=uv;
    uv*=Zoom;
    float pix=Softness/iResolution.x*Zoom;
    for (int aa=0; aa<36; aa++) {
        vec2 aauv=floor(vec2(float(aa)/6.,mod(float(aa),6.)));
        formula(uv+aauv*pix,Detail);
    }
    Shape/=36.; color/=36.;
    vec3 colo=mix(vec3(.15),color,Shape)*min(.2,abs(.5-(time+.5,1.))*10.);    
    colo*=vec3(1.2,1.1,1.0);
    gl_FragColor = vec4(colo,1.0);
}