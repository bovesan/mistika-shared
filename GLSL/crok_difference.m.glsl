#version 120

uniform sampler2DRect image1;
uniform sampler2DRect image2;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param3;
float brightness = float(param3.y) * 0.01;
float contrast = float(param3.z) * 0.01;
uniform vec3 param4;
float gain = float(param4.x) * 0.01;
uniform vec3 param1;
float red = float(param1.x) * 0.01;
float green = float(param1.y) * 0.01;
float blue = float(param1.z) * 0.01;
bool clamping = bool(param4.z);
uniform vec3 param5;
bool invert = bool(param5.x);


uniform vec3 param2;
float minInput = float(param2.x) * 0.01;
float maxInput = float(param2.z) * 0.01;
float gamma = float(param4.y) * 0.01;
float minOutput = float(param2.y) * 0.01;
float maxOutput = float(param3.x) * 0.01;

const vec3 lumc = vec3(0.2125, 0.7154, 0.0721);

vec3 difference( vec3 s, vec3 d )
{
    return abs(d - s);
}


void main(void)
{
    vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h);
    vec3 s = texture2DRect(image1, res * uv).xyz;
    vec3 d = texture2DRect(image2, res * uv).xyz;

    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
    vec3 c_channels = vec3(red, green, blue);
    vec3 col = vec3(0.0);


    col = col + difference(s,d);

    col = mix(vec3(0.0), col, c_channels);
    
    col = vec3(max(max(col.r, col.g), col.b));
    col = vec3(dot(col.rgb, lumc));
    col = mix(avg_lum, col, contrast);
    col = col - 1.0 + brightness;
    col = col * gain;
    
    col = min(max(col - vec3(minInput), vec3(0.0)) / (vec3(maxInput) - vec3(minInput)), vec3(1.0));
    col = pow(col, vec3(gamma));
    col = mix(vec3(minOutput), vec3(maxOutput), col);
    

    if ( clamping )
        col = clamp(col, 0.0, 1.0);
    if ( invert )
        col = 1.0 - col;
    
    gl_FragColor = vec4(col, col);
}