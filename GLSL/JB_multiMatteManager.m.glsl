//uniform float redChan;
//uniform float greenChan;
//uniform float blueChan;

uniform vec3 param3;
bool redChannel1 = bool(param3.y);
uniform vec3 param2;
bool greenChannel1 = bool(param2.x);
uniform vec3 param1;
bool blueChannel1 = bool(param1.x);
// declare the variables (switches for the channels for each input)

bool redChannel2 = bool(param3.z);
bool greenChannel2 = bool(param2.y);
bool blueChannel2 = bool(param1.y);

uniform vec3 param4;
bool redChannel3 = bool(param4.x);
bool greenChannel3 = bool(param2.z);
bool blueChannel3 = bool(param1.z);

bool invertAlpha = bool(param3.x);

// canvas size

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

// number or inputs

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;

void main(void)
{

    vec2 st;
    // normalize x and y coordinate
        
    st.x = gl_FragCoord.x / adsk_result_w;
    st.y = gl_FragCoord.y / adsk_result_h;

    // get pixel informations RGB for each input
    
    vec4 getColorInput1;
    getColorInput1 = texture2DRect(image1, res * st);
    
    vec4 getColorInput2;
    getColorInput2 = texture2DRect(image2, res * st);

    vec4 getColorInput3;
    getColorInput3 = texture2DRect(image3, res * st);

    
    // multiply rgb by the switch (0/1 active or not)
    
    getColorInput1.r *= redChannel1;
    getColorInput1.g *= greenChannel1;
    getColorInput1.b *= blueChannel1;
    
    getColorInput2.r *= redChannel2;
    getColorInput2.g *= greenChannel2;
    getColorInput2.b *= blueChannel2;

    getColorInput3.r *= redChannel3;
    getColorInput3.g *= greenChannel3;
    getColorInput3.b *= blueChannel3;


    // compute the resulting pixel's rgba
     
    vec4 result;
    
    result.r = getColorInput1.r + getColorInput2.r + getColorInput3.r;
    result.g = getColorInput1.g + getColorInput2.g + getColorInput3.g;
    result.b = getColorInput1.b + getColorInput2.b + getColorInput3.b;

    
    result.a = result.r +result.b +result.g;
    if (invertAlpha == 1) {result.a = 1-result.a;}

    //process the output
    gl_FragColor = result;
    
}
