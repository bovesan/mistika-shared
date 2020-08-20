/*
    LED Simulator

    Ported to Matchbox by: Craig Russo
    Email: craig@310studios.com
    website: www.crusso.com

    Date Created: 6/20/2014
    version: .01



    Original Shader by: Jason Gorski

    For more information about this shader view Jason's tutorial page
    at http://www.lighthouse3d.com/opengl/ledshader/index.php?page2

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




#define KERNEL_SIZE 9

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param2;
int pixelSize = int(param2.x);

uniform sampler2DRect image1;


uniform vec3 param1;
float tolerance = float(param1.z) * 0.01;
float pixelRadius = float(param1.x) * 0.01;

uniform vec3 param3;
int luminanceSteps = int(param3.x);
float luminanceBoost = float(param2.y) * 0.01;

float colorBoost = float(param2.z) * 0.01;
float burntOutPercent = float(param1.y) * 0.01;
uniform sampler2DRect image2;

vec2 texCoords[KERNEL_SIZE]; //stores texture lookup offsets from a base case

//gets the light intensity of the color (same as luminance in applyLuminanceStepping)
float getIntensity(in vec4 color)
{    return (color.r + color.g + color.b)/3.0;    }


vec2 billboardSize = vec2(adsk_result_w, adsk_result_h);

//apply colorBoost
vec4 applyColorBoost(in vec4 color)
{
    vec4 boostedColor = color;
    float max = max(color.r,max(color.g, color.b)); //determine max intensity of channels
    bvec3 maxes = equal(vec3(color),vec3(max)); //contains which channels == max
    
    //any channels == max are boosted by the colorBoost
    if(maxes.r)
        boostedColor += vec4(2.0*colorBoost,-colorBoost,-colorBoost,0.0);
        
    if(maxes.g) 
        boostedColor += vec4(-colorBoost,2.0*colorBoost,-colorBoost,0.0);
    
    if(maxes.b) 
        boostedColor += vec4(-colorBoost,-colorBoost,2.0*colorBoost,0.0);
    
    return boostedColor;
}

//apply luminanceSteps & luminanceBoost
vec4 applyLuminanceStepping(in vec4 color)
{
    float sum = color.r + color.g + color.b;
    float luminance = sum/3.0; //brightness or luminance of color
    vec3 ratios = vec3(color.r/luminance, color.g/luminance, color.b/luminance); //ratio stores each channel's contribution to the luminance
    
    float luminanceStep = 1.0/float(luminanceSteps); //how big each luminance bin is
    float luminanceBin = ceil(luminance/luminanceStep); //figure out which bin the color is in
    float luminanceFactor = luminanceStep * luminanceBin + luminanceBoost; //store the luminance of the color we are making including luminanceBoost
    
    return vec4(ratios * luminanceFactor,1.0); //use ratios * luminanceFactor as our new color so that original color hue is maintained
}
                         
void main(void)
{
    vec4 avgColor; //will hold our averaged color from our sample points
    vec2 texCoordsStep = 1.0/(vec2(float(billboardSize.x),float(billboardSize.y))/float(pixelSize)); //width of "pixel region" in texture coords
    vec2 pixelRegionCoords = fract(gl_TexCoord[0].st/texCoordsStep); //x and y coordinates within "pixel region"
    vec2 pixelBin = floor(gl_TexCoord[0].st/texCoordsStep); //"pixel region" number counting away from base case
    vec2 inPixelStep = texCoordsStep/3.0; //width of "pixel region" divided by 3 (for KERNEL_SIZE = 9, 3x3 square)
    vec2 inPixelHalfStep = inPixelStep/2.0;

    //the center of our "pixel region" is computed earlier now so we don't waste time computing other colors if we are in a burnt out region
    texCoords[4] = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + pixelBin * texCoordsStep;
            
    //if light intensity of our noise texture <= burntOutPercent we are burnt out, otherwise continue computing "pixel region" color
    if(getIntensity(texture2DRect(image2, texCoords[4].st)) <= burntOutPercent)
        gl_FragColor = vec4(0.1,0.1,0.1,1.0) + (0.3*(tolerance + luminanceBoost)); //try to match up color-wise with the edge of our "pixel region"
    else {
        //use offset (pixelBin * texCoordsStep) from base case (the lower left corner of billboard) to compute texCoords
        texCoords[0] = vec2(inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[1] = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[2] = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[3] = vec2(inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + pixelBin * texCoordsStep;
        //texCoords[4] moved to top. See note above.
        texCoords[5] = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[6] = vec2(inPixelHalfStep.x, inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[7] = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelHalfStep.y) + pixelBin * texCoordsStep;
        texCoords[8] = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelHalfStep.y) + pixelBin * texCoordsStep;
            
        //take average of 9 pixel samples
        avgColor = texture2DRect(image1, res * texCoords[0]) +
                    texture2DRect(image1, res * texCoords[1]) +
                    texture2DRect(image1, res * texCoords[2]) +
                    texture2DRect(image1, res * texCoords[3]) +
                    texture2DRect(image1, res * texCoords[4]) +
                    texture2DRect(image1, res * texCoords[5]) +
                    texture2DRect(image1, res * texCoords[6]) +
                    texture2DRect(image1, res * texCoords[7]) +
                    texture2DRect(image1, res * texCoords[8]);
            
        avgColor /= float(KERNEL_SIZE);
        
        //get a new color with the discretized luminance value
        avgColor = applyLuminanceStepping(avgColor);
        //adjust the color
        avgColor = applyColorBoost(avgColor);
        
        //blend between fragments in the circle and out of the circle defining our "pixel region"
        //Equation of a circle: (x - h)^2 + (y - k)^2 = r^2
        vec2 powers = pow(abs(pixelRegionCoords - 0.5),vec2(2.0));
        float radiusSqrd = pow(pixelRadius,2.0);
        float gradient = smoothstep(radiusSqrd-tolerance, radiusSqrd+tolerance, powers.x+powers.y);
        
        gl_FragColor = mix(avgColor, vec4(0.1,0.1,0.1,1.0), gradient);
    }
}
