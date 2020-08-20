#version 120

// based on: http://media.steampowered.com/apps/valve/2015/Alex_Vlachos_Advanced_VR_Rendering_GDC2015.pdf

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float adsk_time = float(param1.y) * 1.0;
float time = adsk_time *.05;

float amount = float(param1.x) * 0.01;
float size = float(param1.z) * 1.0;

void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec4 image = texture2DRect(image1, res * uv);
    
    vec3 dither = vec3(dot(vec2( 171.0, 231.0 ), gl_FragCoord.xy + vec2(time)));
    dither.rgb = fract( dither.rgb / vec3(103.0,71.0,97.0)) - vec3(0.5);
    vec4 col = vec4(( dither.rgb / 255.0 * amount ), 1.0 ) + image;
    
    gl_FragColor = col;
}



