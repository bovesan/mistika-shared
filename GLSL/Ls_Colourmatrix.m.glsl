// Colour matrix shader for Matchbox
// I apologise for the incredibly stupid variable names but it's 3am yo
// lewis@lewissaunders.com

uniform sampler2DRect image1;
uniform sampler2DRect image2;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float r2r = float(param1.x) * 0.01;
uniform vec3 param3;
float r2g = float(param3.x) * 0.01;
uniform vec3 param5;
float r2b = float(param5.x) * 0.01;
float g2r = float(param1.y) * 0.01;
float g2g = float(param3.y) * 0.01;
float g2b = float(param5.y) * 0.01;
float b2r = float(param1.z) * 0.01;
float b2g = float(param3.z) * 0.01;
float b2b = float(param5.z) * 0.01;
uniform vec3 param11;
vec3 or = vec3(param11.x, param11.y, param11.z) * 0.01;
uniform vec3 param12;
vec3 og = vec3(param12.x, param12.y, param12.z) * 0.01;
uniform vec3 param13;
vec3 ob = vec3(param13.x, param13.y, param13.z) * 0.01;
uniform vec3 param14;
vec3 ir = vec3(param14.x, param14.y, param14.z) * 0.01;
uniform vec3 param15;
vec3 ig = vec3(param15.x, param15.y, param15.z) * 0.01;
uniform vec3 param16;
vec3 ib = vec3(param16.x, param16.y, param16.z) * 0.01;
uniform vec3 param10;
float effect = float(param10.x) * 0.01;
float gain = float(param10.y) * 0.01;
float mixx = float(param10.z) * 0.01;

void main() {
    vec2 coords = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);
    float mixx_here = mixx * texture2DRect(image2, res * coords).r;
    vec3 i = texture2DRect(image1, res * coords).rgb;
    vec3 ii = vec3(r2r*i.r + g2r*i.g + b2r*i.b, r2g*i.r + g2g*i.g + b2g*i.b, r2b*i.r + g2b*i.g + b2b*i.b);
    vec3 iii = ii * mat3(or, og, ob);
    vec3 iv = mat3(ir, ig, ib) * iii;
    vec3 v = effect*iv + (1.0-effect)*i;
    vec3 vi = gain * v;
    vec3 vii = mixx_here*vi + (1.0-mixx_here)*i;
    gl_FragColor = vec4(vii, 1.0);
}
