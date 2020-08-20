uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param2;
float radius = float(param2.x) * 0.01;
float softness = float(param2.y) * 0.01;
float blend = float(param2.z) * 0.01;
uniform vec3 param4;
float aspect = float(param4.x) * 0.01;
uniform vec3 param5;
vec3 v_color = vec3(param4.y, param4.z, param5.x) * 0.01;
uniform vec3 param3;
bool organic = bool(param3.x);
vec2 center = vec2(param5.y, param5.z) * 0.01;

void main( void ) 
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec2 center = (2.0 * ((gl_FragCoord.xy / resolution.xy) - 0.25) - center);
    center.x = center.x  / aspect;
    vec3 original = texture2DRect(image1, res * uv).rgb;
    vec3 tint_col = v_color * original;
    
    float length = length(center);
    float vig = smoothstep(radius, radius-softness, length);
    
    vec3 matte = vec3(1.0-vig);

    // simple blend mode 
    vec3 fin_col = mix(original, tint_col, blend);
    fin_col = matte * fin_col + (1.0 - matte) * original;
    
    if ( organic )
    {
        fin_col = tint_col * original;
        fin_col = matte * fin_col + (1.0 - matte) * original;
        fin_col = mix(original, fin_col, blend);
    }

    gl_FragColor = vec4(fin_col, vig);
}
