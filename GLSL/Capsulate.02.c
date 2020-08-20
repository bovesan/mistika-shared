#version 130

#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

// Written by Bengt Ove Sannes (c) 2014
// bove@bengtove.com

uniform sampler2DRect image1;
uniform sampler2DRect image2;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main()
{
    float pass = int(param1.x);
    vec2 res = gl_TexCoord[0].zw;
    float aspect = res.x/res.y;
    int sampleSize = 10, offsetX, offsetY, threadsPerBound = 100;
    float left, right, top, bottom, modulo, limit;
    bool doubleBreak;
    
    vec2 pos = gl_TexCoord[0].xy;
    
    float corex = (param2.x*0.01)*res.x;
    float corey = (param2.y*0.01)*res.y;
    float offsetGlobal = param2.z*0.01;
    float offsetLeft = -param3.x*0.01-offsetGlobal;
    float offsetRight = param3.y*0.01+offsetGlobal;
    float offsetBottom = (param3.z*0.01+offsetGlobal)*aspect;
    float offsetTop = -(param4.x*0.01+offsetGlobal)*aspect;
    float overrideLeft = param4.y*0.01;
    float overrideRight = param4.z*0.01;
    float overrideTop = param5.x*0.01;
    float overrideBottom = param5.y*0.01;
    float tx, ty;
    
    int output = int(param1.y);
    
    vec4 pipe;
    
    if (pass == 0) {
        if((pos.x < 1 * threadsPerBound) && (pos.y <= 1.0)){
            // left
            modulo = mod(pos.x, float(threadsPerBound));
            offsetX = int(mod(modulo, 10.0));
            offsetY = int(floor(modulo * 0.1));
            doubleBreak = false;
            for(int x = offsetX; x <= res.x; x+=sampleSize){
                for(int y = offsetY; y <= res.y; y+=sampleSize){
                    if (texture2DRect(image1, vec2(x, y)).a > 0.0) {
                        left = x;
                        gl_FragColor = vec4(left/res.x);
                        doubleBreak = true;
                    }
                }
            if (doubleBreak) { break; } 
            }
        }
        else if((pos.x < 2 * threadsPerBound) && (pos.y <= 1.0)){
            // right
            modulo = mod(pos.x, float(threadsPerBound));
            offsetX = int(mod(modulo, 10.0));
            offsetY = int(floor(modulo * 0.1));
            doubleBreak = false;
            for(int x = int(res.x - offsetX); x >= 0; x-=sampleSize){
                for(int y = offsetY; y <= res.y; y+=sampleSize){
                    if (texture2DRect(image1, vec2(x, y)).a > 0.0) {
                        right = x;
                        gl_FragColor = vec4(right/res.x);
                        doubleBreak = true;
                    }
                }
            if (doubleBreak) { break; } 
            }
        }
        else if((pos.x < 3 * threadsPerBound) && (pos.y <= 1.0)){
            // bottom
            modulo = mod(pos.x, float(threadsPerBound));
            offsetX = int(mod(modulo, 10.0));
            offsetY = int(floor(modulo * 0.1));
            doubleBreak = false;
            for(int y = offsetY; y <= res.y; y+=sampleSize){
                for(int x = offsetX; x <= res.x; x+=sampleSize){
                    if (texture2DRect(image1, vec2(x, y)).a > 0.0) {
                        bottom = y;
                        gl_FragColor = vec4(bottom/res.y);
                        doubleBreak = true;
                    }
                }
            if (doubleBreak) { break; } 
            }
        }
        else if((pos.x < 4 * threadsPerBound) && (pos.y <= 1.0)){
            // top
            modulo = mod(pos.x, float(threadsPerBound));
            offsetX = int(mod(modulo, 10.0));
            offsetY = int(floor(modulo * 0.1));
            doubleBreak = false;
            for(int y = int(res.y - offsetY); y >= 0; y-=sampleSize){
                for(int x = offsetX; x <= res.x; x+=sampleSize){
                    if (texture2DRect(image1, vec2(x, y)).a > 0.0) {
                        top = y;
                        gl_FragColor = vec4(top/res.y);
                        doubleBreak = true;
                    }
                }
            if (doubleBreak) { break; } 
            }
        }
        else{
            gl_FragColor = texture2DRect(image1, pos.xy);
        }
    }
    else if (pass == 1) {
        if((pos.x < 1.0) && (pos.y <= 1.0)){
            // left
            limit = 1.0;
            for (int x = 0*threadsPerBound; x < threadsPerBound; x++) {
                limit = min(texture2DRect(image1, vec2(x, 0)).a, limit);
            }
            gl_FragColor = vec4(limit);
        }
        else if((pos.x < 2.0) && (pos.y <= 1.0)){
            // right
            limit = 0.0;
            for (int x = 1*threadsPerBound; x < threadsPerBound*2; x++) {
                limit = max(texture2DRect(image1, vec2(x, 0)).a, limit);
            }
            gl_FragColor = vec4(limit);
        }
        else if((pos.x < 3.0) && (pos.y <= 1.0)){
            // bottom
            limit = 1.0;
            for (int x = 2*threadsPerBound; x < threadsPerBound*3; x++) {
                limit = min(texture2DRect(image1, vec2(x, 0)).a, limit);
            }
            gl_FragColor = vec4(limit);
        }
        else if((pos.x < 4.0) && (pos.y <= 1.0)){
            // top
            limit = 0.0;
            for (int x = 3*threadsPerBound; x < threadsPerBound*4; x++) {
                limit = max(texture2DRect(image1, vec2(x, 0)).a, limit);
            }
            gl_FragColor = vec4(limit);
        }
        else if((pos.x < 4 * threadsPerBound) && (pos.y <= 1.0)){
            gl_FragColor = vec4(0.0);
        }
        else{
            gl_FragColor = texture2DRect(image1, pos.xy);
        }
    }
    else if (pass == 2) {
        if (texture2DRect(image2, vec2(1,0)).a == 0) {
            // No opaque pixels found
            gl_FragColor = vec4(0.0);
        }
        else {
        	if (overrideLeft > 0) {
        		left = overrideLeft;
        	} else {
        		left = texture2DRect(image2, vec2(0,0)).a;
        	}
        	if (overrideRight < 1) {
        		right = overrideRight;
        	} else {
        		right = texture2DRect(image2, vec2(1,0)).a;
        	}
        	if (overrideBottom > 0) {
        		bottom = overrideBottom;
        	} else {
        		bottom = texture2DRect(image2, vec2(2,0)).a;
        	}
        	if (overrideTop < 1) {
        		top = overrideTop;
        	} else {
        		top = texture2DRect(image2, vec2(3,0)).a;
        	}
            left = (left+offsetLeft)*res.x;
            right = (right+offsetRight)*res.x;
            bottom = (bottom+offsetBottom)*res.y;
            top = (top+offsetTop)*res.y;
            if (pos.x < left) {
                tx = corex - left + pos.x;
            }
            else if (pos.x > right) {
                tx = corex + right - pos.x;
            }
            else {
                tx = corex;
            }
            if (pos.y < bottom) {
                ty = corey - bottom + pos.y;
            }
            else if (pos.y > top) {
                ty = corey + top - pos.y;
            }
            else {
                ty = corey;
            }
            if (output == 0) {
                if (pos.y < 1) {
                    gl_FragColor = vec4(0.0);
                }
                else {
                    pipe = texture2DRect(image2, pos);
                    gl_FragColor = texture2DRect(image1, vec2(tx, ty))*(1.0-pipe.a)+pipe;
                }
            }
            else if (output == 1) {
                gl_FragColor = texture2DRect(image1, vec2(tx, ty));
            }
        }
    }
}
