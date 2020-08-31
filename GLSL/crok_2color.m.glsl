uniform sampler2DRect image1;
uniform vec3 param1;
float Amount = float(param1.x) * 0.01;
uniform vec3 param5;
float Exposure = float(param5.z) * 0.01;
uniform vec3 param4;
float dark_low = float(param4.y) * 0.01;
float dark_high = float(param4.x) * 0.01;
uniform vec3 param2;
float light_low = float(param2.z) * 0.01;
float light_high = float(param2.y) * 0.01;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float brightness = float(param5.x) * 0.01;
float contrast = float(param5.y) * 0.01;
float saturation = float(param4.z) * 0.01;
uniform vec3 param6;
vec3 light_tint = vec3(param6.x, param6.y, param6.z) * 0.01;
uniform vec3 param7;
vec3 dark_tint = vec3(param7.x, param7.y, param7.z) * 0.01;

const vec3 lumc = vec3(0.2125, 0.7154, 0.0721);


void main(void)
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    
    vec3 original = texture2DRect(image1, res * uv).rgb;
    vec3 col = original;

    float bri = (col.x+col.y+col.z)/3.0;
    float v = smoothstep(dark_low, dark_high, bri);
    col = mix(dark_tint * bri, col, v);
    
    v = smoothstep(light_low, light_high, bri);
    col = mix(col, min(light_tint * col, 1.0), v);
    col = mix(original, col, Amount);
    
    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(col.rgb, lumc));
    vec3 sat_color = mix(intensity, col.rgb, saturation);
    vec3 con_color = mix(avg_lum, sat_color, contrast);
    vec3 fin_col = con_color - 1.0 + brightness;
    
    
    gl_FragColor = vec4(fin_col, 1.0) * Exposure;
}