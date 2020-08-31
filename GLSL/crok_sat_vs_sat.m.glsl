uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float sat_amount = float(param1.y) * 0.01;


// Forward declaration of API function. This is necessary to use in Matchbox otherwise it won't compiled. Please see MatchboxAPI for more info.
vec3  adsk_rgb2hsv( vec3 rgb );
vec3  adsk_hsv2rgb( vec3 hsv );
float adsk_getLuminance ( vec3 rgb );
float adskEvalDynCurves( int curve, float x );

// Here is the int used for the single Luma Curve widget
int saturationCurve = int(param1.x);

void main()
{
   vec2 uv = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
   vec3 source = texture2DRect(image1, res * uv).rgb;
   
   // I'm using the API function to extract the hue
   float hue = adsk_rgb2hsv(source).r;
   
   // I'm using the API function to extract the saturation
   float sat = adsk_rgb2hsv(source).g;
   
   // Extract Luminance from source using API function
   //float lum = adsk_getLuminance(source);
   float lum = adsk_rgb2hsv(source).b;
   
   // Here I'm evluating the single Saturation curve widget
   float new_sat = adskEvalDynCurves(saturationCurve, sat) * sat_amount;
   
   vec3 col = adsk_hsv2rgb( vec3(hue, new_sat, lum) );
  
   gl_FragColor = vec4(col,1.0);
}

