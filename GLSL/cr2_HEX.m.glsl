/*
    Hexagon Pattern Creator
    Written by: Craig Russo
    Email: craig@310studios.com
    Website: www.crusso.com
    
    Date Created: 5/10/2014
    version: .02

    Based on : https://gist.github.com/rgngl/5565102

    Copyright (C) 2014 Craig P. Russo

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

    
*/



vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float scale = float(param1.z) * 1.0;
uniform vec3 param2;
float lineThick = float(param2.x) * 0.01;
float posx = float(param1.x) * 0.01;
float posy = float(param1.y) * 0.01;
uniform vec3 param5;
float rotate = float(param5.z) * 1.0;
float shapew = float(param2.y) * 0.01;
float shapeh = float(param2.z) * 0.01;
uniform sampler2DRect undefined;
uniform vec3 param6;
vec3 linecolor = vec3(param6.x, param6.y, param6.z) * 0.01;
uniform vec3 param7;
vec3 backcolor = vec3(param7.x, param7.y, param7.z) * 0.01;
bool hardedge = bool(param5.x);
bool invertmatte = bool(param5.y);

// 1 on edges, 0 in middle
float hex(vec2 p) {
  //p.x *= 0.57735*2.0;
  p.x *= shapew;
  p.x -= posx;
    p.y += (mod(floor(p.x), 2.0)*0.5);
    p.y -= posy;

    //p = abs((mod(p, 1.0) - 0.5));
    p = abs((mod(p, 1.0) - 0.5));
    //return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
    return abs(max(p.x*shapeh + p.y, p.y*2.0) - 1.0);
}


// Rotation Matix This doesn't work yet  I got this from here: http://www.neilmendoza.com/glsl-rotation-about-an-arbitrary-axis/
//-----------------------------------------------------------



mat4 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

// -------------------------------------------------------------------





void main(void){

//normalize canvas coordinates
vec2 st;
st.x = gl_FragCoord.x / adsk_result_w;
st.y = gl_FragCoord.y / adsk_result_h;

//gl_TexCoord[ 0 ] = gl_MultiTexCoord0*rotationMatrix(st/2,rotate);

vec2 pos = gl_FragCoord.xy;

vec2 p = pos/scale; 
vec4 color = vec4(smoothstep(0.0, lineThick, hex(p)));
        
    

    gl_FragColor = color;

    
    //This inverts the colors
    gl_FragColor.rgb = vec3(1.0, 1.0, 1.0) - gl_FragColor.rgb;

    //Invert Alpha
    if(invertmatte == false){
    gl_FragColor.a = 1.0 - gl_FragColor.a;
    }

    
    if(hardedge){

        //This Colors Lines
        gl_FragColor.rgb = gl_FragColor.rgb * linecolor;

        //This Colors Fills
        if(gl_FragColor.rgb == vec3(0)){
            gl_FragColor.rgb = vec3(backcolor);
        }else{
            gl_FragColor.rgb = vec3(linecolor);
        }
    
    }else{

        //This Colors Lines
        gl_FragColor.rgb = gl_FragColor.rgb * linecolor;
        //This Colors fills
        gl_FragColor.rgb = gl_FragColor.rgb + backcolor;


    }

    
    
}



 

