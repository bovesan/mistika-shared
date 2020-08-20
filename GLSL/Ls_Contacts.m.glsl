// Tiles the inputs into a grid for impressing clients
// lewis@lewissaunders.com
// TODO:
//  o Nonsquare pixels support... eek
//  o Variable width borders look gross, how can we get a nice even spacing?

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform sampler2DRect image4;
uniform sampler2DRect image5;
uniform sampler2DRect image6;
uniform vec3 param1;
int rows = int(param1.y);
int cols = int(param1.x);
uniform vec3 param3;
int randomcount = int(param3.y);
int seed = int(param3.x);
uniform vec3 param2;
bool random = bool(param2.y);
bool perframe = bool(param2.z);
bool filltiles = bool(param1.z);
float scale = float(param2.x) * 0.1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float adsk_time = float(param3.z) * 1.0;

// Mysterious dirty random number generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 coords = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);
    vec2 tilecoords = vec2(0.0, 0.0);
    vec4 o = vec4(0.0);
    float aspectdiff, tilew, tileh;
    int tilex, tiley, tileidx;

    // Figure out how big each tile will be, and which tile we're in
    tilew = adsk_result_w / float(cols);
    tileh = adsk_result_h / float(rows);
    tilex = int(gl_FragCoord.x / tilew);
    tiley = int((adsk_result_h - gl_FragCoord.y) / tileh);
    tileidx = tiley * cols + tilex;
    
    // Randomize the tile index
    if(random) {
        if(perframe) {
            tileidx = int(rand(vec2(float(tilex - seed), float(tiley) + 1234.0 * adsk_time)) * float(randomcount));
        } else {
            tileidx = int(rand(vec2(float(tilex - seed), float(tiley))) * float(randomcount));
        }
    }

    // Get current coordinates within this tile
    tilecoords.x = mod(gl_FragCoord.x, tilew) / tilew;
    tilecoords.y = mod(gl_FragCoord.y, tileh) / tileh;
    
    // Scale coordinates about the centre of each tile to maintain proportions and do fit/fill
    tilecoords -= vec2(0.5);
    tilecoords *= 100.0 / scale;
    aspectdiff = (tilew / tileh) / (adsk_result_w / adsk_result_h);
    if(aspectdiff > 1.0) {
        tilecoords.x *= aspectdiff;
        if(filltiles) {
            tilecoords /= aspectdiff;
        }
    } else {
        tilecoords.y /= aspectdiff;
        if(filltiles) {
            tilecoords *= aspectdiff;
        }
    }
    tilecoords += vec2(0.5);
    
    // Finally grab input for the tile we're in
    if(tileidx == 0) {
        o = texture2DRect(image1, res * tilecoords);
    } else if(tileidx == 1) {
        o = texture2DRect(image2, res * tilecoords);
    } else if(tileidx == 2) {
        o = texture2DRect(image3, res * tilecoords);
    } else if(tileidx == 3) {
        o = texture2DRect(image4, res * tilecoords);
    } else if(tileidx == 4) {
        o = texture2DRect(image5, res * tilecoords);
    } else if(tileidx == 5) {
        o = texture2DRect(image6, res * tilecoords);
    }
    
    // Draw black if we're in a border area
    if((tilecoords.x <= 0.0) || (tilecoords.x > 1.0)) {
            o = vec4(0.0);
    }
    if((tilecoords.y <= 0.0) || (tilecoords.y > 1.0)) {
            o = vec4(0.0);
    }
    
    gl_FragColor = o;
}
