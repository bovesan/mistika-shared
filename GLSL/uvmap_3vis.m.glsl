//*****************************************************************************/
// 
// Filename: uvmap_3vis.glsl
// Author: Eric Pouliot
//
// Copyright (c) 2013 3vis, Inc.
//*****************************************************************************/

uniform sampler2DRect image2;
uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param1;
bool PickObj = bool(param1.y);
int selectObj = int(param1.x);

void main(void)
{

vec4 ResultPixel;

vec2 uv = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h );

vec4 MapPixel = texture2DRect(image2, res * uv);

vec2 SrcCoord = MapPixel.rg;

    if(PickObj && MapPixel.b != float(selectObj))
    {
        ResultPixel = vec4(0.0);
    }

    else
        ResultPixel = texture2DRect(image1, res * SrcCoord);


ResultPixel.a = MapPixel.a;

gl_FragColor= ResultPixel;

}