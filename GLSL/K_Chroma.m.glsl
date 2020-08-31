//
// K_Chroma v1.1
// Shader written by:   Kyle Obley (kyle.obley@gmail.com) & Ivar Beer
// Shader adapted from: https://www.shadertoy.com/view/XssGz8
//

uniform sampler2DRect image1;
uniform vec3 param3;
float adsk_image_w = float(param3.x) * 1.0;
float adsk_image_h = float(param3.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float chromatic_abb = float(param1.x) * 0.01;
uniform vec3 param2;
float d_amount = float(param2.z) * 0.01;
int num_iter = int(param1.y);
bool add_distortion = bool(param2.y);
uniform vec3 param4;
vec2 center = vec2(param3.z, param4.x) * 0.01;

vec2 iResolution = vec2(adsk_result_w, adsk_result_h);

vec2 barrelDistortion(vec2 coord, float amt) {
    
    vec2 cc = (((gl_FragCoord.xy/iResolution.xy) - center ));
    float distortion = dot(cc * d_amount * .3, cc);

    if ( add_distortion )
        return coord + cc * distortion * -1. * amt;
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
    for ( int i=0; i<num_iter;++i )
    {
        float t = float(i) * (1.0 / float(num_iter));
        vec3 w = spectrum_offset( t );
        sumw += w;
        sumcol += w * texture2DRect( image1, res * barrelDistortion(uv, chromatic_abb * t ) ).rgb;
    }
        
    gl_FragColor = vec4(sumcol.rgb / sumw, 1.0);
}