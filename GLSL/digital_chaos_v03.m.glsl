uniform vec3 param1;
float adsk_time = float(param1.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;


float hash(vec2 uv)
{
    float r;
    uv = abs(mod(adsk_time*fract((uv+1.1312)*31.),uv+2.));
    uv = floor(uv.x*fract((uv+.721711) ));
    return r = fract(3.34234* (.0452*uv.y + 1.5245*uv.x));
}

void main(void)
{
    vec3 grain = vec3(0.0);
    vec2 uv = (fract(sin(adsk_time)*(gl_FragCoord.xy * res.y)) * 500.) +0.5;
    grain.r = fract(hash(vec2(hash(uv),1.0)));

    gl_FragColor = vec4(grain.rrr * 3.0, 1.0);
}