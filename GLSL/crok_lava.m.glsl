uniform vec3 param13;
float adsk_time = float(param13.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param2;
float Speed = float(param2.y) * 0.01;
float Offset = float(param2.z) * 0.01;
uniform vec3 param3;
float Zoom = float(param3.x) * 0.01;
uniform vec3 param1;
float Detail = float(param1.x) * 0.01;
uniform vec3 param4;
float Noise = float(param4.x) * 0.01;
uniform vec3 param6;
float brightness = float(param6.x) * 0.01;
float contrast = float(param6.y) * 0.01;
float saturation = float(param6.z) * 0.01;
uniform vec3 param8;
float tint = float(param8.x) * 0.01;
bool clamp_g = bool(param13.y);
uniform vec3 param14;
vec3 co0 = vec3(param14.x, param14.y, param14.z) * 0.01;
uniform vec3 param15;
vec3 co1 = vec3(param15.x, param15.y, param15.z) * 0.01;
uniform vec3 param16;
vec3 co2 = vec3(param16.x, param16.y, param16.z) * 0.01;
uniform vec3 param17;
vec3 co3 = vec3(param17.x, param17.y, param17.z) * 0.01;
uniform vec3 param18;
vec3 co4 = vec3(param18.x, param18.y, param18.z) * 0.01;
uniform vec3 param19;
vec3 tint_col = vec3(param19.x, param19.y, param19.z) * 0.01;
uniform vec3 param20;
vec2 Aspect = vec2(param20.x, param20.y) * 0.01;

float time = adsk_time *.02 * Speed + Offset;

const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);

int VolumeSteps = int(param1.y);
float StepSize = float(param1.z) * 0.01;
float Density = float(param2.x) * 0.01;
float NoiseFreq = float(param4.y) * 0.01;
float NoiseAmp = float(param4.z) * 0.01;
uniform vec3 param21;
vec3 NoiseAnim = vec3(param20.z, param21.x, param21.y) * 0.01;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    return f;
}

float distanceFunc(vec3 p)
{    
    float d = length(p);    // distance to sphere
    d += fbm(p*NoiseFreq + NoiseAnim*time) * NoiseAmp;
    return d;
}

vec4 gradient(float x)
{
    x=sin(x-time);

    vec4 c0 = vec4(co0, 0.1);    // yellow
    vec4 c1 = vec4(co1, 0.9);    // red
    vec4 c2 = vec4(co2, 0);     // black
    vec4 c3 = vec4(co3, 0.2);     // blue
    vec4 c4 = vec4(co4, 0);     // black
    
    x = clamp(x, 0.0, 0.999);
    float t = fract(x*4.0);
    vec4 c;
    if (x < 0.25) {
        c =  mix(c0, c1, t);
    } else if (x < 0.5) {
        c = mix(c1, c2, t);
    } else if (x < 0.75) {
        c = mix(c2, c3, t);
    } else {
        c = mix(c3, c4, t);        
    }
    return c;
}

vec4 shade(float d)
{    
    vec4 c = gradient(d);
    return c;
}


vec4 volumeFunc(vec3 p)
{
    float d = distanceFunc(p);
    return shade(d);
}

vec4 rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos)
{
    vec4 sum = vec4(0, 0, 0, 0);
    pos = rayOrigin;
    for(int i=0; i<VolumeSteps; i++) {
        vec4 col = volumeFunc(pos);
        col.a *= Density;
        col.rgb *= col.a;
        sum = sum + col*(1.0 - sum.a);    
        pos += rayStep;
    }
    return sum;
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
    
    float rotx = 0.0;
    float roty = 0.0;

    vec3 ro = Detail * normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);
    vec3 uu = Aspect.x * normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = Aspect.y * normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + ww * Zoom );

    ro += rd * Noise;
    
    vec3 hitPos;
    vec4 col = rayMarch(ro, rd*StepSize, hitPos);
    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(col.rgb, LumCoeff));

    vec3 sat_color = mix(intensity, col.rgb, saturation);
    vec3 con_color = mix(avg_lum, sat_color, contrast);
    vec3 brt_color = con_color - 1.0 + brightness;
    vec3 fin_color = mix(brt_color, brt_color * tint_col, tint);

    if ( clamp_g )
        fin_color = clamp(fin_color, 0.0, 1.0);
    gl_FragColor = vec4(fin_color, 1.0);
    }