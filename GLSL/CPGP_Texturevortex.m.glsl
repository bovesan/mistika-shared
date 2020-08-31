//    License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//    
//    started trying random things without a goal in mind and ended up here.
//    there's probably lots of redundant and senseless code. yes, I am ashamed of myself.
//    
//    raymarching and lighting code courtesy of iq.
//    
//    ~bj.2013

uniform sampler2DRect image1;
uniform vec3 param2;
float adsk_time = float(param2.y) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param3;
vec2 paramPos = vec2(param2.z, param3.x) * 0.01;

uniform vec3 param1;
float paramSpeed = float(param1.z) * 0.01;
float paramWaveSize = float(param2.x) * 0.01;

const float PI    = 3.14159;


void main(void)
{
    vec2 iResolution = vec2(adsk_result_w, adsk_result_h);
    vec2 rcpResolution = 1.0 / iResolution.xy;
    vec2 uv = gl_FragCoord.xy * rcpResolution;
    
    // = vec2 ndc    = -1.0 + uv * 2.0;
    // = vec2 mouse  = -1.0 + 2.0 * iMouse.xy * rcpResolution;
    vec4 mouseNDC = -1.0 + vec4(paramPos.xy, uv) * 2.0;
    vec2 diff     = mouseNDC.zw - mouseNDC.xy;
    
    float dist  = length(diff);       // = sqrt(diff.x * diff.x + diff.y * diff.y);
    float angle = PI * dist * paramWaveSize + adsk_time * paramSpeed /100.0;
    
    vec3 sincos;
    sincos.x = sin(angle);
    sincos.y = cos(angle);
    sincos.z = -sincos.x;
    
    vec2 newUV;
    mouseNDC.zw -= mouseNDC.xy;
    newUV.x = dot(mouseNDC.zw, sincos.yz);    // = ndc.x * cos(angle) - ndc.y * sin(angle);
    newUV.y = dot(mouseNDC.zw, sincos.xy);  // = ndc.x * sin(angle) + ndc.y * cos(angle);
    
    vec3 col = texture2DRect( image1, res * newUV.xy ).xyz;
    
    gl_FragColor = vec4(col, 1);
}