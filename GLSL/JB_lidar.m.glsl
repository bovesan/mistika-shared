vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect image2;
uniform sampler2DRect image1;

uniform sampler2DRect image3;
uniform vec3 param1;
bool lumaColor = bool(param1.x);
int pixelSize = int(param1.y);

void main(void)
{
    vec2 st0;
    st0.x = gl_FragCoord.x / adsk_result_w;
    st0.y = gl_FragCoord.y / adsk_result_h;
    
    vec4 getColPixel0;
    getColPixel0 = texture2DRect(image3, res * st0);
    
    float luma = (getColPixel0.r + getColPixel0.g + getColPixel0.b)/3;
    
    vec4 getColPixel1;
    
    getColPixel1 = texture2DRect(image2, res * st0);
    float luma1 = (getColPixel1.r + getColPixel1.g + getColPixel1.b)/3;

    vec4 getColPixel2;
    
    getColPixel2 = texture2DRect(image1, res * st0);
    float luma2 = (getColPixel2.r + getColPixel2.g + getColPixel2.b)/3;
    
    float buffer = (luma + luma1 +luma2)/3;
    vec4 FragColor;
    FragColor=vec4(vec3(0),1);
    int pixelRatio;
    pixelRatio = int(luma*20);
    
    if (buffer>= (luma*0.9)){FragColor=vec4(vec3(0),1);}
    if (mod((gl_FragCoord.x+0.5),pixelRatio)>=pixelSize && mod((gl_FragCoord.y+0.5),pixelRatio)>=pixelSize){
    
    if (buffer<(luma*0.9)){
        FragColor = vec4(luma*exp(buffer), luma1*exp(buffer), luma2*exp(buffer),1);
        if (luma >= luma1 && luma >= luma2){FragColor = vec4(1*luma, 0, 0,1);}
        if (luma1 >= luma && luma >= luma2){FragColor = vec4(0, 1*luma, 0,1);}
        if (luma2 >= luma1 && luma >= luma){FragColor = vec4(0, 0, 1*luma,1);};}

    
    ;}
    
    if (lumaColor == 1){
    
        if (buffer>= (luma*0.9)){FragColor=vec4(vec3(0),1);}
        if (mod((gl_FragCoord.x+0.5),pixelRatio)>=pixelSize && mod((gl_FragCoord.y+0.5),pixelRatio)>=pixelSize){
    
            if (buffer<(luma*0.9)){
            
            FragColor = vec4(luma*exp(buffer), luma1*exp(buffer), luma2*exp(buffer),1);
            FragColor = vec4(getColPixel0.r, getColPixel0.g, getColPixel0.b,1)
            
            ;}
        ;}
    ;}
    
    gl_FragColor = FragColor;
    
}
