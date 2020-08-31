#version 120

//based on http://glslsandbox.com/e#21316.0

uniform vec3 param1;
float zoom = float(param1.y) * 0.01;
float width = float(param1.x) * 0.01;
float rot = float(param1.z) * 0.01;
uniform vec3 param2;
float adsk_time = float(param2.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param3;
float adsk_result_frameratio = float(param3.x) * 1.0;

vec2 center = vec2(param3.y, param3.z) * 0.01;

const float PI = 3.1415926;

float    hash(vec2 p);
mat2    rmat(float theta);
float    random_tiles(vec2 p);
float    cross(float x);

float smoothmin(float a, float b, float k)
{
    return -(log(exp(k*-a)+exp(k*-b))/k);
}

float maze( vec2 p ) 
{
    vec2 tp     = (p) * rmat(PI*.25 + (.0000125) * 2.);
    
    float t0     = random_tiles(tp * zoom * .5 - 4.);
    float t1     = random_tiles(tp * zoom * .5 + 32.);
    float t2     = random_tiles(tp * zoom * 2. + 32.);

    return 1.-(step(t2,.5));
}

float hash(vec2 p) {
    return fract(sin(p.x * 15.35 + p.y * 35.79) * 43758.23);
}

mat2 rmat(float theta)
{
    float c = cos(theta);
    float s = sin(theta);
    return mat2(c, s, -s, c);
}

float random_tiles(vec2 p) 
{
    vec2 lattice    = floor(p);
    float theta     = hash(lattice) > 0.5 ? 0.0 : PI * 0.5;    
    p         *= rmat(theta);
    vec2 f        = fract(p);
    return cross(f.x-f.y);
}

float cross(float x) 
{
    return abs(fract(x)-.5)*2. * width;    
}


void main( void ) 
{
    vec2 uv = ((gl_FragCoord.xy / resolution.xy) - 0.5) - center;
        
    mat2 rotation = mat2( cos(-rot*.1), -sin(-rot*.1), sin(-rot *.1), cos(-rot * .1));
    uv.x *= adsk_result_frameratio;
    uv *= rotation;
    uv.x /= adsk_result_frameratio;
    
    

    float m = maze(uv);
        
    gl_FragColor = vec4( 0., 0., 0., 1.) + m;
}


