// Pick an ellipsoidal area image2 from an XYZ position pass
// lewis@lewissaunders.com
// TODO:
//  o Rotation

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param6;
uniform vec3 param7;
vec3 pick = vec3(param6.z, param7.x, param7.y) * 0.01;
uniform vec3 param8;
vec3 overlaycol = vec3(param7.z, param8.x, param8.y) * 0.01;
uniform vec3 param2;
float tolerance = float(param2.x) * 0.01;
float softness = float(param2.y) * 0.01;
float falloffswoop = float(param2.z) * 0.01;
uniform vec3 param3;
float offsetx = float(param3.x) * 0.01;
float offsety = float(param3.y) * 0.01;
float offsetz = float(param3.z) * 0.01;
uniform vec3 param4;
float scalex = float(param4.x) * 0.01;
float scaley = float(param4.y) * 0.01;
float scalez = float(param4.z) * 0.01;
bool overlay = bool(param6.x);
bool hatch = bool(param6.y);
uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;

void main() {
    vec2 coords = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);
    vec3 o, frontpix, pospix, mattepix, centered, diff = vec3(0.0);
    float m = 0.0;

    frontpix = texture2DRect(image1, res * coords).rgb;
    mattepix = texture2DRect(image2, res * coords).rgb;
    pospix = texture2DRect(image3, res * coords).rgb;

    // Center coordinate space about the picked colour so we can scale easily
    centered = pospix - pick - vec3(offsetx, offsety, offsetz);
    diff = centered / vec3(scalex, scaley, scalez);

    m = length(diff);
    if(m < tolerance) {
        m = 0.0;
    } else {
        m = (m - tolerance) / softness;
    }
    m = clamp(1.0 - m, 0.0, 1.0);
    m = mix(m, smoothstep(0.0, 1.0, m), falloffswoop);
    m *= mattepix.b;

    o = frontpix;
    if(overlay) {
        o += m * overlaycol;
        if(hatch) {
            // Cheap-ass diagonal lines
            float h = mod(gl_FragCoord.x - gl_FragCoord.y, 20.0);
            h = h > 10.0 ? 0.0 : 1.0;
            o = mix(o, frontpix, h);
        }
    }

    gl_FragColor = vec4(o, m);
}
