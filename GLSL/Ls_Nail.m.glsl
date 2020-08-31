// Transforms the area inside the nail image2 by the difference between two tracks
// Use to stick down floating CG, by nailing from a track on the CG to a track on the BG
// lewis@lewissaunders.com
// TODO:
//  o Anti-aliased overlay
//  o Rotate, scale, shear?
//  o Better filtering probably.  Not sure if EWA would work because no dFdx?

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param6;
vec2 trackfrom = vec2(param6.x, param6.y) * 0.1;
uniform vec3 param7;
vec2 trackto = vec2(param6.z, param7.x) * 0.1;
vec2 offset = vec2(param7.y, param7.z) * 0.1;
uniform vec3 param3;
float extra = float(param3.y) * 0.01;
float amount = float(param3.z) * 0.01;
uniform vec3 param4;
float edgeswoop = float(param4.x) * 0.01;
bool tracksarepixels = bool(param3.x);
bool matteistarget = bool(param4.y);
bool overlay = bool(param4.z);
uniform vec3 param8;
vec3 areatint = vec3(param8.x, param8.y, param8.z) * 0.01;

float distanceToSegment(vec2 p0, vec2 p1, vec2 p) {
    vec2 v = p1 - p0;
    vec2 w = p - p0;
    float c1 = dot(w, v);
    float c2 = dot(v, v);

    if(c1 <= 0.0)
        return length(p0 - p);
    if(c2 <= c1)
        return length(p1 - p);

    float b = c1 / c2;
    vec2 pb = p0 + b * v;
    return length(pb - p);
}

void main() {
    vec2 coords = gl_FragCoord.xy / res;

    vec2 diff = trackto - trackfrom + offset;
    diff *= extra;
    diff *= amount;

    if(tracksarepixels) {
        diff /= res;
    }

    float coeff = 0.0;
    if(matteistarget) {
        coeff = texture2DRect(image3, res * coords).b;
    } else {
        coeff = texture2DRect(image3, res * coords - diff).b;
    }
    coeff = mix(coeff, smoothstep(0.0, 1.0, coeff), edgeswoop);
    diff *= coeff;

    vec2 q = coords - diff;

    vec3 o = texture2DRect(image1, res * q).rgb;
    float m = texture2DRect(image2, res * q).b;

    if(overlay) {
        vec2 trackfromp = trackfrom;
        vec2 tracktop = trackto;
        vec2 offsetp = offset;
        vec2 coordsp = coords * res;

        if(!tracksarepixels) {
            trackfromp *= res;
            tracktop *= res;
            offsetp *= res;
        }

        if(length(coordsp - trackfromp) < 5.0)
            o = vec3(0.8, 0.2, 0.2);

        if(length(coordsp - tracktop) < 5.0)
            o = vec3(0.2, 0.8, 0.2);

        if(length(offsetp) > 0.0) {
            if(length(coordsp - (tracktop + offsetp)) < 5.0) {
                o = vec3(0.2, 0.2, 0.8);
            }
        }

        if(distanceToSegment(trackfromp, tracktop + offsetp, coordsp) < 1.0) {
            if(mod(length(trackfromp - coordsp), 8.0) < 4.0) {
                o = vec3(0.4, 0.4, 0.8);
            }
        }
        o += coeff * areatint;
    }

    gl_FragColor = vec4(o, m);
}
