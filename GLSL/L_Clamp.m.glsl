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
uniform sampler2DRect image1;
uniform vec3 param3;
vec3 low = vec3(param3.x, param3.y, param3.z) * 0.01;
uniform vec3 param4;
vec3 high = vec3(param4.x, param4.y, param4.z) * 0.01;

void main(void)
{
  vec2 uv = gl_TexCoord[0].xy;
  vec3 color = texture2DRect(image1, res * uv).rgb;

gl_FragColor.rgb = clamp(color.rgb, low, high);
}


