// Croptastic (C)2015 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2DRect image1;
uniform sampler2DRect image3;
uniform vec3 param13;
 float = (param13.y);
uniform vec3 param1;
 crop_l = (param1.x);
 crop_r = (param1.y);
 crop_t = (param1.z);
uniform vec3 param2;
 crop_b = (param2.x);
 vec2 = (param13.z);
uniform vec3 param14;
 crop_tl = (param14.x);
 crop_br = (param14.y);
 offset_xy = (param14.z);
 float = (param13.y);
vec2 res = gl_TexCoord[0].zw;
 adsk_result_w = res.x;
 adsk_result_h = res.y;
uniform vec3 param15;
 bool = (param15.x);
uniform vec3 param3;
 border = (param3.x);
uniform vec3 param5;
 border_overadv = (param5.x);
 vec3 = (param15.y);
 border_color = (param15.z);
 float = (param13.y);
 border_size = (param3.y);
uniform vec3 param4;
 border_trans = (param4.z);
 bool = (param15.x);
 aborder_l = (param5.y);
 aborder_r = (param5.z);
uniform vec3 param6;
 aborder_t = (param6.x);
 aborder_b = (param6.y);
 float = (param13.y);
 aborder_lsize = (param6.z);
uniform vec3 param7;
 aborder_rsize = (param7.x);
 aborder_tsize = (param7.y);
 aborder_bsize = (param7.z);
 float = (param13.y);
uniform vec3 param12;
 aborder_ltrans = (param12.x);
 aborder_rtrans = (param12.y);
 aborder_ttrans = (param12.z);
 aborder_btrans = (param13.x);
 vec3 = (param15.y);
uniform vec3 param16;
 aborder_lcolor = (param16.x);
 aborder_rcolor = (param16.y);
 aborder_tcolor = (param16.z);
uniform vec3 param17;
 aborder_bcolor = (param17.x);

// Global variables

vec4 px;


//

void do_border(void) {

    if( (gl_FragCoord.x >= crop_l && gl_FragCoord.x <= crop_l + border_size) || (gl_FragCoord.x <= (adsk_result_w - crop_r) && gl_FragCoord.x >= (adsk_result_w - crop_r) - border_size) )
        if( gl_FragCoord.y >= crop_b && gl_FragCoord.y <= adsk_result_h - crop_t )
            px = vec4( mix( px, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );

    if( (gl_FragCoord.y >= crop_b && gl_FragCoord.y <= crop_b + border_size) || (gl_FragCoord.y <= (adsk_result_h - crop_t) && gl_FragCoord.y >= (adsk_result_h - crop_t) - border_size) )
        if( gl_FragCoord.x >= crop_l + border_size && gl_FragCoord.x <= (adsk_result_w - crop_r) - border_size )
            px = vec4( mix( px, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );
}

//

void main(void) {

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv  = (gl_FragCoord.xy - offset_xy) / vec2( adsk_result_w, adsk_result_h );
         px  = vec4( texture2DRect( image1, uv ).rgb, res * texture2DRect( image3, uv ).g );
    vec4 blk = vec4( 0.0, 0.0, 0.0, 0.0 );

    // Do the cropping

    if( gl_FragCoord.x < crop_l )
        px = blk;
    if( gl_FragCoord.x > adsk_result_w - crop_r )
        px = blk;

    if( gl_FragCoord.y > adsk_result_h - crop_t )
        px = blk;
    if( gl_FragCoord.y < crop_b )
        px = blk;


    // Draw border if it's supposed to be underneath

    if( border && !border_overadv )
        do_border();


    // Draw Advanced Borders

    if( aborder_l ) {

        if( (gl_FragCoord.x >= crop_l && gl_FragCoord.x <= crop_l + aborder_lsize) && (gl_FragCoord.y >= crop_b && gl_FragCoord.y <= adsk_result_h - crop_t) )
            px = vec4( mix( px, vec4( aborder_lcolor, 1.0 ), (aborder_ltrans / 100.0) ) );
    }

    if( aborder_r ) {

        if( (gl_FragCoord.x <= (adsk_result_w - crop_r) && gl_FragCoord.x >= (adsk_result_w - crop_r) - aborder_rsize) && (gl_FragCoord.y >= crop_b && gl_FragCoord.y <= adsk_result_h - crop_t) )
            px = vec4( mix( px, vec4( aborder_rcolor, 1.0 ), (aborder_rtrans / 100.0) ) );
    }

    if( aborder_t ) {

        if( (gl_FragCoord.y <= (adsk_result_h - crop_t) && gl_FragCoord.y >= (adsk_result_h - crop_t) - aborder_tsize) && (gl_FragCoord.x >= crop_l && gl_FragCoord.x <= adsk_result_w - crop_r) )
            px = vec4( mix( px, vec4( aborder_tcolor, 1.0 ), (aborder_ttrans / 100.0) ) );
    }

    if( aborder_b ) {

        if( (gl_FragCoord.y >= crop_b && gl_FragCoord.y <= crop_b + aborder_bsize) && (gl_FragCoord.x >= crop_l && gl_FragCoord.x <= adsk_result_w - crop_r) )
            px = vec4( mix( px, vec4( aborder_bcolor, 1.0 ), (aborder_btrans / 100.0) ) );
    }


    // Draw border if it's supposed to be on top of

    if( border && border_overadv )
        do_border();

    gl_FragColor = px;
}
