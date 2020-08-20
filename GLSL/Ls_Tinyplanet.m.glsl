// Stereographic projection of a 360x180 latlong panorama, tiny planets style
// lewis@lewissaunders.com

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform sampler2DRect image1;
uniform vec3 param2;
float yo = float(param2.y) * 0.01;
float xo = float(param2.x) * 0.01;
uniform vec3 param1;
float long0 = float(param1.y) * 0.01;
float lat1 = float(param1.x) * 0.01;
float r = float(param1.z) * 0.001;
float latm = float(param2.z) * 0.01;
uniform vec3 param3;
float longm = float(param3.x) * 0.001;
float lato = float(param3.y) * 0.01;
float longo = float(param3.z) * 0.01;

// Defaults set in XML:
// xo = 0.5
// yo = 0.5
// long0, lat1, r = adjusted to taste
// latm = 1.0 / PI
// longm = 1.0 / (2.0 * PI)
// lato = -PI / 2.0
// longo = -PI

void main() {
    vec2 coords = gl_FragCoord.xy / res;
    coords.x -= 0.5;
    coords.x *= (res.x / res.y);
    coords.x += 0.5;

    float p = sqrt((coords.x-xo)*(coords.x-xo)+(coords.y-yo)*(coords.y-yo));
    float c = 2.0 * atan(p, 2.0 * r);
    float longg = (long0 + atan((coords.x-xo)*sin(c), p*cos(lat1)*cos(c) - (coords.y-yo)*sin(lat1)*sin(c)));
    float lat = asin(cos(c)*sin(lat1) + (((coords.y-yo)*sin(c)*cos(lat1)) / p));
    vec2 uv;
    uv.x = (longg - longo) * longm;
    uv.y = (lat - lato) * latm;

    vec3 o = texture2DRect(image1, res * uv).rgb;

    gl_FragColor = vec4(o, 1.00);
}
