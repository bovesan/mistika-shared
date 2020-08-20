#version 120

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform sampler2DRect image4;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float minInput = float(param1.x) * 0.01;
float maxInput = float(param1.y) * 0.01;


vec3 saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

vec3 multiply( vec3 s, vec3 d )
{
    return s*d;
}

vec3 difference( vec3 s, vec3 d )
{
    return abs(d - s);
}

vec3 linearDodge( vec3 s, vec3 d )
{
    return s + d;
}


void main(void)
{
    vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h);
    vec3 c = vec3(0.0);
    
    // image1 
    vec3 f = texture2DRect(image1, res * uv).rgb;
    // image2
    vec3 b = texture2DRect(image2, res * uv).rgb;
    // image3
    float m = texture2DRect(image3, res * uv).r;
    // despilled image1
    vec3 d = texture2DRect(image4, res * uv).rgb;
    // difference despilled FG and FG
    c = difference(d,f);
    
    
    // do some 2D Histogramm adjustments
    c = min(max(c - vec3(minInput), vec3(0.0)) / (vec3(maxInput) - vec3(minInput)), vec3(1.0));
    // desaturate the image
    c = saturation(c, 0.0);
    
    // multiply Result and BG
    c = multiply(c,b);
    
    // add despilled FG on top of Result
       c =  linearDodge(d,c);
    
    // add beautiful despilled result ontop of the BG with a Matte
    c = vec3(m * c + (1.0 - m) * b);
    
    
    gl_FragColor = vec4(c, m);
}