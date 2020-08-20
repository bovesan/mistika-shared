// Vector operations
// Normalize, scale, rotate, translate, compute lengths of and combine vector passes
// lewis@lewissaunders.com
// TODO:
//  o Gamma?
//  o NaN killing after length/normalisation

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform sampler2DRect image4;
uniform sampler2DRect image5;
uniform sampler2DRect image6;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param1;
bool Anorm = bool(param1.x);
bool Bnorm = bool(param1.y);
bool Cnorm = bool(param1.z);
uniform vec3 param2;
bool Dnorm = bool(param2.x);
bool Onorm = bool(param2.y);
uniform vec3 param34;
uniform vec3 param35;
vec3 Amult = vec3(param34.y, param34.z, param35.x) * 0.01;
uniform vec3 param36;
vec3 Bmult = vec3(param35.y, param35.z, param36.x) * 0.01;
uniform vec3 param37;
vec3 Cmult = vec3(param36.y, param36.z, param37.x) * 0.01;
uniform vec3 param38;
vec3 Dmult = vec3(param37.y, param37.z, param38.x) * 0.01;
uniform vec3 param39;
vec3 Omult = vec3(param38.y, param38.z, param39.x) * 0.01;
uniform vec3 param40;
vec3 Amult2 = vec3(param39.y, param39.z, param40.x) * 0.01;
uniform vec3 param41;
vec3 Bmult2 = vec3(param40.y, param40.z, param41.x) * 0.01;
uniform vec3 param42;
vec3 Cmult2 = vec3(param41.y, param41.z, param42.x) * 0.01;
uniform vec3 param43;
vec3 Dmult2 = vec3(param42.y, param42.z, param43.x) * 0.01;
uniform vec3 param44;
vec3 Omult2 = vec3(param43.y, param43.z, param44.x) * 0.01;
uniform vec3 param14;
float Amult3 = float(param14.y) * 0.01;
float Bmult3 = float(param14.z) * 0.01;
uniform vec3 param15;
float Cmult3 = float(param15.x) * 0.01;
float Dmult3 = float(param15.y) * 0.01;
float Omult3 = float(param15.z) * 0.01;
uniform vec3 param45;
vec3 Arot = vec3(param44.y, param44.z, param45.x) * 0.1;
uniform vec3 param46;
vec3 Brot = vec3(param45.y, param45.z, param46.x) * 0.1;
uniform vec3 param47;
vec3 Crot = vec3(param46.y, param46.z, param47.x) * 0.1;
uniform vec3 param48;
vec3 Drot = vec3(param47.y, param47.z, param48.x) * 0.1;
uniform vec3 param49;
vec3 Orot = vec3(param48.y, param48.z, param49.x) * 0.1;
uniform vec3 param50;
vec3 Aadd = vec3(param49.y, param49.z, param50.x) * 0.01;
uniform vec3 param51;
vec3 Badd = vec3(param50.y, param50.z, param51.x) * 0.01;
uniform vec3 param52;
vec3 Cadd = vec3(param51.y, param51.z, param52.x) * 0.01;
uniform vec3 param53;
vec3 Dadd = vec3(param52.y, param52.z, param53.x) * 0.01;
uniform vec3 param54;
vec3 Oadd = vec3(param53.y, param53.z, param54.x) * 0.01;
uniform vec3 param55;
vec3 Aadd2 = vec3(param54.y, param54.z, param55.x) * 0.01;
uniform vec3 param56;
vec3 Badd2 = vec3(param55.y, param55.z, param56.x) * 0.01;
uniform vec3 param57;
vec3 Cadd2 = vec3(param56.y, param56.z, param57.x) * 0.01;
uniform vec3 param58;
vec3 Dadd2 = vec3(param57.y, param57.z, param58.x) * 0.01;
uniform vec3 param59;
vec3 Oadd2 = vec3(param58.y, param58.z, param59.x) * 0.01;
bool Alen = bool(param2.z);
uniform vec3 param3;
bool Blen = bool(param3.x);
bool Clen = bool(param3.y);
bool Dlen = bool(param3.z);
uniform vec3 param4;
bool Olen = bool(param4.x);

uniform vec3 param31;
bool add = bool(param31.x);
bool subtract = bool(param31.y);
bool screen = bool(param31.z);
uniform vec3 param32;
bool outside = bool(param32.x);
bool adotb = bool(param32.y);
bool acrossb = bool(param32.z);
uniform vec3 param33;
float mixa = float(param33.x) * 0.01;

uniform vec3 param60;
vec3 picker = vec3(param59.y, param59.z, param60.x) * 0.01;

#define pi 3.1415926535897932384624433832795

// Degrees to radians
float deg2rad(float angle) {
    return(angle/(180.0/pi));
}

// Rotates in ZXY order
vec3 rotate(vec3 p, vec3 angles) {
    float x = deg2rad(angles.x);
    float y = deg2rad(angles.y);
    float z = deg2rad(angles.z);
    mat3 rx = mat3(1.0, 0.0, 0.0, 0.0, cos(x), sin(x), 0.0, -sin(x), cos(x));
    mat3 ry = mat3(cos(y), 0.0, -sin(y), 0.0, 1.0, 0.0, sin(y), 0.0, cos(y));
    mat3 rz = mat3(cos(z), sin(z), 0.0, -sin(z), cos(z), 0.0, 0.0, 0.0, 1.0);
    mat3 r = ry * rx * rz;
    return(p * r);
}

// Go!
void main() {
    vec2 xy = gl_FragCoord.xy / res;

    vec3 a = texture2DRect(image1, res * xy).rgb;
    vec3 b = texture2DRect(image2, res * xy).rgb;
    vec3 c = texture2DRect(image3, res * xy).rgb;
    vec3 d = texture2DRect(image4, res * xy).rgb;
    vec3 e = texture2DRect(image5, res * xy).rgb;
    vec3 f = texture2DRect(image6, res * xy).rgb;

    if(Anorm) a = normalize(a);
    if(Bnorm) b = normalize(b);
    if(Cnorm) c = normalize(c);
    if(Dnorm) d = normalize(d);

    a = rotate(a * Amult * Amult2 * Amult3, Arot) + Aadd + Aadd2;
    b = rotate(b * Bmult * Bmult2 * Bmult3, Brot) + Badd + Badd2;
    c = rotate(c * Cmult * Cmult2 * Cmult3, Crot) + Cadd + Cadd2;
    d = rotate(d * Dmult * Dmult2 * Dmult3, Drot) + Dadd + Dadd2;

    if(Alen) a = vec3(length(a));
    if(Blen) b = vec3(length(b));
    if(Clen) c = vec3(length(c));
    if(Dlen) d = vec3(length(d));

    vec3 o = vec3(0.0);
    if(add) o = a + b + c + d + e + f;
    if(subtract) o = a - b - c - d - e - f;
    vec3 one = vec3(1.0);
    if(screen) o = one - (one - a) * (one - b) * (one - c) * (one - d) * (one - e) * (one - f);
    if(outside) o = a * (one - b) * (one - c) * (one - d) * (one - e) * (one - f);
    if(adotb) o = vec3(dot(a, b));
    if(acrossb) o = cross(a, b);
    o = mixa * o + (1.0 - mixa) * texture2DRect(image1, res * xy).rgb;

    if(Onorm) o = normalize(o);
    o = rotate(o * Omult * Omult2 * Omult3, Orot) + Oadd + Oadd2;
    if(Olen) o = vec3(length(o));

    // Bonus matte output!  It's kind of a measure of how similar the result is to the image1 input
    float m = dot(o, a);

    gl_FragColor = vec4(o, m);
}
