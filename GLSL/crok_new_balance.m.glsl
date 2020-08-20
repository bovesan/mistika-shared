vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform sampler2DRect image1;
uniform vec3 param1;
float level = float(param1.x) * 1.0;
int colourspace = int(param1.z);
uniform vec3 param2;
int Computing = int(param2.y);
float Amount = float(param1.y) * 0.01;


#extension GL_ARB_shader_texture_lod : enable

void main(void)
{
vec2 st = gl_FragCoord.xy / res;

vec4 tc = texture2DRect(image1, res * st);

vec4 front = texture2DRect(image1, res * st);
vec4 front_a = texture2DLod(image1, st, level - 0.5);

   if( colourspace == 0)  // Rec 709 input is selected
    {  
      if( Computing == 0)
      {
          front /= 2.0 * front_a;
      }
       if( Computing == 1)
           front-=front_a+0.244459-0.918031;

       if( Computing == 2)
           front-=front_a-(front_a[0]+front_a[1]+front_a[2])/3.0;
       
   }
   
   if( colourspace == 1)  // Linear input is selected
       front /= 2.0 * front_a;


       front = mix(tc, front, Amount);
    
gl_FragColor = front;

}
