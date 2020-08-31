#version 120

uniform sampler2DRect image1;
uniform vec3 param1;
float expo_o = float(param1.y) * 0.01;
uniform vec3 param2;
float expo_r = float(param2.y) * 0.01;
float expo_g = float(param2.z) * 0.01;
uniform vec3 param3;
float expo_b = float(param3.x) * 0.01;
float contrast_r = float(param3.y) * 0.01;
float contrast_g = float(param3.z) * 0.01;
uniform vec3 param4;
float contrast_b = float(param4.x) * 0.01;
float pivot_r = float(param4.y) * 0.01;
float pivot_g = float(param4.z) * 0.01;
uniform vec3 param5;
float pivot_b = float(param5.x) * 0.01;
float contrast_all = float(param1.z) * 0.01;
float pivot_all = float(param2.x) * 0.01;


int encoding = int(param1.x);
    
const float sqrtoftwo = 1.41421356237;

float ga = 17.5;
float br = 1.74;

// contrast by  Miles
vec3 adjust_contrast(vec3 col, vec4 con, vec4 piv)
{
    vec3 c = con.rgb * vec3(con.a);
    vec3 pi = piv.rgb * vec3(piv.a);
    //vec3 p = (vec3(1.0) - c) / vec3(2.0);
    
    col = (1.0 - c.rgb) * pi + c.rgb * col;

    return col;
}

// rec709 conversion routine by Miles
vec3 from_rec709(vec3 col)
{
    if (col.r < .081) {
        col.r /= 4.5;
    } else {
        col.r = pow((col.r +.099)/ 1.099, 1 / .45);
    }
    if (col.g < .081) {
        col.g /= 4.5;
    } else {
        col.g = pow((col.g +.099)/ 1.099, 1 / .45);
    }
    if (col.b < .081) {
        col.b /= 4.5;
    } else {
        col.b = pow((col.b +.099)/ 1.099, 1 / .45);
    }
    return col;
}

vec3 to_rec709(vec3 col)
{
    if (col.r < .018) {
        col.r *= 4.5;
    } else if (col.r >= 0.0) {
        col.r = (1.099 * pow(col.r, .45)) - .099;
    }
    if (col.g < .018) {
        col.g *= 4.5;
    } else if (col.g >= 0.0) {
        col.g = (1.099 * pow(col.g, .45)) - .099;
    }
    if (col.b < .018) {
        col.b *= 4.5;
    } else if (col.b >= 0.0) {
        col.b = (1.099 * pow(col.b, .45)) - .099;
    }
    return col;
}

vec3 from_log(vec3 col)
{
    if (col.r >= 0.0) {
        col.r = pow((col.r + br), ga);
    }
    if (col.g >= 0.0) {
        col.g = pow((col.g + br), ga);
    }
    if (col.b >= 0.0) {
        col.b = pow((col.b + br), ga);
    }
    return col;
}

vec3 to_log(vec3 col)
{
    if (col.r >= 0.0) {
        col.r = (pow(col.r, 1.0 / ga)) - br;
    }
    if (col.g >= 0.0) {
        col.g = (pow(col.g, 1.0 / ga)) - br;
    }
    if (col.b >= 0.0) {
        col.b = (pow(col.b, 1.0 / ga)) - br;
    }
    return col;
}

void main (void) 
{ 
    vec2 uv = gl_TexCoord[0].xy;    
    vec3 image1 = texture2DRect(image1, res * uv).rgb;
    vec3 col = image1;
        
    // Scene linear exposure
    if ( encoding == 0)
        col = col;
    
    // video  / Rec 709 exposure
    else if ( encoding == 1)
    {
        col = from_rec709(col);
    }

    // Logarithmic exposure
    else if ( encoding == 2)
    {
        col = from_log(col);
    }
    
    // contrast stuff by Miles
    vec3 contrast = vec3(contrast_r, contrast_g, contrast_b);
    vec3 c_pivot = vec3(pivot_r, pivot_g, pivot_b);
    col = adjust_contrast(col, vec4(contrast, contrast_all), vec4(c_pivot, pivot_all));
    
    // overall exposure adjustemnt
    col = col * pow(2.0, expo_o);

    // single rgb exposure adjustment
    float r_col = col.r * pow(2.0, expo_r);
    float g_col = col.g * pow(2.0, expo_g);
    float b_col = col.b * pow(2.0, expo_b);
    
    col = vec3(r_col, g_col, b_col);
    
    // Scene linear exposure
    if ( encoding == 0)
        col = col;
    
    // video  / Rec 709 exposure
    else if ( encoding == 1)
    {
        col = to_rec709(col);
    }
    
    // Logarithmic exposure
    else if ( encoding == 2)
    {
        col = to_log(col);
    }
    
    gl_FragColor = vec4(col, 1.0);
} 
