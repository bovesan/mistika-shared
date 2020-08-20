// water turbulence effect by joltz0r 2013-07-04, improved 2013-07-07

uniform vec3 param4;
float adsk_time = float(param4.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param1;
float Speed = float(param1.z) * 0.01;
uniform vec3 param2;
float Offset = float(param2.x) * 0.01;
float Zoom = float(param1.y) * 0.01;
int Detail = int(param1.x);
vec2 Position = vec2(param4.y, param4.z) * 0.01;
uniform vec3 param5;
vec3 Colour = vec3(param5.x, param5.y, param5.z) * 0.01;

float time = adsk_time*.05 * Speed + Offset+50. ;

void main( void ) {
    vec2 sp = gl_FragCoord.xy / resolution;
    vec2 center_uv=(2.0*(sp-.5));
    vec2 p = center_uv * Zoom - Position;
    vec2 i = p;
    float c = 1.0;
    float inten = .05;
    for (int n = 0; n < Detail; n++) 
    {
        float t = time/5. * (1.0 - (3.0 / float(n+1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
        c += 1.0/length(vec2(p.x / (2.*sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
    }
    c /= float(Detail);
    c = 1.5-sqrt(pow(c,3.*0.5));
    gl_FragColor = vec4(vec3(c*c*c*c*Colour.r,c*c*c*c*Colour.g,c*c*c*c*Colour.b), 1.0);

}