vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param5;
float adsk_time = float(param5.y) * 1.0;
uniform vec3 param3;
float speed = float(param3.z) * 0.01;
uniform vec3 param4;
float offset = float(param4.x) * 0.01;
uniform vec3 param1;
float detail = float(param1.x) * 0.01;
uniform vec3 param2;
float noise_x = float(param2.y) * 0.01;
float noise_y = float(param2.z) * 0.01;
float fractal_x = float(param1.z) * 0.01;
float fractal_y = float(param2.x) * 0.01;
float random_x = float(param3.x) * 0.01;
float random_y = float(param3.y) * 0.01;
int itterations = int(param1.y);
uniform vec3 param6;
vec3 color = vec3(param5.z, param6.x, param6.y) * 0.01;


float time = adsk_time*.025 * speed + offset;
float getGas(vec2 p){
    return (cos(p.y * detail + time)+1.0)*0.5+(sin(time))*0.0+0.1;
}

void main( void ) {

    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    
    vec2 p=position;
    for(int i=1;i<itterations;i++){
        vec2 newp=p;
        
//        newp.x+=(0.4/(float(i)))*(sin(p.y*(10.0+time*0.0001))*0.2*sin(p.x*30.0)*0.8);
//        newp.y+=(0.4/(float(i)))*(cos(p.x*(20.0+time*0.0001))*0.2*sin(p.x*5.0)+time*0.1);

        newp.x+=(noise_x / (float(i)))*(sin(p.y*(fractal_x + time * 0.0001))*0.2*sin(p.x * random_x)*0.8);
        newp.y+=(noise_y / (float(i)))*(cos(p.x*(fractal_y + time * 0.0001))*0.2*sin(p.x * random_y)+time*0.1);
        p=newp;
    }

    vec3 clr=vec3(color.r * .2 ,color.g *.2 , color.b * .2);
    clr/=getGas(p);

    gl_FragColor = vec4( clr, 1.0 );

}