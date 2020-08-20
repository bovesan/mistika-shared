vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform sampler2DRect image1;

uniform vec3 param1;
bool alias = bool(param1.x);
int iterations = int(param1.y);

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
    vec2 st4;
    vec2 st5;
    vec2 st6;
    vec2 st7;
    vec2 st8;
    vec4 getColPixel1;
    vec4 getColPixel2;
    vec4 getColPixel3;
    vec4 getColPixel4;
    vec4 getColPixel5;
    vec4 getColPixel6;
    vec4 getColPixel7;
    vec4 getColPixel8;
        
        
        
        
        
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
    float buffer = 1;
    
    if (((color.x+color.y+color.z)/3)<(buffer*0.33)){color=vec3(0);}
    if (((color.x+color.y+color.z)/3)>=(buffer*0.33)&&((color.x+color.y+color.z)/3)<(buffer*0.51)){color=getColPixel0;if(alias!=0){color=vec3(0.5);}}
    if (((color.x+color.y+color.z)/3)>=(buffer*0.51)){color=vec3(1);}


    gl_FragColor = vec4(color,1.0);
}
