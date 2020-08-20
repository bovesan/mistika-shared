#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2011-2012
// bove@bengtove.com

uniform sampler2DRect image;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    int distance = 0;
    vec4 op = (texture2DRect(image, gl_TexCoord[0].xy));
    vec4 p;
    if (op.a >= 1) {
        p = op * (1-(param1.r * 0.01));
    } else {
        p = vec4(op.r*op.a, op.g*op.a, op.b*op.a, op.a);
        vec4 p2;
        vec4 p3;
        vec2 p2pos;
        float m;
        while (p.a < 1) {
            p2pos = vec2(gl_TexCoord[0].x, gl_TexCoord[0].y + distance);
            if (p2pos[0] > vec2(textureSize(image))[0] || p2pos[1] > vec2(textureSize(image))[1]) {
                break;
            }
            p2 = texture2DRect(image, p2pos);
            if (p2.a > 0) {
                m = min(p2.a, 1 - p.a);
                p3 = (texture2DRect(image, vec2(gl_TexCoord[0].x, gl_TexCoord[0].y + distance*2)));
                p += vec4(p3.r*m, p3.g*m, p3.b*m, m);
            }
            distance ++;
        }
        float mix = 1 - param1.g*0.01;
        // param1.b is falloff distance
        if (param1.b > 0){
            mix *= (1 - min(distance / param1.b, 1));
        }
        p *= mix;
        p += (op*(1-mix));
        p.a = op.a;
    }
    gl_FragColor = p;
}
