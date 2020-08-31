#version 120

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float gamma = float(param1.z) * 0.01;
float gain = float(param1.y) * 0.01;
float offset = float(param1.x) * 0.01;


void main()
{
    vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    vec3 col = clamp(texture2DRect(image1, uv).rgb, res * 0.0, res * 1.0);
    
    // matte offset 
    col = pow(col, vec3(1.0 / (offset + 1.0)));
    
    // invert original matte
    vec3 col_inv = 1.0 - col;
    
    // multiply original matte with inverted matte to get the outline
    col *= col_inv;
    
    // apply some gamma correction to the matte
    col = pow(col, vec3(1.0 / gamma));
    
    // apply some gain to brighten up the matte
    col *= col * gain *10.;
    
    
    gl_FragColor = vec4(col, 1.0);
}