#version 120
// uncompositing
// with huge help from Erwan Leroy

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float gamma = float(param1.y) * 0.01;
uniform vec3 param2;
float gain = float(param2.x) * 0.001;
int i_colorspace = int(param1.z);
int modus = int(param1.x);

vec4 rem_gamma( vec4 c )
{
    return pow( c, vec4(gamma));
}

vec4 srgb2lin(vec4 col)
{
    if (col.r >= 0.0) {
         col.r = pow((col.r +.055)/ 1.055, 2.4);
    }
    if (col.g >= 0.0) {
         col.g = pow((col.g +.055)/ 1.055, 2.4);
    }
    if (col.b >= 0.0) {
         col.b = pow((col.b +.055)/ 1.055, 2.4);
    }
    return col;
}

vec4 do_colorspace(vec4 image1)
{
    if (i_colorspace == 0) {
        //linear
        image1 = image1;
        }
    else if (i_colorspace == 1) {
        image1 = srgb2lin(image1);
    }
    else {
      image1 = rem_gamma(image1);
    }
    return image1;
}

void main()
{
    vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );

    vec4 f = texture2DRect( image1, res * uv );
    vec4 b = texture2DRect( image2, res * uv);
        vec4 m = texture2DRect( image3, res * uv);
        vec4 c = vec4(0.0);

        if ( modus == 0 )
        {
            // adjust colourspace
            f = do_colorspace(f);
      b = do_colorspace(b);
      if (i_colorspace != 1)
        m = do_colorspace(m);

            // Undo a blend operation:
            c = f-b*(1.0-m);
        }
        else
        {
            // remove logo from BG
            //Background = Result / (1 – AlphaOfA) - Foreground

            c = (b - f) / (1.0 - m * gain);
        }
        gl_FragColor = c;
}
