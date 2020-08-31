vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param4;
float adsk_time = float(param4.x) * 1.0;
uniform vec3 param1;
float density = float(param1.x) * 0.01;
uniform vec3 param2;
float speed = float(param2.x) * 0.01;
float offset = float(param2.y) * 0.01;
int itterations = int(param1.z);
uniform vec3 param3;
float gain = float(param3.z) * 0.01;
 float = (param4.y);
 edgeSharpness = (param1.y);
uniform vec3 param5;
vec3 color = vec3(param4.z, param5.x, param5.y) * 0.01;

float time = adsk_time*.002 * speed + offset;
const float Pi = 3.14159;

void main()
{
  vec2 pos = gl_FragCoord.xy / resolution.xy;
  float angled = (pos.x) * density;    
  for (int i = 1; i < itterations; i++)
  {
      angled += (edgeSharpness * sin( float(i)*angled) / float(i) ) + time;
  }
  float base = gain * sin(3.0*angled);
  gl_FragColor=vec4(color.r * base, color.g * base, color.b * base, 1.0);
}
