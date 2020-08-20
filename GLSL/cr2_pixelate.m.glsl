vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float lift = float(param1.y) * 0.01;
float gain = float(param1.x) * 0.01;
uniform vec3 param2;
float gamma = float(param2.x) * 1.0;
float radius = float(param1.z) * 10.0;
uniform sampler2DRect image1;




void main(void){

//normalize canvas coordinates
vec2 st;
st.x = gl_FragCoord.x / adsk_result_w;
st.y = gl_FragCoord.y / adsk_result_h;



float dx = 10.*(1./radius);
float dy = 10.*(1./radius);
vec2 coord = vec2(dx*floor(st.x/dx),dy*floor(st.y/dy));


gl_FragColor = (texture2DRect(image1,coord) * gain) + lift;



}



 

