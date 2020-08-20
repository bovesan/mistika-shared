// bloom shader
// based on http://myheroics.wordpress.com/2008/09/04/glsl-bloom-shader/

uniform sampler2DRect image1;
uniform vec3 param1;
float pSize = float(param1.y) * 0.01;
float p1 = float(param1.x) * 0.01;
float p2 = float(param1.z) * 0.01;

void main()
{
   vec4 sum = vec4(0);
   vec2 texcoord = vec2(gl_TexCoord[0]);
   int j;
   int i;

   for( i= -4 ;i < 4; i++)
   {
        for (j = -3; j < 3; j++)
        {
            sum += texture2DRect(image1, res * texcoord + vec2(j, i)*p1*0.01) * p2;
        }
   }
        {
            gl_FragColor = sum*sum*0.0075*pSize + texture2DRect(image1, res * texcoord);
        }
}
