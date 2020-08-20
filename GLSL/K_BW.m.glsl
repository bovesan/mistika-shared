//
// K_BW v1.0
// Shader written by:   Kyle Obley (kyle.obley@gmail.com)
//

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float red = float(param1.x) * 0.1;
float green = float(param1.y) * 0.1;
float blue = float(param1.z) * 0.1;

void main()
{    
    vec2 st = gl_FragCoord.xy / vec2 (adsk_result_w, adsk_result_h);
    vec3 image1 = texture2DRect(image1, res * st).rgb;
    
    float luminance = image1.r * (red/100.0) + image1.g * (green/100.0) + image1.b * (blue/100.0);
    gl_FragColor = vec4(luminance, luminance, luminance, 1.0);
}