// Premultiply (C)2015 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2DRect image1;
uniform sampler2DRect image3;
uniform vec3 param2;
 float = (param2.z);
vec2 res = gl_TexCoord[0].zw;
 adsk_result_w = res.x;
 adsk_result_h = res.y;
uniform vec3 param3;
 int = (param3.x);
uniform vec3 param1;
 op_mode = (param1.x);
 vec3 = (param3.y);
 bg_color = (param3.z);
uniform vec3 param4;
 bool = (param4.x);
 do_clamp = (param2.y);
//

void main(void) {

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    vec4 px  = vec4( texture2DRect( image1, uv ).rgb, res * texture2DRect( image3, uv ).g );
    vec4 npx;

    if( op_mode == 1 )    // Premultiply
      npx = vec4( (px.rgb * px.a) + (bg_color * (1.0 - px.a)), px.a );

    else                  // Unpremultiply
      npx = vec4( ((px.rgb - (bg_color * (1.0 - px.a))) / px.a), px.a );

    gl_FragColor = do_clamp ? clamp( npx, 0.0, 1.0 ) : npx;
}
