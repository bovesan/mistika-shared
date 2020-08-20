//
//
//                                   MMM                                          
//                                 .MMM.                                          
//                                MMM .                                           
//                               MM.            MMMM                              
//                              MM.           MMMM                                
//                            MM.          MMM                                    
//                           MMMMMMMMMMMMMMM                                      
//                        8MMMMN.  M ..  .MMMMMMM .            .D                 
//                      MMMMMM.    M      MM.   MMM ..     .MMMMMM                
//                    MMM   MM.    MM.    M8     MOMMM. MMMMM   MM                
//                  NMM.    MM.    MM     MM     M.  MMMI       MM                
//                 MM,. .M, MMMMMMMMMMMMMMMMMMMMMMMMMMMMM.      MM.               
//                NMMM.  .  MMM    MM.    MM$   M..=MM. 7MMM.   M,                
//                 .MMMM.   MM     MN     ,M.   M. M.     MMMMMMM~                
//                    .MMM..MM.    MM.    MM.  8MMM.         ..O..                
//                      .MMMMM     M.     MM   MMM                                
//                         MMMMM. .M      MMMM7  MM.                              
//                            MMMMMMMMMMMMM.      MMM                             
//                              MM      MMN.       MMM                            
//                              MM        MM .                                    
//                               M7        MM                                     
//                                                                                
//                                                                 Logikô
//


#version 120

uniform sampler2DRect image1;

uniform vec3 param1;
float valR = float(param1.x) * 0.01;
float valG = float(param1.y) * 0.01;
float valB = float(param1.z) * 0.01;

uniform vec3 param2;
vec3 val = vec3(param2.x, param2.y, param2.z) * 1.0;

void main(void)
{
  vec2 uv = gl_TexCoord[0].xy;
  vec3 color = texture2DRect(image1, res * uv).rgb;

  float red = color.r * pow (2.0, valR);
  float green = color.g * pow (2.0, valG);
  float blue = color.b * pow (2.0, valB);
    
gl_FragColor.rgb = vec3(red, green, blue);
}
