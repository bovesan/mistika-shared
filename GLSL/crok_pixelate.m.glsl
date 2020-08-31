uniform sampler2DRect image1;
uniform sampler2DRect image2;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param2;
float adsk_result_frameratio = float(param2.x) * 1.0;
uniform vec3 param1;
float Detail = float(param1.x) * 0.1;
float trans = float(param1.y) * 0.01;
bool Aspect = bool(param1.z);



void main(void)
{
    vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    
    vec2 aspect = vec2(1.0);
    
    if ( Aspect )
        aspect = vec2(1.0, resolution.x/resolution.y);
            
    vec2 size = vec2(aspect.x/Detail, aspect.y/Detail);
    vec2 pix_uv = uv - mod(uv - 0.5,size);

    vec3 color1 = vec3( texture2DRect(image1, pix_uv ).rgb);    
    vec3 color2 = vec3( texture2DRect(image1, uv).rgb);
    vec3 matte =  vec3( texture2DRect(image2, pix_uv).rgb);
    gl_FragColor = vec4 ((matte * color1*trans + (1.0 - matte*trans) *color2) , matte);
}
