vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform sampler2DRect image1;
uniform vec3 param1;
float Exposure = float(param1.x) * 0.01;
float Amount = float(param1.y) * 0.01;
float sat = float(param1.z) * 0.01;
uniform vec3 param4;
uniform vec3 param5;
vec3 RGB_lum = vec3(param4.y, param4.z, param5.x) * 0.01;
uniform vec3 param3;
bool tc1 = bool(param3.x);
bool tc2 = bool(param3.y);
bool tc3 = bool(param3.z);
bool tc4 = bool(param4.x);

const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

const vec3 redfilter_tc1         = vec3(1.0, 0.0, 0.0);
const vec3 bluegreenfilter_tc1     = vec3(0.0, 1.0, 0.7);

const vec3 redfilter_tc2        = vec3(1.0, 0.0, 0.0);
const vec3 bluegreenfilter_tc2     = vec3(0.0, 1.0, 1.0);
const vec3 cyanfilter_tc2        = vec3(0.0, 1.0, 0.5);
const vec3 magentafilter_tc2    = vec3(1.0, 0.0, 0.25);

const vec3 redfilter_tc3         = vec3(1.0, 0.0, 0.0);
const vec3 greenfilter_tc3         = vec3(0.0, 1.0, 0.0);
const vec3 bluefilter_tc3        = vec3(0.0, 0.0, 1.0);
const vec3 redorangefilter_tc3     = vec3(.99, 0.263, 0.0);
const vec3 cyanfilter_tc3        = vec3(0.0, 1.0, 1.0);
const vec3 magentafilter_tc3    = vec3(1.0, 0.0, 1.0);
const vec3 yellowfilter_tc3     = vec3(1.0, 1.0, 0.0);

void main(void)
{

    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec3 tc = texture2DRect(image1, res * uv).rgb;

    vec3 RGB_lum = vec3(lumcoeff * RGB_lum);
    float lum = dot(tc,RGB_lum);
    vec3 luma = vec3(lum);
    
    vec3 col = vec3(0.0);
    //gl_FragColor = tc;
        
    if ( tc1 )
    {
    vec3 redrecord = tc * redfilter_tc1;
    vec3 bluegreenrecord = tc * bluegreenfilter_tc1;
    vec3 rednegative = vec3(redrecord.r);
    vec3 bluegreennegative = vec3((bluegreenrecord.g + bluegreenrecord.b)/2.0);
    vec3 redoutput = rednegative * redfilter_tc1;
    vec3 bluegreenoutput = bluegreennegative * bluegreenfilter_tc1;
    vec3 result = redoutput + bluegreenoutput;
    col = mix(tc, result, Amount);
}

    if ( tc2 )
    {
    vec3 redrecord = tc * redfilter_tc2;
    vec3 bluegreenrecord = tc * bluegreenfilter_tc2;
    vec3 rednegative = vec3(redrecord.r);
    vec3 bluegreennegative = vec3((bluegreenrecord.g + bluegreenrecord.b)/2.0);
    vec3 redoutput = rednegative + cyanfilter_tc2;
    vec3 bluegreenoutput = bluegreennegative + magentafilter_tc2;
    vec3 result = redoutput * bluegreenoutput;
    col = mix(tc, result, Amount);
}

    if ( tc3 )
    {
    vec3 greenrecord = (tc) * greenfilter_tc3;
    vec3 bluerecord = (tc) * magentafilter_tc3;
    vec3 redrecord = (tc) * redorangefilter_tc3;
    vec3 rednegative = vec3((redrecord.r + redrecord.g + redrecord.b)/3.0);
    vec3 greennegative = vec3((greenrecord.r + greenrecord.g + greenrecord.b)/3.0);
    vec3 bluenegative = vec3((bluerecord.r+ bluerecord.g + bluerecord.b)/3.0);
    vec3 redoutput = rednegative + cyanfilter_tc3;
    vec3 greenoutput = greennegative + magentafilter_tc3;
    vec3 blueoutput = bluenegative + yellowfilter_tc3;
    vec3 result = redoutput * greenoutput * blueoutput;
    col = mix(tc, result, Amount);

}
    if ( tc4 )
    {
    vec3 redmatte = vec3(tc.r - ((tc.g + tc.b)/2.0));
    vec3 greenmatte = vec3(tc.g - ((tc.r + tc.b)/2.0));
    vec3 bluematte = vec3(tc.b - ((tc.r + tc.g)/2.0));
    redmatte = 1.0 - redmatte;
    greenmatte = 1.0 - greenmatte;
    bluematte = 1.0 - bluematte;
    vec3 red =  greenmatte * bluematte * tc.r;
    vec3 green = redmatte * bluematte * tc.g;
    vec3 blue = redmatte * greenmatte * tc.b;
    vec3 result = vec3(red.r, green.g, blue.b);
    col = mix(tc, result, Amount);

}
    gl_FragColor.rgb = mix(col, luma, sat) * Exposure;
}

