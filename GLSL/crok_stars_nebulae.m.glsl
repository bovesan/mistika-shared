uniform vec3 param4;
float adsk_time = float(param4.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
vec2 iResolution = vec2(adsk_result_w, adsk_result_h);


// Star Nest by Pablo Román Andrioli
// This content is under the MIT License.


uniform vec3 param5;
vec2 pPos = vec2(param5.x, param5.y) * 0.01;
uniform vec3 param1;
int pIterations = int(param1.x);
float Offset = float(param1.z) * 0.001;
int volsteps = int(param1.y);
uniform vec3 param2;
float stepsize = float(param2.x) * 0.001;
float zoom = float(param2.y) * 0.01;
uniform vec3 param3;
float tile = float(param3.y) * 0.005;
float brightness = float(param3.z) * 0.0001;
float distfading = float(param4.y) * 0.01;
float saturation = float(param4.x) * 0.01;

#define  darkmatter    0.300

void main(void)
{
    //get coords and direction
    vec2 uv=gl_FragCoord.xy/iResolution.xy-.5;
    uv.y*=iResolution.y/iResolution.x;
    vec3 dir=vec3(uv*zoom,1.);

    //mouse rotation
    float a1=pPos.x/iResolution.x*2.;
    float a2=pPos.y/iResolution.y*2.;
    mat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));
    mat2 rot2=mat2(cos(a2),sin(a2),-sin(a2),cos(a2));
    dir.xz*=rot1;
    dir.xy*=rot2;
    vec3 from=vec3(1.,.5,0.5);
    from+=vec3(2.,1.,-2.);
    from.xz*=rot1;
    from.xy*=rot2;
    
    //volumetric rendering
    float s=0.1,fade=1.;
    vec3 v=vec3(0.);
    for (int r=0; r<volsteps; r++) {
        vec3 p=from+s*dir*.5;
        p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
        float pa,a=pa=0.;
        for (int i=0; i<pIterations; i++) { 
            p=abs(p)/dot(p,p)-Offset; // the magic formula
            a+=abs(length(p)-pa); // absolute sum of average change
            pa=length(p);
        }
        float dm=max(0.,darkmatter-a*a*.001); //dark matter
        a*=a*a; // add contrast
        if (r>3) fade*=1.-dm; // dark matter, don't render near
        //v+=vec3(dm,dm*.5,0.);
        v+=fade;
        v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
        fade*=distfading; // distance fading
        s+=stepsize;
    }
    v=mix(vec3(length(v)),v,saturation); //color adjust
    gl_FragColor = vec4(v*.01,1.);    
    
}