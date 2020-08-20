uniform sampler2DRect image1;
//uniform sampler2D alpha;
uniform vec3 param3;
float adsk_image_w = float(param3.z) * 1.0;
uniform vec3 param4;
float adsk_image_h = float(param4.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float chromatic_abb = float(param1.x) * 0.01;
int num_iter = int(param1.y);
uniform vec3 param2;
bool add_distortion = bool(param2.z);
float d_amount = float(param3.x) * 0.01;
float ca_amt = float(param3.y) * 0.01;
float off_chroma = float(param2.y) * 0.01;
vec2 center = vec2(param4.y, param4.z) * 0.01;

vec2 iResolution = vec2(adsk_result_w, adsk_result_h);

vec2 barrelDistortion(vec2 coord, float amt) {
    
    vec2 cc = (((gl_FragCoord.xy/iResolution.xy) - center ));
    float distortion = dot(cc * d_amount * .3, cc);

    if ( add_distortion )
        return mix( coord + cc * distortion * -1., coord + cc * distortion * -1. * amt, ca_amt) ;
    else
        return coord + cc * amt * -.05;
}

float sat( float t )
{
    return clamp( t, 0.0, 1.0 );
}

float linterp( float t ) {
    return sat( 1.0 - abs( 2.0*t - 1.0 ) );
}

float remap( float t, float a, float b ) {
    return sat( (t - a) / (b - a) );
}

vec3 spectrum_offset( float t ) {
    vec3 ret;
    float lo = step(t,0.5);
    float hi = 1.0-lo;
    float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
    ret = vec3(lo,1.0,hi) * vec3(1.0-w, w, 1.0-w);
    return pow( ret, vec3(1.0/2.2) );
}

void main()
{    
    vec2 uv=(gl_FragCoord.xy/iResolution.xy);
    vec3 sumcol = vec3(0.0);
    vec3 sumw = vec3(0.0);
    vec3 matte = vec3(0.0);    
        
    for ( int i=0; i<num_iter;++i )
    {
        float t = float(i) * (1.0 / float(num_iter));
        vec3 w_off = spectrum_offset( t );
        vec3 w_st = vec3(1.0);
        vec3 w = mix(w_st, w_off, off_chroma);
        sumw += w;
        sumcol += w * texture2DRect( image1, res * barrelDistortion(uv, chromatic_abb * t ) ).rgb;

        matte.r = sumcol.r  / sumw.r;
        matte.g = sumcol.r  / sumw.g;
        matte.b = sumcol.r / sumw.b;
    
        matte.r += sumcol.g  / sumw.r;
        matte.g += sumcol.g  / sumw.g;
        matte.b += sumcol.g / sumw.b;

        matte.r += sumcol.b  / sumw.r;
        matte.g += sumcol.b / sumw.g;
        matte.b += sumcol.b / sumw.b;
    }
        
    gl_FragColor = vec4(sumcol.rgb / sumw,  matte );
}
