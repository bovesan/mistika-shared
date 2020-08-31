uniform vec3 param1;
float COLOR_LEVELS = float(param1.y) * 0.05;
float EDGE_THRESHOLD = float(param1.x) * 0.005;
int FILTER_SIZE = int(param1.z);
uniform vec3 param2;
int EDGE_FILTER_SIZE = int(param2.x);

uniform sampler2DRect image1;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
vec2 iResolution = vec2(adsk_result_w, adsk_result_h);

// Attempt at cel shading without knowing the light position nor normals
// created by Glass in 9/3/2013Attempt


// #define FILTER_SIZE 3
// #define COLOR_LEVELS 7.0
// #define EDGE_FILTER_SIZE 3
// #define EDGE_THRESHOLD 0.05

vec4 edgeFilter(in int px, in int py)
{
    vec4 color = vec4(0.0);
    
    for (int y = -EDGE_FILTER_SIZE; y <= EDGE_FILTER_SIZE; ++y)
    {
        for (int x = -EDGE_FILTER_SIZE; x <= EDGE_FILTER_SIZE; ++x)
        {
            color += texture2DRect(image1, res * (gl_FragCoord.xy + vec2(px + x, py + y)) / iResolution.xy);
        }
    }

    color /= float((2 * EDGE_FILTER_SIZE + 1) * (2 * EDGE_FILTER_SIZE + 1));
    
    return color;
}

void main(void)
{    
    // Shade
    vec4 color = vec4(0.0);
    
    for (int y = -FILTER_SIZE; y <= FILTER_SIZE; ++y)
    {
        for (int x = -FILTER_SIZE; x <= FILTER_SIZE; ++x)
        {
            color += texture2DRect(image1, res * (gl_FragCoord.xy + vec2(x, y)) / iResolution.xy);
        }
    }

    color /= float((2 * FILTER_SIZE + 1) * (2 * FILTER_SIZE + 1));
    
    for (int c = 0; c < 3; ++c)
    {
        color[c] = floor(COLOR_LEVELS * color[c]) / COLOR_LEVELS;
    }
    
    // Highlight edges
    vec4 sum = abs(edgeFilter(0, 1) - edgeFilter(0, -1));
    sum += abs(edgeFilter(1, 0) - edgeFilter(-1, 0));
    sum /= 2.0;    

    if (length(sum) > EDGE_THRESHOLD)
    {
        color.rgb = vec3(0.0);    
    }
    
    gl_FragColor = color;
}
