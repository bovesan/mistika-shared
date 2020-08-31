uniform vec3 param3;
float adsk_time = float(param3.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float Speed = float(param1.x) * 0.01;
uniform vec3 param4;
vec3 vBaseColour = vec3(param3.z, param4.x, param4.y) * 0.01;
float gain = float(param1.y) * 0.01;
uniform vec3 param2;
int detail = int(param2.x);

float iGlobalTime = adsk_time*.02;

#ifdef GL_ES
precision mediump float; 
#endif

float time = float(param1.z) * 0.1;

// Fractal Soup - @P_Malin

vec2 CircleInversion(vec2 vPos, vec2 vOrigin, float fRadius)
{    
    vec2 vOP = vPos - vOrigin;
    return vOrigin - vOP * fRadius * fRadius / dot(vOP, vOP);
}

float Parabola( float x, float n )
{
    return pow( gain*x*(1.0-x), n );
}

void main(void)
{
    vec2 vPos = gl_FragCoord.xy / resolution.xy;
    vPos = vPos - 0.5;
    
    vPos.x *= resolution.x / resolution.y;
    
    vec2 vScale = vec2(1.2);
    vec2 vOffset = vec2( sin((iGlobalTime+time)*.123*Speed), sin((iGlobalTime+time)*.0567*Speed));

    float l = 0.0;
    float minl = 10000.0;
    
    for(int i=0; i<detail; i++)
    {
        vPos.x = abs(vPos.x);
        vPos = vPos * vScale + vOffset;    
        
        vPos = CircleInversion(vPos, vec2(0.5, 0.5), 1.0);
        
        l = length(vPos);
        minl = min(l, minl);
    }
    
    float t = 4.1 + time;

    float fBrightness = 15.0;
    
    vec3 vColour = vBaseColour * l * l * fBrightness;
    
    minl = Parabola(minl, 5.0);    
    
    vColour *= minl + 0.1;
    
    vColour = 1.0 - exp(-vColour);
    gl_FragColor = vec4(vColour,1.0);
}
