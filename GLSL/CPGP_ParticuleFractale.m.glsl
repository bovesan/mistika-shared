uniform vec3 param1;
float adsk_time = float(param1.y) * 1.0;
bool paramWarp = bool(param1.z);
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

float paramSpeed = float(param1.x) * 0.1;

void main(void)
{
    float s=0.,v=0.;
    
        for (int r=0; r<140; r++) {
            vec3 p=vec3(.3,.2,floor(adsk_time*paramSpeed)*.005)
            +s*vec3(gl_FragCoord.xy*.00003-vec2(.009,.005),1.);
            p.z=fract(p.z);
            for (int i=0; i<18; i++) p=abs(p)/dot(p,p)*2.-1.;
            v+=length(p*p)*(.75-s)*.0015;
            s+=.005;
        }
        gl_FragColor = v*vec4(.9,.625,v,1.);
        
}