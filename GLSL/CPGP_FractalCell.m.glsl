uniform sampler2DRect image1;
uniform vec3 param1;
float adsk_time = float(param1.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float paramSpeed = float(param1.y) * 0.01;
bool UseLigthModulation = bool(param1.x);



//CBS
//Parallax scrolling fractal galaxy.
//Inspired by JoshP's Simplicity shader: https://www.shadertoy.com/view/lslGWr

// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
// Ported from ShaderToys.com by redexe@gmail.com

float field(in vec3 p,float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(adsk_time*paramSpeed/100.0) * 4373.11));
    float accum = s/4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 26; ++i) {
        float mag = dot(p, p);
        p = abs(p) / mag + vec3(-.5, -.4, -1.5);
        float w = exp(-float(i) / 7.);
        accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
        tw += w;
        prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
}

// Less iterations for second layer
float field2(in vec3 p, float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(adsk_time*paramSpeed/100.0) * 4373.11));
    float accum = s/4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 18; ++i) {
        float mag = dot(p, p);
        p = abs(p) / mag + vec3(-.5, -.4, -1.5);
        float w = exp(-float(i) / 7.);
        accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
        tw += w;
        prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
}

vec3 nrand3( vec2 co )
{
    vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
    vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
    vec3 c = mix(a, b, 0.5);
    return c;
}

//-----------------------------------------------------------------------------
// Main functions
//-----------------------------------------------------------------------------

void main()
{
    vec2 iResolution = vec2(adsk_result_w,adsk_result_h);
    vec2 uv = 2. * gl_FragCoord.xy / iResolution.xy - 1.;
    vec2 uvs = uv * iResolution.xy / max(iResolution.x, iResolution.y);
    vec3 p = vec3(uvs / 4., 0) + vec3(1., -1.3, 0.);
    p += .2 * vec3(sin(adsk_time*paramSpeed/100.0 / 16.), sin(adsk_time*paramSpeed/100.0 / 12.),  sin(adsk_time*paramSpeed/100.0 / 128.));
    
    float freqs[4];
    //There is no sound here, so a texture sample has been put in its place, it can be removed....
    if(UseLigthModulation)
    {
    freqs[0] = texture2DRect( image1, res * vec2( 0.01, 0.25 ) ).x;
    freqs[1] = texture2DRect( image1, res * vec2( 0.07, 0.25 ) ).x;
    freqs[2] = texture2DRect( image1, res * vec2( 0.15, 0.25 ) ).x;
    freqs[3] = texture2DRect( image1, res * vec2( 0.30, 0.25 ) ).x;
    }
    else
    {
    freqs[0] = 0.5;
    freqs[1] = 0.5;
    freqs[2] = 0.5;
    freqs[3] = 0.5;
    }
    
    float t = field(p,freqs[2]);
    float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
    
    //Second Layer
    vec3 p2 = vec3(uvs / (4.+sin(adsk_time*paramSpeed/100.0*0.11)*0.2+0.2+sin(adsk_time*paramSpeed/100.0*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);
    p2 += 0.25 * vec3(sin(adsk_time*paramSpeed/100.0 / 16.), sin(adsk_time*paramSpeed/100.0 / 12.),  sin(adsk_time*paramSpeed/100.0 / 128.));
    float t2 = field2(p2,freqs[3]);
    vec4 c2 = mix(.4, 1., v) * vec4(1.3 * t2 * t2 * t2 ,1.8  * t2 * t2 , t2* freqs[0], t2);
    
    
    //Let's add some stars
    //Thanks to http://glsl.heroku.com/e#6904.0
    vec2 seed = p.xy * 2.0;
    seed = floor(seed * iResolution.x);
    vec3 rnd = nrand3( seed );
    vec4 starcolor = vec4(pow(rnd.y,40.0));
    
    //Second Layer
    vec2 seed2 = p2.xy * 2.0;
    seed2 = floor(seed2 * iResolution.x);
    vec3 rnd2 = nrand3( seed2 );
    starcolor += vec4(pow(rnd2.y,40.0));
    
    gl_FragColor = mix(freqs[3]-.3, 1., v) * vec4(1.5*freqs[2] * t * t* t , 1.2*freqs[1] * t * t, freqs[3]*t, 1.0)+c2+starcolor;
}