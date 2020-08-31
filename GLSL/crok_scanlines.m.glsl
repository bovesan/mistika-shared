#version 120
/*
    caligari's scanlines

    Copyright (C) 2011 caligari

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the Free
    Software Foundation; either version 2 of the License, or (at your option)
    any later version.

    (caligari gave their consent to have this shader distributed under the GPL
    in this message:

        http://board.byuu.org/viewtopic.php?p=36219#p36219

        "As I said to Hyllian by PM, I'm fine with the GPL (not really a bi
        deal...)"
   )
Phosphor21x:
http://filthypants.blogspot.de/2011/05/more-emulator-pixel-shaders-crt-updated.html

*/

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
vec2 rubyOutputSize = vec2(adsk_result_w, adsk_result_h);

uniform vec3 param2;
float adsk_Front_w = float(param2.x) * 1.0;
float adsk_Front_h = float(param2.y) * 1.0;
vec2 rubyInputSize = vec2(adsk_Front_w, adsk_Front_h);

float distortion = float(param2.z) * 1.0;
    
vec2 FrontSize = rubyInputSize;

uniform vec3 param1;
bool RGB_BAR = bool(param1.x);
bool RGB_TRIAD = bool(param1.z);
bool MG_BAR = bool(param1.y);

// 0.5 = the spot stays inside the original pixel
// 1.0 = the spot bleeds up to the center of next pixel
#define SPOT_WIDTH  0.9
#define SPOT_HEIGHT 0.65

// Used to counteract the desaturation effect of weighting.
#define COLOR_BOOST 2.45

#define GAMMA_IN(color) color
#define GAMMA_OUT(color) color

#define TEX2D(coords)   GAMMA_IN( texture2DRect(image1, coords) )

// Macro for weights computing
#define WEIGHT(w) \
if(w>1.0) w=1.0; \
w = 1.0 - w * w; \
w = w * w;

vec2 onex = vec2( 1.0/FrontSize.x, 0.0 );
vec2 oney = vec2( 0.0, 1.0/FrontSize.y );

void main(void)
{
    vec2 coords = ( gl_TexCoord[0].xy * FrontSize );
    vec2 pixel_center = floor( coords ) + vec2(0.5);
    vec2 texture_coords = pixel_center / FrontSize;
    vec4 color = TEX2D( texture_coords );

    float dx = coords.x - pixel_center.x;

    float h_weight_00 = dx / SPOT_WIDTH;
    WEIGHT(h_weight_00);
    color *= vec4( h_weight_00  );

    // get closest horizontal neighbour to blend
    vec2 coords01;
    if (dx>0.0) {
        coords01 = onex;
        dx = 1.0 - dx;
    } else {
        coords01 = -onex;
        dx = 1.0 + dx;
    }
    vec4 colorNB = TEX2D( texture_coords + coords01 );

    float h_weight_01 = dx / SPOT_WIDTH;
    WEIGHT( h_weight_01 );
    color = color + colorNB * vec4( h_weight_01 );
//////////////////////////////////////////////////////
// Vertical Blending
    float dy = coords.y - pixel_center.y;
    float v_weight_00 = dy / SPOT_HEIGHT;
    WEIGHT(v_weight_00);
    color *= vec4( v_weight_00 );

    // get closest vertical neighbour to blend
    vec2 coords10;
    if (dy>0.0) {
        coords10 = oney;
        dy = 1.0 - dy;
    } else {
        coords10 = -oney;
        dy = 1.0 + dy;
    }
    colorNB = TEX2D( texture_coords + coords10 );
    float v_weight_10 = dy / SPOT_HEIGHT;
    WEIGHT( v_weight_10 );
    color = color + colorNB * vec4( v_weight_10 * h_weight_00 );
    colorNB = TEX2D(  texture_coords + coords01 + coords10 );
    color = color + colorNB * vec4( v_weight_10 * h_weight_01 );
    color *= vec4( COLOR_BOOST );
    
    if ( RGB_BAR )
        {

            vec2 output_coords = floor(gl_TexCoord[0].xy * rubyOutputSize);
        
            float modulo = mod(output_coords.x,3.0);
            
            if ( modulo == 0.0 )
                    color = color * vec4(1.4,0.5,0.5,0.0);
                else if ( modulo == 1.0 )
                    color = color * vec4(0.5,1.4,0.5,0.0);
                else
                    color = color * vec4(0.5,0.5,1.4,0.0);
            }

        if ( RGB_TRIAD )
        {
        vec2 output_coords = floor(gl_TexCoord[0].xy * rubyOutputSize / rubyInputSize * FrontSize);
        float modulo = mod(output_coords.x,2.0);
        if ( modulo < 1.0 )
        modulo = mod(output_coords.y,6.0);
        else
        modulo = mod(output_coords.y + 3.0, 6.0);
        if ( modulo < 2.0 )
                    color = color * vec4(1.0,0.0,0.0,0.0);
                else if ( modulo < 4.0 )
                    color = color * vec4(0.0,1.0,0.0,0.0);
                else
                    color = color * vec4(0.0,0.0,1.0,0.0);
            }

        if ( MG_BAR )
        {
                vec2 output_coords = floor(gl_TexCoord[0].xy * rubyOutputSize);

                float modulo = mod(output_coords.x,2.0);
                if ( modulo == 0.0 )
                    color = color * vec4(1.0,0.1,1.0,0.0);
                else
                    color = color * vec4(0.1,1.0,0.1,0.0);
            }


                gl_FragColor = GAMMA_OUT(color), 0.0, 1.0;
        }

