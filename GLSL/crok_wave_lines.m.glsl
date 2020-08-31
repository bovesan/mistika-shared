// based on http://glsl.heroku.com/e#13475.0

uniform vec3 param6;
float adsk_time = float(param6.z) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float Lines = float(param1.x) * 1.0;
uniform vec3 param2;
float Brightness = float(param2.x) * 0.01;
float Speed = float(param1.y) * 0.01;
float Offset = float(param1.z) * 0.01;
float Glow = float(param2.y) * 0.01;

uniform vec3 param7;
vec3 Colour1 = vec3(param7.x, param7.y, param7.z) * 0.01;
uniform vec3 param8;
vec3 Colour2 = vec3(param8.x, param8.y, param8.z) * 0.01;
uniform vec3 param9;
vec3 Colour3 = vec3(param9.x, param9.y, param9.z) * 0.01;
uniform vec3 param10;
vec3 Colour4 = vec3(param10.x, param10.y, param10.z) * 0.01;

float time = adsk_time * 0.01 * Speed + Offset;

void main() {
    float x, y, xpos, ypos;
        float t = time * 10.0;
    vec3 c = vec3(0.0);
    
    xpos = (gl_FragCoord.x / resolution.x);
    ypos = (gl_FragCoord.y / resolution.y);
    
    x = xpos;
    for (float i = 0.0; i < Lines; i += 1.0) {
        for(float j = 0.0; j < 2.0; j += 1.0){
            y = ypos
            + (0.30 * sin(x * 2.000 +( i * 1.5 + j) * 0.2 + t * 0.050)
               + 0.300 * cos(x * 6.350 + (i  + j) * 0.2 + t * 0.050 * j)
               + 0.024 * sin(x * 12.35 + ( i + j * 4.0 ) * 0.8 + t * 0.034 * (8.0 *  j))
               + 0.5);
            
            c += vec3(1.0 - pow(clamp(abs(1.0 - y) * 1. / Glow * 10., 0.0,1.0), 0.25));
        }
    }
    
    c *= mix(
             mix(Colour1, Colour2, xpos)
             , mix(Colour3, Colour4, xpos)
             ,(sin(t * 0.02) + 1.0) * 0.45
             ) * Brightness * .1;
    
    gl_FragColor = vec4(c, 1.0);
}
