vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect image2;
uniform sampler2DRect image1;
uniform sampler2DRect image4;
uniform sampler2DRect image3;

uniform vec3 param2;
float redTS = float(param2.y) * 0.01;
uniform vec3 param1;
float greenTS = float(param1.y) * 0.01;
float blueTS = float(param1.x) * 0.01;

int iterations = int(param2.x);
bool interpolate = bool(param1.z);

void main(void)
{
    vec2 st0;
    st0.x = gl_FragCoord.x / adsk_result_w;
    st0.y = gl_FragCoord.y / adsk_result_h;
    
    vec4 getColPixel0;
    getColPixel0 = texture2DRect(image3, res * st0);
    
    vec3 color;
    vec2 st1;
    vec2 st2;
    vec2 st3;
    vec4 getColPixel1;        
        
       vec3 prev = texture2DRect( image2, res * st0 ).rgb;
      vec3 next = texture2DRect( image1, res * st0 ).rgb;
       vec3 curr = texture2DRect( image3, res * st0 ).rgb;
        
        
        
    color = getColPixel0;
    float colorBuffer;
    int count=0;
    for (int x = 0; x <=iterations; x++)
    {
        for (int y = 1; y<= iterations; y++)
        {
        st1.x = (gl_FragCoord.x+x) / adsk_result_w;
        st1.y = (gl_FragCoord.y+y) / adsk_result_h;
        if ( (gl_FragCoord.x+x) >=0 && (gl_FragCoord.x+x) <= adsk_result_w){getColPixel1 = texture2DRect(image4, res * st1);}
        if ( (gl_FragCoord.y+y) >=0 && (gl_FragCoord.y+y) <= adsk_result_h){getColPixel1 = texture2DRect(image4, res * st1);}        
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
        if ( (gl_FragCoord.x-x) >=0 && (gl_FragCoord.x-x) <= adsk_result_w){getColPixel1 = texture2DRect(image4, res * st1);}
        if ( (gl_FragCoord.y+y) >=0 && (gl_FragCoord.y+y) <= adsk_result_h){getColPixel1 = texture2DRect(image4, res * st1);}        
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
        if ( (gl_FragCoord.x+x) >=0 && (gl_FragCoord.x+x) <= adsk_result_w){getColPixel1 = texture2DRect(image4, res * st1);}
        if ( (gl_FragCoord.y-y) >=0 && (gl_FragCoord.y-y) <= adsk_result_h){getColPixel1 = texture2DRect(image4, res * st1);}        
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
        if ( (gl_FragCoord.x-x) >=0 && (gl_FragCoord.x-x) <= adsk_result_w){getColPixel1 = texture2DRect(image4, res * st1);}
        if ( (gl_FragCoord.y-y) >=0 && (gl_FragCoord.y-y) <= adsk_result_h){getColPixel1 = texture2DRect(image4, res * st1);}        
        color += getColPixel1;count++;
        }
    count++;
    }
    color/=count;
    float buffer = 1;
    vec3 outcolor = curr;
    if ((color.r*redTS)>=(color.b*blueTS) && (color.r*redTS)>=(color.g*greenTS) ){outcolor = next;if (interpolate == 1){outcolor = (next+curr)*0.5;}}
    if ((color.g*greenTS)>=(color.r*redTS) && (color.g*greenTS)>=(color.b*blueTS) ){outcolor = curr;}
    if ((color.b*blueTS)>=(color.r*redTS) && (color.b*blueTS)>=(color.g*greenTS) ){outcolor = prev;if (interpolate == 1){outcolor = (next+prev)*0.5;}}

    vec4 outColor;
    gl_FragColor =  vec4(outcolor,1.0);
}
