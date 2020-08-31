vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param1;
bool algo = bool(param1.x);
int iterations = int(param1.y);


uniform sampler2DRect image1;

void main(void)
{
    vec2 st0;
    st0.x = gl_FragCoord.x / adsk_result_w;
    st0.y = gl_FragCoord.y / adsk_result_h;
    
    vec4 getColPixel0;
    getColPixel0 = texture2DRect(image1, res * st0);
    
    vec3 color;
    vec2 st1;
    vec2 st2;
    vec2 st3;
    vec4 getColPixel1;        
        
        
        
        
    color = getColPixel0;
    float colorBuffer;
    int count=0;
    for (int x = 0; x <=iterations; x++)
    {
        for (int y = 1; y<= iterations; y++)
        {
        st1.x = (gl_FragCoord.x+x) / adsk_result_w;
        st1.y = (gl_FragCoord.y+y) / adsk_result_h;
        if ( (gl_FragCoord.x+x) >=0 && (gl_FragCoord.x+x) <= adsk_result_w){getColPixel1 = texture2DRect(image1, res * st1);}
        if ( (gl_FragCoord.y+y) >=0 && (gl_FragCoord.y+y) <= adsk_result_h){getColPixel1 = texture2DRect(image1, res * st1);}        
        color += getColPixel1;count++;
        }
    count++;
    }
    
    for (int x = 0; x <=iterations; x++)
    {
        for (int y = 1; y<= iterations; y++)
        {
        st1.x = (gl_FragCoord.x-x) / adsk_result_w;
        st1.y = (gl_FragCoord.y+y) / adsk_result_h;
        if ( (gl_FragCoord.x-x) >=0 && (gl_FragCoord.x-x) <= adsk_result_w){getColPixel1 = texture2DRect(image1, res * st1);}
        if ( (gl_FragCoord.y+y) >=0 && (gl_FragCoord.y+y) <= adsk_result_h){getColPixel1 = texture2DRect(image1, res * st1);}        
        color += getColPixel1;count++;
        }
    count++;
    }
    
    for (int x = 0; x <=iterations; x++)
    {
        for (int y = 1; y<= iterations; y++)
        {
        st1.x = (gl_FragCoord.x+x) / adsk_result_w;
        st1.y = (gl_FragCoord.y-y) / adsk_result_h;
        if ( (gl_FragCoord.x+x) >=0 && (gl_FragCoord.x+x) <= adsk_result_w){getColPixel1 = texture2DRect(image1, res * st1);}
        if ( (gl_FragCoord.y-y) >=0 && (gl_FragCoord.y-y) <= adsk_result_h){getColPixel1 = texture2DRect(image1, res * st1);}        
        color += getColPixel1;count++;
        }
    count++;
    }
    for (int x = 0; x <=iterations; x++)
    {
        for (int y = 1; y<= iterations; y++)
        {
        st1.x = (gl_FragCoord.x-x) / adsk_result_w;
        st1.y = (gl_FragCoord.y-y) / adsk_result_h;
        if ( (gl_FragCoord.x-x) >=0 && (gl_FragCoord.x-x) <= adsk_result_w){getColPixel1 = texture2DRect(image1, res * st1);}
        if ( (gl_FragCoord.y-y) >=0 && (gl_FragCoord.y-y) <= adsk_result_h){getColPixel1 = texture2DRect(image1, res * st1);}        
        color += getColPixel1;count++;
        }
    count++;
    }
    color/=count;
    if (algo==1){color+=getColPixel0;
    color/=2;}

    float buffer = 1;
    
    if (color.r>=color.b && color.r>=color.g ){color.r=1; color.g=0; color.b=0;}
    if (color.g>=color.r && color.g>=color.b ){color.r=0; color.g=1; color.b=0;}
    if (color.b>=color.r && color.b>=color.g ){color.r=0; color.g=0; color.b=1;}

    vec4 outColor;
    gl_FragColor =  vec4(color,1.0);
}
