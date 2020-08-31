vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param2;
float scanlineX = float(param2.y) * 0.01;
float scanlineY = float(param2.z) * 0.01;

uniform vec3 param1;
float offsetX = float(param1.z) * 0.01;
float offsetY = float(param2.x) * 0.01;

float blender = float(param1.x) * 0.01;

//uniform bool rx;
//uniform bool ry;
//uniform bool rxi;
//uniform bool ryi;

//uniform bool gx;
//uniform bool gy;
//uniform bool gxi;
//uniform bool gyi;

//uniform bool bx;
//uniform bool by;
//uniform bool bxi;
//uniform bool byi;
uniform vec3 param3;
float rx = float(param3.x) * 0.01;
float ry = float(param3.y) * 0.01;
float gx = float(param3.z) * 0.01;
uniform vec3 param4;
float gy = float(param4.x) * 0.01;
float bx = float(param4.y) * 0.01;
float by = float(param4.z) * 0.01;


bool useMattebool = bool(param1.y);

// number or inputs

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;

void main(void)
{
    vec2 stDisp;
    stDisp.x = gl_FragCoord.x / adsk_result_w;
    stDisp.y = gl_FragCoord.y / adsk_result_h;
    
    vec4 getDispInput1;
    getDispInput1 = texture2DRect(image2, res * stDisp);

    
    vec2 st2;
    
    st2.x =( gl_FragCoord.x - (((rx)*getDispInput1.x + (bx) * getDispInput1.z + (gx) * getDispInput1.y)*scanlineX)+ offsetX) / adsk_result_w;
//    st2.x =( gl_FragCoord.x - (((rx -rxi)*getDispInput1.x + (bx - bxi) * getDispInput1.z + (gx - gxi) * getDispInput1.y)*scanlineX)+ offsetX) / adsk_result_w;
    st2.y =( gl_FragCoord.y - (((ry)*getDispInput1.x + (by) * getDispInput1.z + (gy) * getDispInput1.y)*scanlineY)+ offsetY) / adsk_result_h;

//    st2.y =( gl_FragCoord.y - (((ry -ryi)*getDispInput1.x + (by - byi) * getDispInput1.z + (gy - gyi) * getDispInput1.y)*scanlineY)+ offsetY) / adsk_result_h;


    vec4 getColorInputDisp;
    getColorInputDisp = texture2DRect(image1, res * st2);
    
    vec4 getColorInputDispMap;
    getColorInputDispMap = texture2DRect(image3, res * st2);


    vec2 st;

    // get pixel informations RGB for each input
    
    st.x = gl_FragCoord.x  / adsk_result_w;
    st.y = gl_FragCoord.y / adsk_result_h;

    
    vec4 getColorInputClean;
    getColorInputClean = texture2DRect(image1, res * st);
    
    vec4 outColor;

    outColor = (((getColorInputDisp*(1+(useMattebool*(getColorInputDispMap-1)))) + (getColorInputClean*(useMattebool*(1-getColorInputDispMap))))*(1-blender))+ (getColorInputClean*blender);
        
    outColor.a = getColorInputDispMap.r;
    
        //process the output
    gl_FragColor = outColor;
}
