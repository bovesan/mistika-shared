uniform vec3 param2;
float adsk_time = float(param2.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float iGlobalTime = adsk_time*.05;
vec2 iResolution = vec2(adsk_result_w, adsk_result_h);
uniform sampler2DRect image1;

uniform vec3 param1;
float p1 = float(param1.x) * 0.01;
float p2 = float(param1.y) * 0.01;
float p3 = float(param1.z) * 0.01;

// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

float hash( float n )
{
    return fract(sin(n)*p3);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

vec2 map( vec2 p )
{
    p.x += 0.1*sin( iGlobalTime + 1.0*p.y ) ;
    p.y += 0.1*sin( iGlobalTime + 1.0*p.x ) ;
    
    float a = noise(p*1.5 + sin(0.1*iGlobalTime))*6.2831*p2;
    a -= iGlobalTime + gl_FragCoord.x/iResolution.x;
    return vec2( cos(a), sin(a) );
}

void main( void )
{
    vec2 p = gl_FragCoord.xy / iResolution.xy;
    vec2 uv = -1.0 + 2.0*p*p1;
    uv.x *= iResolution.x / iResolution.y;
        
    float acc = 0.0;
    vec3  col = vec3(0.0);
    for( int i=0; i<32; i++ )
    {
        vec2 dir = map( uv );
        
        float h = float(i)/32.0;
        float w = 4.0*h*(1.0-h);
        
        vec3 ttt = w*texture2DRect( image1, res * uv ).xyz;
        ttt *= mix( vec3(0.6,0.7,0.7), vec3(1.0,0.95,0.9), 0.5 - 0.5*dot( reflect(vec3(dir,0.0), vec3(1.0,0.0,0.0)).xy, vec2(0.707) ) );
        col += w*ttt;
        acc += w;
        
        uv += 0.008*dir;
    }
    col /= acc;
    
    float gg = dot( col, vec3(0.333) );
    vec3 nor = normalize( vec3( dFdx(gg), 0.5, dFdy(gg) ) );
    col += vec3(0.4)*dot( nor, vec3(0.7,0.01,0.7) );

    vec2 di = map( uv );
    col *= 0.65 + 0.35*dot( di, vec2(0.707) );
    col *= 0.20 + 0.80*pow( 4.0*p.x*(1.0-p.x), 0.1 );
    col *= 1.7;

    gl_FragColor = vec4( col, 1.0 );
}

