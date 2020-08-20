// Premultiply (C)2015 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2DRect image1;
uniform vec3 param1;
 float = (param1.x);
vec2 res = gl_TexCoord[0].zw;
 adsk_result_w = res.x;
 adsk_result_h = res.y;

void main(void) {

 vec4 px = vec4( texture2DRect( image1, gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h ) ) );
 gl_FragColor = vec4( px[2], px[1], px[0], px[3] );

}