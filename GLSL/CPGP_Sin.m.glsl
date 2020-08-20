
uniform vec3 param1;
float adsk_time = float(param1.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float paramSinSpeed = float(param1.x) * 0.01;
float paramSinSPosX = float(param1.y) * 0.01;

//-----------------------------------------------------------------------------
// Main functions
//-----------------------------------------------------------------------------

void main()
{
    vec2 iResolution = vec2(adsk_result_w,adsk_result_h);
    vec2 uPos = ( gl_FragCoord.xy / iResolution.xy );//normalize wrt y axis
    
    uPos.x -= paramSinSPosX;
    
    float vertColor = 0.0;
    for( float i = 0.0; i < 1.0; ++i )
    {
        float t = adsk_time * paramSinSpeed / 100.0 * (i + 0.9);
        
        uPos.x += sin( uPos.y + t ) * 0.3;
        
        float fTemp = abs(1.0 / uPos.x / 100.0);
        vertColor += fTemp;
    }
    
    vec4 color = vec4( vertColor, vertColor, vertColor * 2.5, 1.0 );
    gl_FragColor = color;

}