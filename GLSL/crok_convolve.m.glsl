uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param1;
float pCv = float(param1.x) * 0.01;
float quality = float(param1.y) * 0.01;

// created by Pitzik4 in 16/5/2013

vec2 iResolution = vec2(adsk_result_w, adsk_result_h);


#define PI 3.141592
#define PI2 6.283184

vec4 colorat(vec2 uv) 
{
    return texture2DRect(image1, res * vec2(uv.x, uv.y));
}
vec4 convolve(vec2 uv) 
{
    vec4 col = vec4(0.0);
    for(float r0 = 0.0; r0 < 1.0; r0 += 0.1 / quality )
     {
        float r = r0 * pCv*.01;
        for(float a0 = 0.0; a0 < 1.0; a0 += 0.1 / quality) 
        {
            float a = a0 * PI2;
            col += colorat(uv + vec2(cos(a), sin(a)) * r);
        }
    }
    col *= 0.1 / quality * 0.1 / quality;
    return col;
}
void main(void)
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    gl_FragColor = convolve(uv);
}