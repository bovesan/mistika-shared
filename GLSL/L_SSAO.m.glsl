/*
SSAO GLSL shader v1.2
assembled by Martins Upitis (martinsh) (devlog-martinsh.blogspot.com)
original technique is made by Arkano22 (www.gamedev.net/topic/550699-ssao-no-halo-artifacts/)

changelog:
1.2 - added fog calculation to mask AO. Minor fixes.
1.1 - added spiral sampling method from here:
(http://www.cgafaq.info/wiki/Evenly_distributed_points_on_sphere)
*/
uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform vec3 param5;
float bgl_RenderedTextureWidth = float(param5.z) * 1.0;
uniform vec3 param6;
float bgl_RenderedTextureHeight = float(param6.x) * 1.0;
float adsk_time = float(param6.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect undefined;
float adsk_Input_pixelratio = float(param6.z) * 1.0;

#define PI    3.14159265359

float width = adsk_result_w; //texture width
float height = adsk_result_h; //texture height

vec2 texCoord = gl_TexCoord[0].st;

//------------------------------------------
//general stuff

//make sure that these two values are the same for your camera, otherwise distances will be wrong.

uniform vec3 param1;
float znear = float(param1.x) * 0.01;
uniform vec3 param3;
float zfar = float(param3.x) * 0.01;


//float znear = 0.3; //Z-near
//float zfar = 40.0; //Z-far

//user variables
uniform vec3 param2;
int samples = int(param2.y);

float radius = float(param3.y) * 0.01;
float aoclamp = float(param1.z) * 0.01;
bool noise = bool(param3.z);
uniform vec3 param4;
float noiseamount = float(param4.x) * 0.01;

float diffarea = float(param5.x) * 0.01;
float gdisplace = float(param1.y) * 0.01;

bool mist = bool(param5.y);
float miststart = float(param2.x) * 0.01;
float mistend = float(param2.z) * 0.01;

bool onlyAO = bool(param4.y);
float lumInfluence = float(param4.z) * 0.01;

//--------------------------------------------------------

vec2 rand(vec2 coord) //generating noise/pattern texture for dithering
{
    float noiseX = ((fract(1.0-coord.s*(width/2.0))*0.25)+(fract(coord.t*(height/2.0))*0.75))*2.0-1.0;
    float noiseY = ((fract(1.0-coord.s*(width/2.0))*0.75)+(fract(coord.t*(height/2.0))*0.25))*2.0-1.0;
    
    if (noise)
    {
        noiseX = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233))) * 43758.5453),0.0,1.0)*2.0-1.0;
        noiseY = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233)*2.0)) * 43758.5453),0.0,1.0)*2.0-1.0;
    }
    return vec2(noiseX,noiseY)*noiseamount;
}

float doMist()
{
    float zdepth = texture2DRect(image2, res *texCoord.xy).x;
    float depth = -zfar * znear / (zdepth * (zfar - znear) - zfar);
    return clamp((depth-miststart)/mistend,0.0,1.0);
}

float readDepth(in vec2 coord) 
{
    if (gl_TexCoord[0].x<0.0||gl_TexCoord[0].y<0.0) return 1.0;
    return (2.0 * znear) / (zfar + znear - texture2DRect(image2, coord ).x * (zfar-znear));
}

float compareDepths(in float depth1, in float depth2,inout int far)
{   
    float garea = 2.0; //gauss bell width    
    float diff = (depth1 - depth2)*100.0; //depth difference (0-100)
    //reduce left bell width to avoid self-shadowing 
    if (diff<gdisplace)
    {
    garea = diffarea;
    }else{
    far = 1;
    }
    
    float gauss = pow(2.7182,-2.0*(diff-gdisplace)*(diff-gdisplace)/(garea*garea));
    return gauss;
}   

float calAO(float depth,float dw, float dh)
{   
    float dd = (1.0-depth)*radius;
    
    float temp = 0.0;
    float temp2 = 0.0;
    float coordw = gl_TexCoord[0].x + dw*dd;
    float coordh = gl_TexCoord[0].y + dh*dd;
    float coordw2 = gl_TexCoord[0].x - dw*dd;
    float coordh2 = gl_TexCoord[0].y - dh*dd;
    
    vec2 coord = vec2(coordw , coordh);
    vec2 coord2 = vec2(coordw2, coordh2);
    
    int far = 0;
    temp = compareDepths(depth, readDepth(coord),far);
    //DEPTH EXTRAPOLATION:
    if (far > 0)
    {
        temp2 = compareDepths(readDepth(coord2),depth,far);
        temp += (1.0-temp)*temp2;
    }
    
    return temp;
} 

void main(void)
{
    vec2 noise = rand(texCoord); 
    float depth = readDepth(texCoord);
    
    float w = (1.0 / width)/clamp(depth,aoclamp,1.0)+(noise.x*(1.0-noise.x));
    float h = (1.0 / height)/clamp(depth,aoclamp,1.0)+(noise.y*(1.0-noise.y));
    
    float pw;
    float ph;
    
    float ao;
    
    float dl = PI*(3.0-sqrt(5.0));
    float dz = 1.0/float(samples);
    float l = 0.0;
    float z = 1.0 - dz/2.0;
    
    for (int i = 0; i <= samples; i ++)
    {     
        float r = sqrt(1.0-z);
        
        pw = cos(l)*r;
        ph = sin(l)*r;
        ao += calAO(depth,pw*w,ph*h);        
        z = z - dz;
        l = l + dl;
    }
    
    ao /= float(samples);
    ao = 1.0-ao;    
    
    if (mist)
    {
    ao = mix(ao, 1.0,doMist());
    }
    
    vec3 color = texture2DRect(image1    , res *texCoord).rgb;
    
    vec3 lumcoeff = vec3(0.299,0.587,0.114);
    float lum = dot(color.rgb, lumcoeff);
    vec3 luminance = vec3(lum, lum, lum);
    
    vec3 final = vec3(color*mix(vec3(ao),vec3(1.0),luminance*lumInfluence));//mix(color*ao, white, luminance)
    
    if (onlyAO)
    {
    final = vec3(mix(vec3(ao),vec3(1.0),luminance*lumInfluence)); //ambient occlusion only
    }
    
    
    gl_FragColor = vec4(final,1.0); 
    
}