uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform vec3 param3;
vec3 colour = vec3(param3.x, param3.y, param3.z) * 0.01;
uniform vec3 param1;
float p1 = float(param1.x) * 0.01;
uniform vec3 param2;
float p2 = float(param2.y) * 0.01;
float p3 = float(param2.z) * 0.01;


vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
vec2 iResolution = vec2(adsk_result_w, adsk_result_h);

// a very rough chroma key 
// created by Zavie in 2013-May-28
// https://www.shadertoy.com/view/4dX3WN


vec3 rgb2hsv(vec3 rgb)
{
    float Cmax = max(rgb.r, max(rgb.g, rgb.b));
    float Cmin = min(rgb.r, min(rgb.g, rgb.b));
    float delta = Cmax - Cmin;

    vec3 hsv = vec3(0., 0., Cmax);
    
    if (Cmax > Cmin)
    {
        hsv.y = delta / Cmax;

        if (rgb.r == Cmax)
            hsv.x = (rgb.g - rgb.b) / delta;
        else
        {
            if (rgb.g == Cmax)
                hsv.x = 2. + (rgb.b - rgb.r) / delta;
            else
                hsv.x = 4. + (rgb.r - rgb.g) / delta;
        }
        hsv.x = fract(hsv.x / 6.);
    }
    return hsv;
}

float chromaKey(vec3 color)
{
    vec3 backgroundColor = vec3(colour.r, colour.g, colour.b);
    vec3 weights = vec3(p1, p2, p3);

    vec3 hsv = rgb2hsv(color);
    vec3 target = rgb2hsv(backgroundColor);
    float dist = length(weights * (target - hsv));
    return 1. - clamp(3. * dist - 1.5, 0., 1.);
}

void main(void)
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    
    vec3 color = texture2DRect(image1, res * uv).rgb;
    vec3 bg = texture2DRect(image2, res * -uv).rgb;
    
    float incrustation = chromaKey(color);
    
    color = mix(color, bg, incrustation);

    gl_FragColor = vec4(color, incrustation);
}
