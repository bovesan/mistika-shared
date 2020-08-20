// Filmstrip
// Arranges input frames into a grid
// TOOD: figure out why increasing border squashes picture...
// lewis@lewissaunders.com

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param2;
float adsk_result_frameratio = float(param2.y) * 1.0;
float adsk_result_pixelratio = float(param2.z) * 1.0;
uniform vec3 param3;
float adsk_front_w = float(param3.x) * 1.0;
float adsk_front_h = float(param3.y) * 1.0;
float adsk_front_frameratio = float(param3.z) * 1.0;
uniform vec3 param4;
float adsk_front_pixelratio = float(param4.x) * 1.0;
uniform sampler2DRect image1;
uniform sampler2DRect image2;
bool adsk_accum_no_prev_frame = bool(param4.y);
float adsk_time = float(param4.z) * 1.0;
uniform vec3 param1;
float cols = float(param1.x) * 1.0;
float xborder = float(param1.y) * 0.1;
bool allframes = bool(param1.z);
bool centre = bool(param2.x);

void main() {
    vec2 xy = gl_FragCoord.xy / res;
    xy.y = 1.0 - xy.y;

    // We want border widths the same horizontally and vertically
    vec2 border = vec2((xborder/1000.0), (xborder/1000.0) * adsk_result_frameratio);
    
    // How many rows can we fit of these columns?
    float rows = cols * adsk_front_frameratio / adsk_result_frameratio;
    float colsused = floor(cols);
    float rowsused = floor(rows);
    if(centre) {
        // If the rows and cols don't fill frame, offset so they're centred
        xy -= (vec2(cols-colsused, rows-rowsused) / vec2(cols, rows)) / 2.0;
    }
   
   // Offset to inside edge of frame border, which is not part of the individual cells
    vec2 noframe = xy;
    noframe *= vec2(1.0) + 2.0 * border;
    noframe -= border;
    
    vec2 cellsize = vec2(1.0) / vec2(cols, rows);
    
    // Figure out which cell we're in
    vec2 loc = floor(noframe / cellsize);
    float frame = loc.y * colsused + loc.x;
    
    // Figure out where we are in this cell
    vec2 cell = noframe / cellsize;
    cell = mod(cell, 1.0);
    
    // Offset to be inside border of this cell
    vec2 noborder = cell;
    noborder *= vec2(1.0) + 2.0 * (border / cellsize);
    noborder -= border / cellsize;
    
    // Read previous output frame
    vec4 a = texture2DRect(image2, res * gl_FragCoord.xy / res);
    if(allframes || adsk_time == frame + 1.0) {
        // We're in the cell we need to add this time
        a = texture2DRect(image1, res * vec2(noborder.x, 1.0 - noborder.y));
    }
    
    // Output black in fill and matte for border areas
    bool isborder = false;
    if(noborder.x < 0.0 || noborder.x > 1.0 || noborder.y < 0.0 || noborder.y > 1.0) {
        isborder = true;
    }
    if(loc.x >= colsused || loc.x < 0.0 || loc.y >= rowsused || loc.y < 0.0) {
        isborder = true;
    }
    if(isborder) {
        a = vec4(0.0);
    }
    
    gl_FragColor = a;
}
