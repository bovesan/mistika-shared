vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;



uniform sampler2DRect image1;
uniform sampler2DRect image2;

uniform vec3 param1;
bool inverseSource = bool(param1.x);

void main(void)
{
    vec2 st1;
    st1.x = gl_FragCoord.x / adsk_result_w;
    st1.y = gl_FragCoord.y / adsk_result_h;
    
    vec4 getDispInput;
    getDispInput = texture2DRect(image1, res * st1);
    

    vec2 stDisp;
    stDisp.x = (getDispInput.x + getDispInput.z) ;
    stDisp.y = (getDispInput.y + getDispInput.z);
    
    vec4 getDispInput1;
    getDispInput1 = texture2DRect(image2, res * stDisp);

    vec4 outColor;
    gl_FragColor = (1-inverseSource)*getDispInput1+((1*inverseSource)+(-1*inverseSource) * getDispInput1);
}
