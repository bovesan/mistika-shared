//
// K_RgbcmyMatte v1.2
// Shader written by:   Kyle Obley (kyle.obley@gmail.com)
//

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
int selection = int(param1.x);

void main()
{    
    vec2 st = gl_FragCoord.xy / vec2 (adsk_result_w, adsk_result_h);
    vec3 image1 = texture2DRect(image1, res * st).rgb;
    
    // Red
    if ( selection == 1 )
    {
        gl_FragColor = vec4( image1.r * (1.0 - image1.g) * (1.0 - image1.b) );
    }
    
    // Green
    else if ( selection == 2 )
    {
        gl_FragColor = vec4( (1.0 - image1.r) * image1.g * (1.0 - image1.b) );
    }
    
    // Blue
    else if ( selection == 3 )
    {
        gl_FragColor = vec4( (1.0 - image1.r) * (1.0 - image1.g) * image1.b );
    }
    
    // Cyan
    else if ( selection == 4 )
    {
        gl_FragColor = vec4( (1.0 - image1.r) * image1.g * image1.b );
    }
    
    // Yellow
    else if ( selection == 5 )
    {
        gl_FragColor = vec4(  image1.r * image1.g  * (1.0 - image1.b) );
    }
    
    // Magenta
    else if ( selection == 6 )
    {
        gl_FragColor = vec4( image1.b * (1.0 - image1.r ) * image1.g );
    }
    
    // White
    else if ( selection == 7 )
    {
        gl_FragColor = vec4( image1.r * image1.g * image1.b );
    }
}