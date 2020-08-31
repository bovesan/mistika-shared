uniform sampler2DRect image1;
uniform sampler2DRect image2;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param3;
int samples = int(param3.x);
uniform vec3 param2;
int rings = int(param2.z);
uniform vec3 param6;
bool autofocus = bool(param6.x);
uniform vec3 param1;
float maxblur = float(param1.x) * 0.005;
float threshold = float(param1.y) * 0.005;
float gain = float(param1.z) * 0.005;
uniform vec3 param8;
float bias = float(param8.x) * 0.01;
float fringe = float(param2.y) * 0.005;
uniform vec3 param7;
bool noise = bool(param7.y);
float namount = float(param7.z) * 0.001;
bool depthblur = bool(param6.z);
float dbsize = float(param7.x) * 0.01;
bool pentagon = bool(param3.z);
uniform vec3 param4;
float feather = float(param4.x) * 0.01;

float aspect = float(param3.y) * 0.01;
float exp_noise = float(param2.x) * 0.01;

// begin new uniforms
/* 
make sure that these two values are the same for your camera, otherwise distances will be wrong.
*/
uniform vec3 param5;
float znear = float(param5.x) * 0.001;
float zfar = float(param5.y) * 0.001;


float focalDepth = float(param5.z) * 0.002;
float focalLength = float(param4.y) * 0.05;
float aperture = float(param4.z) * 0.01;
bool showFocus = bool(param6.y);

// end new uniforms

#define PI  3.14159265

float width = adsk_result_w; //texture width
float height = adsk_result_h; //texture height

vec2 texel = vec2(1.0/width,1.0/height);
vec2 focus = vec2(0.5,0.5); // autofocus point on screen (0.0,0.0 - left lower corner, 1.0,1.0 - upper right)






/*
next part is experimental
not looking good with small sample and ring count
looks okay starting from samples = 4, rings = 4
*/

float penta(vec2 coords) //pentagonal shape
{
    float scale = float(rings) - 1.3;
    vec4  HS0 = vec4( 1.0,         0.0,         0.0,  1.0);
    vec4  HS1 = vec4( 0.309016994, 0.951056516, 0.0,  1.0);
    vec4  HS2 = vec4(-0.809016994, 0.587785252, 0.0,  1.0);
    vec4  HS3 = vec4(-0.809016994,-0.587785252, 0.0,  1.0);
    vec4  HS4 = vec4( 0.309016994,-0.951056516, 0.0,  1.0);
    vec4  HS5 = vec4( 0.0        ,0.0         , 1.0,  1.0);
    
    vec4  one = vec4( 1.0 );
    
    vec4 P = vec4((coords),vec2(scale, scale)); 
    
    vec4 dist = vec4(0.0);
    float inorout = -4.0;
    
    dist.x = dot( P, HS0 );
    dist.y = dot( P, HS1 );
    dist.z = dot( P, HS2 );
    dist.w = dot( P, HS3 );
    
    dist = smoothstep( -feather, feather, dist );
    
    inorout += dot( dist, one );
    
    dist.x = dot( P, HS4 );
    dist.y = HS5.w - abs( P.z );
    
    dist = smoothstep( -feather, feather, dist );
    inorout += dist.x;
    
    return clamp( inorout, 0.0, 1.0 );
}

float bdepth(vec2 coords) //blurring depth
{
    float d = 0.0;
    float kernel[9];
    vec2 offset[9];
    
    vec2 wh = vec2(texel.x, texel.y) * dbsize;
    
    offset[0] = vec2(-wh.x,-wh.y);
    offset[1] = vec2( 0.0, -wh.y);
    offset[2] = vec2( wh.x -wh.y);
    
    offset[3] = vec2(-wh.x,  0.0);
    offset[4] = vec2( 0.0,   0.0);
    offset[5] = vec2( wh.x,  0.0);
    
    offset[6] = vec2(-wh.x, wh.y);
    offset[7] = vec2( 0.0,  wh.y);
    offset[8] = vec2( wh.x, wh.y);
    
    kernel[0] = 1.0/16.0;   kernel[1] = 2.0/16.0;   kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;   kernel[4] = 4.0/16.0;   kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;   kernel[7] = 2.0/16.0;   kernel[8] = 1.0/16.0;
    
    
    for( int i=0; i<9; i++ )
    {
        float tmp = texture2DRect(image2, res * coords + offset[i]).r;
        d += tmp * kernel[i];
    }
    
    return d;
}


vec3 color(vec2 coords,float blur) //processing the sample
{
    vec3 col = vec3(0.0);
    
    col.r = texture2DRect(image1, res *coords + vec2(0.0,1.0)*texel*fringe*blur).r;
    col.g = texture2DRect(image1, res *coords + vec2(-0.866,-0.5)*texel*fringe*blur).g;
    col.b = texture2DRect(image1, res *coords + vec2(0.866,-0.5)*texel*fringe*blur).b;
    
    vec3 lumcoeff = vec3(0.299,0.587,0.114);
    float lum = dot(col.rgb, lumcoeff);
    float thresh = max((lum-threshold)*gain, 0.0);
    return col+mix(vec3(0.0),col,thresh*blur);
}

vec2 rand(vec2 coord) //generating noise/pattern texture for dithering
{
    float noiseX = ((fract(1.0-coord.s*(width/2.0))*0.25)+(fract(coord.t*(height/2.0))*0.75))*2.0-1.0;
    float noiseY = ((fract(1.0-coord.s*(width/2.0))*0.75)+(fract(coord.t*(height/2.0))*0.25))*2.0-1.0;
    
    if (noise)
    {
        noiseX = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233))) * 43758.5453),0.0,1.0)*2.0-1.0;
        noiseY = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233)*2.0)) * 43758.5453),0.0,1.0)*2.0-1.0;
    }
    return vec2(noiseX,noiseY);
}

vec3 debugFocus(vec3 col, float blur)
{
    float m = smoothstep(0.0,0.01,blur);
    float e = smoothstep(0.99,1.0,blur);
    float ee = smoothstep(0.97,1.0,blur)-e;
    
    col = mix(vec3(1.0,0.0,0.0),col,m);
    col = mix(vec3(0.0,1.0,0.0),col,(1.0-ee)-(1.0-e)*0.1);
    return col;
}

float linearize(float depth)
{
    return -zfar * znear / (depth * (zfar - znear) - zfar);
}

void main() 
{
    float blur = 0.0;
    
    float depth = linearize(texture2DRect(image2,gl_TexCoord[0].xy).x);
    
    if (depthblur)
    {
        depth = linearize(bdepth(gl_TexCoord[0].xy));
    }
 
    blur = abs(aperture * (focalLength * (depth - focalDepth)) /(depth * (focalDepth - focalLength)));
    
    if (autofocus)
    {
        float fDepth = linearize(texture2DRect(image2,focus).x);
        blur = abs(aperture * (focalLength * (depth - fDepth)) /
        (depth * (fDepth - focalLength)));
    }

    blur = clamp(blur,0.0,1.0);

    vec2 noise = rand(gl_TexCoord[0].xy)*namount*0.005*blur;
    
    float w = (1.0/width)*blur*maxblur+noise.x;
    float h = (1.0/height)*blur*maxblur+noise.y;
    
    vec3 col = texture2DRect(image1, res * gl_TexCoord[0].xy).rgb;
    float s = 1.0;
    
    int ringsamples;
    
    for (int i = 1; i <= rings; i += 1)
    {   
        ringsamples = i * samples;
         
        for (int j = 0 ; j < ringsamples ; j += 1)   
        {
            float step = PI*2.0 * exp_noise / float(ringsamples);
            float pw = (cos(float(j)*step)*float(i));
            float ph = (sin(float(j)*step)*float(i));
            
            float p = 1.0;
            if (pentagon)
            { 
            p = penta(vec2(pw,ph));
            }
            
            if ( aspect > 1.0 )
            {
                ph *= aspect;
            }
            
            else if ( aspect < 1.0 )
            {
                pw /= aspect;
            }
            

            col += color(gl_TexCoord[0].xy + vec2(pw*w,ph*h),blur)*mix(1.0,(float(i))/(float(rings)),bias)*p;  
            s += 1.0*mix(1.0,(float(i))/(float(rings)),bias)*p;   
        }
    }
    
    
    col /= s;   
    
    if (showFocus)
    {
        col = debugFocus(col, blur);
    }
    
    gl_FragColor.rgb = col;
    gl_FragColor.a = 1.0;
}