//*****************************************************************************/
// 
// Filename: PageCurl_3vis.glsl
// Author: Eric Pouliot
// Based on code from http://labs.calyptus.eu/pagecurl/  and  rectalogic.github.io/webvfx/examples_2transition-shader-pagecurl_8html-example.html
// Copyright (c) 2013 3vis, Inc.
//
//*****************************************************************************/

uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform sampler2DRect image3;
uniform vec3 param6;
vec4 iDate = vec4(param6.x);
vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;

uniform vec3 param2;
float roll_angle = float(param2.y) * 0.01;
uniform vec3 param1;
float back_trans = float(param1.y) * 0.01;
float shadow_top = float(param2.x) * 0.01;
float shadow_bottom = float(param1.z) * 0.01;
float time = float(param1.x) * 0.01;

float r_offset_1 = float(param2.z) * 0.01;
uniform vec3 param3;
float r_offset_2 = float(param3.x) * 0.01;
float r_offset_3 = float(param3.y) * 0.01;
float r_offset_4 = float(param3.z) * 0.01;
uniform vec3 param4;
float r_offset_5 = float(param4.x) * 0.01;
float rr_offset_1 = float(param4.y) * 0.01;
float rr_offset_2 = float(param4.z) * 0.01;
uniform vec3 param5;
float rr_offset_3 = float(param5.x) * 0.01;
float rr_offset_4 = float(param5.y) * 0.01;
float rr_offset_5 = float(param5.z) * 0.01;

const float MIN_AMOUNT = -0.25;
const float MAX_AMOUNT = 1.3;

float amount = time * (MAX_AMOUNT - MIN_AMOUNT) + MIN_AMOUNT;

const float PI = 3.141592653589793;

const float scale = 512.0;
const float sharpness = 3.0;

float cylinderCenter = amount;
// 360 degrees * amount
float cylinderAngle = 2.0 * PI * amount;

const float cylinderRadius = 1.0 / PI / 2.0;

vec3 hitPoint(float hitAngle, float yc, vec3 point, mat3 rrotation) {
    float hitPoint = hitAngle / (2.0 * PI);
    point.y = hitPoint;
    return rrotation * point;
}


vec4 antiAlias(vec4 color1, vec4 color2, float distance) {
    distance *= scale;
    if (distance < 0.0) return color2;
    if (distance > 2.0) return color1;
    float dd = pow(1.0 - distance / 2.0, sharpness);
    return ((color2 - color1) * dd) + color1;
}

float distanceToEdge(vec3 point) {
    float dx = abs(point.x > 0.5 ? 1.0 - point.x : point.x);
    float dy = abs(point.y > 0.5 ? 1.0 - point.y : point.y);
    if (point.x < 0.0) dx = -point.x;
    if (point.x > 1.0) dx = point.x - 1.0;
    if (point.y < 0.0) dy = -point.y;
    if (point.y > 1.0) dy = point.y - 1.0;
    if ((point.x < 0.0 || point.x > 1.0) && (point.y < 0.0 || point.y > 1.0)) return sqrt(dx * dx + dy * dy);
    return min(dx, dy);
}

vec4 seeThrough(float yc, vec2 p, mat3 rotation, mat3 rrotation) {

    vec2 texCoord = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);
    
    float hitAngle = PI - (acos(yc / cylinderRadius) - cylinderAngle);
    vec3 point = hitPoint(hitAngle, yc, rotation * vec3(p, 1.0), rrotation);

    if (yc <= 0.0 && (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0)) {
        return texture2DRect(image2, res * texCoord);
    }

    if (yc > 0.0) return texture2DRect(image1, res * p);

    vec4 color = texture2DRect(image1, res * point.xy);
    vec4 tcolor = vec4(0.0);

    return antiAlias(color, tcolor, distanceToEdge(point));
}

vec4 seeThroughWithShadow(float yc, vec2 p, vec3 point, mat3 rotation, mat3 rrotation) {
    float shadow = distanceToEdge(point) * shadow_top;
    shadow = (1.0 - shadow) / 3.0;
    if (shadow < 0.0) shadow = 0.0;
    else shadow *= amount;

    vec4 shadowColor = seeThrough(yc, p, rotation, rrotation);
    shadowColor.r -= shadow;
    shadowColor.g -= shadow;
    shadowColor.b -= shadow;
    return shadowColor;
}

vec4 backside(float yc, vec3 point) {
    vec4 color = texture2DRect(image3, res * point.xy);
    float gray = (color.r + color.b + color.g) / back_trans;
    gray += (8.0 / 10.0) * (pow(1.0 - abs(yc / cylinderRadius), 2.0 / 10.0) / 2.0 + (5.0 / 10.0));
    color.rgb = vec3(gray);
    return color;
}

vec4 behindSurface(float yc, vec3 point, mat3 rrotation) {

    vec2 texCoord = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);

    float shado = (1.0 - ((-cylinderRadius - yc) / amount * 7.0)) / 6.0;
    shado *= 1.0 - abs(point.x - 0.5);

    yc = (-cylinderRadius - cylinderRadius - yc);

    float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;
    point = hitPoint(hitAngle, yc, point, rrotation);

    if (yc < 0.0 && point.x >= 0.0 && point.y >= 0.0 && point.x <= 1.0 && point.y <= 1.0 && (hitAngle < PI || amount > 0.5)){
        shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / (71.0 / 100.0));
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= shadow_bottom;
    } else
        shado = 0.0;

    return vec4(texture2DRect(image2, texCoord).rgb - shado, res * 1.0);
}

void main(void) {

    vec2 texCoord = gl_FragCoord.xy / vec2(adsk_result_w, adsk_result_h);

    float angle = roll_angle * PI / 180.0;

    float c = cos(-angle);
    float s = sin(-angle);

    mat3 rotation = mat3(
        c, s, r_offset_1,
        -s, c, r_offset_2,
        r_offset_3, r_offset_4, r_offset_5
    );

    c = cos(angle);
    s = sin(angle);

    mat3 rrotation = mat3(
        c, s, rr_offset_1,
        -s, c, rr_offset_2,
        rr_offset_3, rr_offset_4, rr_offset_5
    );

    vec3 point = rotation * vec3(texCoord, 1.0);

    float yc = point.y - cylinderCenter;

    if (yc < -cylinderRadius) {
        // Behind surface
        gl_FragColor = behindSurface(yc, point, rrotation);
        return;
    }

    if (yc > cylinderRadius) {
        // Flat surface
        gl_FragColor = texture2DRect(image1, res * texCoord);
        return;
    }

    float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;

    float hitAngleMod = mod(hitAngle, 2.0 * PI);
    if ((hitAngleMod > PI && amount < 0.5) || (hitAngleMod > PI/2.0 && amount < 0.0)) {
        gl_FragColor = seeThrough(yc, texCoord, rotation, rrotation);
        return;
    }

    point = hitPoint(hitAngle, yc, point, rrotation);

    if (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0) {
        gl_FragColor = seeThroughWithShadow(yc, texCoord, point, rotation, rrotation);
        return;
    }

    vec4 color = backside(yc, point);

    vec4 otherColor;
    if (yc < 0.0) {
        float shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / 0.71);
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= 0.5;
        otherColor = vec4(0.0, 0.0, 0.0, shado);
    } else {
        otherColor = texture2DRect(image1, res * texCoord);
    }

    color = antiAlias(color, otherColor, cylinderRadius - abs(yc));

    vec4 cl = seeThroughWithShadow(yc, texCoord, point, rotation, rrotation);
    float dist = distanceToEdge(point);

    gl_FragColor = antiAlias(color, cl, dist);
}