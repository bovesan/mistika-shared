// RadialBlur - Shader
 
uniform sampler2DRect image1;
uniform vec3 param2;
uniform vec3 param3;
vec2 radial_size = vec2(param2.z, param3.x) * 1.0;
 
uniform vec3 param1;
float radial_blur = float(param1.x) * 0.01;
float radial_bright = float(param2.x) * 0.01;
 
vec2 radial_origin = vec2(param3.y, param3.z) * 0.01;
int pBlursteps = int(param2.y);

float steps = float(pBlursteps);

void main(void)
{
  vec2 TexCoord = vec2(gl_TexCoord[0]);
 
  vec4 SumColor = vec4(0.0, 0.0, 0.0, 0.0);
  TexCoord += radial_size * 0.5 - radial_origin;
 
  for (int i = 0; i < pBlursteps; i++) 
  {
    float scale = 1.0 - radial_blur * (float(i) / steps);
    SumColor += texture2DRect(image1, res * TexCoord * scale + radial_origin);
  }
 
  gl_FragColor = SumColor / steps * radial_bright;
}