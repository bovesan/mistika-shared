// http://glsl.heroku.com/e#9396.0

uniform vec3 param2;
float Speed = float(param2.z) * 0.01;
uniform vec3 param3;
float Offset = float(param3.x) * 0.01;
uniform vec3 param1;
float Thickness = float(param1.z) * 0.01;
float x = float(param3.y) * 0.01;
float y = float(param3.z) * 0.01;
uniform vec3 param4;
float z = float(param4.x) * 0.01;
uniform vec3 param5;
float zoom = float(param5.x) * 0.01;
float p1 = float(param2.x) * 0.01;
float p2 = float(param2.y) * 0.01;
float p3 = float(param5.y) * 1.0;
int Itterations = int(param1.x);
int res = int(param1.y);
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float adsk_time = float(param5.z) * 1.0;
uniform vec3 param6;
vec3 direction = vec3(param6.x, param6.y, param6.z) * 1.0;
uniform vec3 param7;
vec2 center = vec2(param7.x, param7.y) * 0.01;

float time = adsk_time *.05 * Speed + Offset;

// a raymarching experiment by kabuto
//fork by tigrou ind (2013.01.22)

vec3 field(vec3 p) {
    p *= .1;
    float f = .1;
    for (int i = 0; i < res; i++) {
        p = p.yzx*mat3(.6* p1,.6* p1,0,-.6,.6*p1,0,0,0,1);
        p += vec3(.1*p2,.456* p2,.789*p2)*float(0.1);
        p = abs(fract(p)-.5);
        p *= 2.0;
        f *= 2.001;
    }
    p *= p;
    return sqrt(p+p.yzx)/f-.035 * Thickness;
}

void main( void ) {
    float jit = 0.01;
    if (mod(time, 0.1) < 2.0 ) jit = 0.005;
    vec3 dir = normalize(vec3((gl_FragCoord.xy - resolution * center ) / resolution.x, zoom));
    float a = 0.0;
    vec3 pos = vec3(x * time, y * time, z * time);
    dir *= mat3(1,0,0,0,cos(a),-sin(a),0,sin(a),cos(a));
    dir *= mat3(cos(a),0,-sin(a),0,1,0,sin(a),0,cos(a));
    vec3 color = vec3(0);
    for (int i = 0; i < Itterations; i++) {
        vec3 f2 = field(pos);
        float f = min(min(f2.x,f2.y),f2.z);
        
        pos += dir*f;
        color += float(Itterations-i)/(f2+jit);
    }
    vec3 color3 = vec3(1.-1./(1.+color*(.09/float(Itterations*Itterations))));
    color3 *= color3;
    gl_FragColor = vec4(vec3(color3.r+color3.g+color3.b),1.);
}