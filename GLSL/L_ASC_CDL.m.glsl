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
//                                                                 Logik™
//

#version 120
uniform sampler2DRect undefined;
uniform vec3 param4;
vec3 slope = vec3(param4.x, param4.y, param4.z) * 0.01;
uniform vec3 param5;
vec3 offset = vec3(param5.x, param5.y, param5.z) * 0.01;
uniform vec3 param6;
vec3 power = vec3(param6.x, param6.y, param6.z) * 0.01;

void main(void)
{
  vec2 uv = gl_TexCoord[0].xy;
  vec3 color = texture2DRect(sceneBuffer, res * uv).rgb;
  gl_FragColor.rgb = pow(((color * vec3(slope)) + vec3(offset)), vec3(power));
}
