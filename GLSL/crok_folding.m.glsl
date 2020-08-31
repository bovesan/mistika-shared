uniform vec3 param5;
float adsk_time = float(param5.x) * 1.0;
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
float pRight = float(param5.y) * 1.0;
float pLeft = float(param5.z) * 1.0;
uniform vec3 param2;
float Offset = float(param2.y) * 0.01;
float Speed = float(param2.x) * 0.01;
float Zoom = float(param2.z) * 0.01;
uniform vec3 param1;
float Noise = float(param1.x) * 0.01;
float Steps = float(param1.z) * 1.0;
uniform vec3 param3;
float Aspect = float(param3.x) * 0.01;
uniform vec3 param6;
vec3 color_pot = vec3(param6.x, param6.y, param6.z) * 0.01;
uniform vec3 param4;
bool useduration = bool(param4.y);
int duration = int(param4.z);
float Detail = float(param1.y) * 0.01;



void main( void ) {
    float time;
    if(useduration) {
        // The only time-dependent function below is sin(time), which
        // repeats every 2*pi
        time = 2.0 * 3.14159265358979 * (adsk_time/float(duration));
        time += Offset/float(duration);
    } else {
        time = adsk_time*.01*Speed+Offset;
    }
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    vec2 zoom_center=(2.0*(position-.5)) * Zoom;
    zoom_center.x *= resolution.x / resolution.y*Aspect;
    float color = 0.0;
    for(float i = 0.0; i < Steps; i++)
    {
        zoom_center.x += sin(Noise * sin(length(zoom_center.y + 5.)));
        color += sin(0.6 * Detail * sin(length(position) + zoom_center.x + i * zoom_center.y + sin(i + zoom_center.x + time )) + sin(Noise * cos(sin(zoom_center.y + zoom_center.x) * 0.5)));
        color = sin(color*1.5);
        zoom_center.y += color*1.5;
        zoom_center.x -= sin(zoom_center.y - cos(dot(zoom_center, vec2(color, sin(color*2.)))));
    }
    gl_FragColor = vec4(abs(color) * color_pot, 1.0);
    
}