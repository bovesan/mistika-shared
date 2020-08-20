uniform vec3 param1;
float Speed = float(param1.z) * 0.01;
uniform vec3 param2;
float Offset = float(param2.x) * 0.01;
float scale = float(param1.x) * 0.1;
float scale_x = float(param2.y) * 0.01;
float scale_y = float(param2.z) * 0.01;
float seed = float(param1.y) * 0.01;
uniform vec3 param4;
float gain = float(param4.z) * 0.01;
uniform vec3 param3;
float aspect_x = float(param3.x) * 0.01;
float aspect_y = float(param3.y) * 0.01;


uniform vec3 param5;
float adsk_time = float(param5.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param6;
vec3 tint = vec3(param5.y, param5.z, param6.x) * 0.01;

float time = adsk_time * .04234 * Speed + Offset + 200.0;


float rand(vec2 n)
{
  return fract(sin(dot(n.xy, vec2(0.000435134551 * scale_x, .0043451929 * scale_y)))* time);
}

void main( void ) {

    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    float color = rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale) / scale)
        +rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*2.0) / scale*2.0 )
        +rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*4.0) / scale*4.0 )
        +rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*8.0) / scale*8.0 )
        +rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*16.0) / scale*16.0 );
    color = color / 5.0 * gain;

    gl_FragColor = vec4( vec3( color*tint.r, color*tint.g, color*tint.b), 1.0 );

}