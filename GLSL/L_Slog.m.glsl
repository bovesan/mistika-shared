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
//                                                                 Logik�
//

#version 120
uniform sampler2DRect image1;

void main(void)
{
  vec2 uv = gl_TexCoord[0].xy;
  vec3 color = texture2DRect(image1, res * uv).rgb;
  float red = pow(10.0, ((color.r - 0.616596 - 0.03) / 0.432699)) - 0.037584;
  float green = pow(10.0, ((color.g - 0.616596 - 0.03) / 0.432699)) - 0.037584;
  float blue = pow(10.0, ((color.b - 0.616596 - 0.03) / 0.432699)) - 0.037584;

gl_FragColor.rgb = vec3(red, green, blue);
}
