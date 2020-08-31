// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
// original created by JoshP in 7/5/2013

uniform vec3 param4;
float adsk_time = float(param4.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
int resolution = int(param1.y);
uniform vec3 param2;
float offsetx = float(param2.x) * 0.001;
float offsety = float(param1.z) * 0.001;
float p3 = float(param4.y) * 1.0;
float seed = float(param2.y) * 1.0;
float zoom = float(param1.x) * 0.01;
float gain = float(param2.z) * 0.01;
uniform vec3 param5;
vec3 color = vec3(param4.z, param5.x, param5.y) * 0.01;

float iGlobalTime = adsk_time;
vec2 iResolution = vec2(adsk_result_w, adsk_result_h);

float field(in vec3 p) {
    float strength = 9. + .00003 * log(1.e-6 + fract(sin(iGlobalTime) * 4373.11));
    float accum = 0.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < resolution; ++i) {
        float mag = dot(p, p);
        p = abs(p) / mag + vec3(-.5, -.4, -1.5);
        float w = exp(-float(i) / 7.);
        accum += w * exp(-strength * pow(abs(mag - prev), 2.3));
        tw += w;
        prev = mag;
    }
    return max(0., 4.3 * accum / tw - 0.7);
}

void main() {
    vec2 uv = 2. * gl_FragCoord.xy / iResolution.xy - 1.;
    vec2 uvs = uv * iResolution.xy / max(iResolution.x, iResolution.y);
    vec3 p = vec3(uvs / zoom, 0) + vec3(1., -1.3, 0.);
    p += .2 * vec3(offsetx, offsety, iGlobalTime / seed);
    float t = field(p);
    gl_FragColor = mix(0.1, 1.0, gain) * vec4(color.r * t * t * t, color.g *t * t, color.b * t, 1.0);
}