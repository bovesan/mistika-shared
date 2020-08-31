/**
 * Fractal Lab's uber 3D fractal shader
 * Last update: 26 February 2011
 *
 * Changelog:
 *      0.1     - Initial release
 *      0.2     - Refactor for Fractal Lab
 *
 *
 * Copyright 2011, Tom Beddard
 * http://www.subblue.com
 *
 * For more generative graphics experiments see:
 * http://www.subblue.com
 *
 * Licensed under the GPL Version 3 license.
 * http://www.gnu.org/licenses/
 *
 *
 * Credits and references
 * ======================
 *
 * http://www.fractalforums.com/3d-fractal-generation/a-mandelbox-distance-estimate-formula/
 * http://www.fractalforums.com/3d-fractal-generation/revenge-of-the-half-eaten-menger-sponge/msg21700/
 * http://www.fractalforums.com/index.php?topic=3158.msg16982#msg16982
 *
 * Various other discussions on the fractal can be found here:
 * http://www.fractalforums.com/3d-fractal-generation/
 *
 *
*/

#define HALFPI 1.570796
#define MIN_EPSILON 6e-7
#define MIN_NORM 1.5e-7
#define minRange 6e-5
#define bailout 4.0
float cameraFocalLength = 1.0;

uniform sampler2DRect image1;
uniform sampler2DRect image2;

// Constants TAB
#define dE Mandelbulb             // {"label":"Fractal type", "control":"select", "options":["MengerSponge", "SphereSponge", "Mandelbulb", "Mandelbox", "OctahedralIFS", "DodecahedronIFS"]}
uniform vec3 param18;
int maxIterations = int(param18.y);
int stepLimit = int(param18.z);
uniform vec3 param7;
int aoIterations = int(param7.z);
//#define antialiasing 0.5            // {"label":"Anti-aliasing", "control":"bool", "default":false, "group_label":"Render quality"}
uniform vec3 param19;
bool antialiasing = bool(param19.x);
uniform vec3 param20;
bool render_on_black = bool(param20.x);
int aa_strength = int(param19.y);
float aa_softness = float(param19.z) * 0.01;


// Fractal TAB
uniform vec3 param1;
float power = float(param1.x) * 0.01;
float surfaceDetail = float(param1.y) * 0.01;
float surfaceSmoothness = float(param1.z) * 0.01;
uniform vec3 param2;
float boundingRadius = float(param2.x) * 0.01;

uniform vec3 param21;
vec3 offset = vec3(param20.y, param20.z, param21.x) * 0.01;
// uniform mat3  objectRotation;       // {"label":["Rotate x", "Rotate y", "Rotate z"], "group":"Fractal", "control":"rotation", "default":[0,0,0], "min":-360, "max":360, "step":1, "group_label":"Object rotation"}
uniform vec3 param22;
vec3 objRotation = vec3(param21.y, param21.z, param22.x) * 0.1;
uniform vec3 param4;
float juliaFactor = float(param4.y) * 0.001;
uniform vec3 param5;
float radiolariaFactor = float(param5.x) * 0.001;
float radiolaria = float(param4.z) * 0.001;

// Camera TAB
float cameraRoll = float(param22.y) * 1.0;
float cameraPitch = float(param22.z) * 1.0;
uniform vec3 param23;
float cameraYaw = float(param23.x) * 1.0;
uniform vec3 param24;
vec3 cameraPosition = vec3(param23.y, param23.z, param24.x) * 1.0;

// Colour TAB
uniform vec3 param8;
int colorIterations = int(param8.z);
uniform vec3 param25;
vec3 color1 = vec3(param24.y, param24.z, param25.x) * 0.01;
uniform vec3 param16;
float color1Intensity = float(param16.z) * 0.01;
uniform vec3 param26;
vec3 color2 = vec3(param25.y, param25.z, param26.x) * 0.01;
uniform vec3 param17;
float color2Intensity = float(param17.x) * 0.01;
uniform vec3 param27;
vec3 color3 = vec3(param26.y, param26.z, param27.x) * 0.01;
float color3Intensity = float(param17.y) * 0.01;
uniform vec3 param9;
float ambientColor = float(param9.x) * 0.01;
float ambientIntensity = float(param9.y) * 0.01;
uniform vec3 param28;
vec3 background1Color = vec3(param27.y, param27.z, param28.x) * 0.01;
uniform vec3 param29;
vec3 background2Color = vec3(param28.y, param28.z, param29.x) * 0.01;

// Shading TAB
uniform vec3 param30;
vec3 light = vec3(param29.y, param29.z, param30.x) * 0.1;
uniform vec3 param31;
vec3 innerGlowColor = vec3(param30.y, param30.z, param31.x) * 0.01;
float innerGlowIntensity = float(param17.z) * 0.01;
uniform vec3 param32;
vec3 outerGlowColor = vec3(param31.y, param31.z, param32.x) * 0.01;
float outerGlowIntensity = float(param18.x) * 0.01;
float fog = float(param8.x) * 0.01;
float fogFalloff = float(param8.y) * 0.01;
uniform vec3 param6;
float specularity = float(param6.y) * 0.01;
float specularExponent = float(param6.z) * 0.01;
float aoIntensity = float(param7.x) * 0.001;
float aoSpread = float(param7.y) * 0.001;


vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;


bool depthMap = bool(param32.y);
bool super_aa = bool(param32.z);




#define iGlobalTime adsk_time * 0.05 * speed + offset
#define HALF_PIX 0.5
#define fragCoord gl_FragCoord.xy

// CameraFX part start
vec2 adsk_getCameraNearFar();
vec2 camNearFar=adsk_getCameraNearFar();
// camera view
mat4 adsk_getCameraViewInverseMatrix();
// camera projection information
vec2 input_texture_size = vec2(adsk_result_w, adsk_result_h);
mat4 adsk_getCameraProjectionMatrix();
mat4 camProj = adsk_getCameraProjectionMatrix();
vec4 camProjectionInfo = vec4(-2.0 / (input_texture_size.x*camProj[0][0]),
                              -2.0 / (input_texture_size.y*camProj[1][1]),
                              ( 1.0 - camProj[0][2]) / camProj[0][0],
                              ( 1.0 + camProj[1][2]) / camProj[1][1]);

// Reconstruct camera-space P.xyz from screen-space S = (x, y) in pixels and image2.
vec3 screenToCamPos(vec2 ss_pos,float image2)
{
    float z = image2*(camNearFar.y-camNearFar.x)+camNearFar.x;
    vec3 cs_pos = vec3(((ss_pos + vec2(HALF_PIX))*
    camProjectionInfo.xy + camProjectionInfo.zw) * z, z);
    return -cs_pos;
}
// Recover the world position from the given camera position
vec3 camToWorldPos(vec3 c_pos)
{
    vec4 wpos = adsk_getCameraViewInverseMatrix()*vec4(c_pos,1.0);
    return wpos.w>0.0?wpos.xyz/wpos.w:wpos.xyz;
}
// CameraFX part end





// start for Flame compatibility reason
#define pi 3.1415926535897932384624433832795

// Degrees to radians
float deg2rad(float angle)
{
    return(angle/(180.0/pi));
}
// Rotates in ZXY order
float x = deg2rad(objRotation.x);
float y = deg2rad(objRotation.y);
float z = deg2rad(objRotation.z);
mat3 rx = mat3(1.0, 0.0, 0.0, 0.0, cos(x), sin(x), 0.0, -sin(x), cos(x));
mat3 ry = mat3(cos(y), 0.0, -sin(y), 0.0, 1.0, 0.0, sin(y), 0.0, cos(y));
mat3 rz = mat3(cos(z), sin(z), 0.0, -sin(z), cos(z), 0.0, 0.0, 0.0, 1.0);
mat3 objectRotation = ry * rx * rz;

// Rotates in ZXY order
//float fracx = deg2rad(fracRotation1.x);
//float fracy = deg2rad(fracRotation1.y);
//float fracz = deg2rad(fracRotation1.z);
//mat3 fracrx = mat3(1.0, 0.0, 0.0, 0.0, cos(fracx), sin(fracx), 0.0, -sin(fracx), cos(fracx));
//mat3 fracry = mat3(cos(fracy), 0.0, -sin(fracy), 0.0, 1.0, 0.0, sin(fracy), 0.0, cos(fracy));
//mat3 fracrz = mat3(cos(fracz), sin(fracz), 0.0, -sin(fracz), cos(fracz), 0.0, 0.0, 0.0, 1.0);
//mat3 fractalRotation1 = fracry * fracrx * fracrz;

// end for Flame compatibility reason




float aspectRatio = resolution.x / resolution.y;
float fovfactor = 1.0 / sqrt(1.0 + cameraFocalLength * cameraFocalLength);
float pixelScale = 1.0 / min(resolution.x, resolution.y);
float epsfactor = 2.0 * fovfactor * pixelScale * surfaceDetail;
vec3  w = vec3(0, 0, 1);
vec3  v = vec3(0, 1, 0);
vec3  u = vec3(1, 0, 0);
mat3  cameraRotation;


// Return rotation matrix for rotating around vector v by angle
mat3 rotationMatrixVector(vec3 v, float angle)
{
    float c = cos(radians(angle));
    float s = sin(radians(angle));

    return mat3(c + (1.0 - c) * v.x * v.x, (1.0 - c) * v.x * v.y - s * v.z, (1.0 - c) * v.x * v.z + s * v.y,
              (1.0 - c) * v.x * v.y + s * v.z, c + (1.0 - c) * v.y * v.y, (1.0 - c) * v.y * v.z - s * v.x,
              (1.0 - c) * v.x * v.z - s * v.y, (1.0 - c) * v.y * v.z + s * v.x, c + (1.0 - c) * v.z * v.z);
}



// Scalar derivative approach by Enforcer:
// http://www.fractalforums.com/mandelbulb-implementation/realtime-renderingoptimisations/
void powN(float p, inout vec3 z, float zr0, inout float dr)
{
    float zo0 = asin(z.z / zr0);
    float zi0 = atan(z.y, z.x);
    float zr = pow(zr0, p - 1.0);
    float zo = zo0 * p;
    float zi = zi0 * p;
    float czo = cos(zo);

    dr = zr * dr * p + 1.0;
    zr *= zr0;

    z = zr * vec3(czo * cos(zi), czo * sin(zi), sin(zo));
}

vec3 Mandelbulb(vec3 w)
{
    w *= objectRotation;

    vec3 z = w;
    vec3 c = mix(w, offset, juliaFactor);
    vec3 d = w;
    float dr = 1.0;
    float r  = length(z);
    float md = 10000.0;

    for (int i = 0; i < int(maxIterations); i++) {
        powN(power, z, r, dr);

        z += c;

        if (z.y > radiolariaFactor) {
            z.y = mix(z.y, radiolariaFactor, radiolaria);
        }

        r = length(z);

        if (i < colorIterations) {
            md = min(md, r);
            d = z;
        }

        if (r > bailout) break;
    }

    return vec3(0.5 * log(r) * r / dr, md, 0.33 * log(dot(d, d)) + 1.0);
}



// ============================================================================================ //



// Define the ray direction from the pixel coordinates
vec3 rayDirection(vec2 pixel)
{
    vec2 p = (0.5 * resolution - pixel) / vec2(resolution.x, -resolution.y);
    p.x *= aspectRatio;
    vec3 d = (p.x * u + p.y * v - cameraFocalLength * w);

    return normalize(cameraRotation * d);
}



// Intersect bounding sphere
//
// If we intersect then set the tmin and tmax values to set the start and
// end distances the ray should traverse.
bool intersectBoundingSphere(vec3 origin,
                             vec3 direction,
                             out float tmin,
                             out float tmax)
{
    bool hit = false;
    float b = dot(origin, direction);
    float c = dot(origin, origin) - boundingRadius;
    float disc = b*b - c;           // discriminant
    tmin = tmax = 0.0;

    if (disc > 0.0) {
        // Real root of disc, so intersection
        float sdisc = sqrt(disc);
        float t0 = -b - sdisc;          // closest intersection distance
        float t1 = -b + sdisc;          // furthest intersection distance

        if (t0 >= 0.0) {
            // Ray intersects image1 of sphere
            tmin = t0;
            tmax = t0 + t1;
        } else if (t0 < 0.0) {
            // Ray starts inside sphere
            tmax = t1;
        }
        hit = true;
    }

    return hit;
}




// Calculate the gradient in each dimension from the intersection point
vec3 generateNormal(vec3 z, float d)
{
    float e = max(d * 0.5, MIN_NORM);

    float dx1 = dE(z + vec3(e, 0, 0)).x;
    float dx2 = dE(z - vec3(e, 0, 0)).x;

    float dy1 = dE(z + vec3(0, e, 0)).x;
    float dy2 = dE(z - vec3(0, e, 0)).x;

    float dz1 = dE(z + vec3(0, 0, e)).x;
    float dz2 = dE(z - vec3(0, 0, e)).x;

    return normalize(vec3(dx1 - dx2, dy1 - dy2, dz1 - dz2));
}


// Blinn phong shading model
// http://en.wikipedia.org/wiki/BlinnPhong_shading_model
// base color, incident, point of intersection, normal
vec3 blinnPhong(vec3 color, vec3 p, vec3 n)
{
    // Ambient colour based on background gradient
    vec3 ambColor = clamp(mix(background2Color, background1Color, (sin(n.y * HALFPI) + 1.0) * 0.5), 0.0, 1.0);
    ambColor = mix(vec3(ambientColor), ambColor, ambientIntensity);

    vec3  halfLV = normalize(light - p);
    float diffuse = max(dot(n, halfLV), 0.0);
    float specular = pow(diffuse, specularExponent);

    return ambColor * color + color * diffuse + specular * specularity;
}

vec3 depthMatte(vec3 color, vec3 p, vec3 n)
{
    // Ambient colour based on background gradient
    vec3 depthColor = clamp(mix(background2Color, background1Color, (sin(n.y * HALFPI) + 1.0) * 0.5), 0.0, 1.0);
    depthColor = mix(vec3(ambientColor), depthColor, ambientIntensity);

    vec3  halfLV = normalize(light - p);
    float diffuse = max(dot(n, halfLV), 0.0);
    float specular = pow(diffuse, specularExponent);

    return depthColor * color + color * diffuse;
}

// Ambient occlusion approximation.
// Based upon boxplorer's implementation which is derived from:
// http://www.iquilezles.org/www/material/nvscene2008/rwwtt.pdf
float ambientOcclusion(vec3 p, vec3 n, float eps)
{
    float o = 1.0;                  // Start at full output colour intensity
    eps *= aoSpread;                // Spread diffuses the effect
    float k = aoIntensity * 0.1 / eps;    // Set intensity factor
    float d = 2.0 * eps;            // Start ray a little off the surface

    for (int i = 0; i < aoIterations; ++i) {
        o -= (d - dE(p + n * d).x) * k;
        d += eps;
        k *= 0.5;                   // AO contribution drops as we move further from the surface
    }

    return clamp(o, 0.0, 1.0);
}

vec3 z_depth = vec3(0.0);


// Calculate the output colour for each input pixel
vec4 render(vec3 ro, vec3 rd, float rz)
{
        vec3 cameraPosition = ro;
        vec3 ray_direction = rd;
    float ray_length = minRange;
        vec3 ray = ro + ray_length * ray_direction;
    vec4  color = vec4(0.0);

    vec4 bg_color = vec4(clamp(mix(background2Color, background1Color, (sin(ray_direction.y * HALFPI) + 1.0) * 0.5), 0.0, 1.0), 1.0);

    float eps = MIN_EPSILON;
    vec3  dist;
    vec3  normal = vec3(0);
    int   steps = 0;
    bool  hit = false;
    float tmin = 0.0;
    float tmax = 10000.0;


    if (intersectBoundingSphere(ray, ray_direction, tmin, tmax)) {
        ray_length = tmin;
        ray = cameraPosition + ray_length * ray_direction;

        for (int i = 0; i < stepLimit; i++) {
            steps = i;
            dist = dE(ray);
            dist.x *= surfaceSmoothness;

            // If we hit the surface on the previous step check again to make sure it wasn't
            // just a thin filament
            if (hit && dist.x < eps || ray_length > tmax || ray_length < tmin) {
                steps--;
                break;
            }

            hit = false;
            ray_length += dist.x;
            ray = cameraPosition + ray_length * ray_direction;
            eps = ray_length * epsfactor;

            if (dist.x < eps || ray_length < tmin) {
                hit = true;
            }
        }
    }

    // Found intersection?
    float glowAmount = float(steps)/float(stepLimit);
    float glow;

    if (hit) {
        float aof = 1.0, shadows = 1.0;
        glow = clamp(glowAmount * innerGlowIntensity * 3.0, 0.0, 1.0);

        if (steps < 1 || ray_length < tmin) {
            normal = normalize(ray);
        } else {
            normal = generateNormal(ray, eps);
            aof = ambientOcclusion(ray, normal, eps);
        }

            // creating the matte pass
            color.a = float(mix(color1, mix(color2, color3, 1.0), 1.0));

            // creating the beauty pass
            color.rgb = mix(color1, mix(color2, color3, dist.y * color2Intensity), dist.z * color3Intensity);

            // add shading
            color.rgb = blinnPhong(clamp(color.rgb * color1Intensity, 0.0, 1.0), ray, normal);

            // add inner glow
            color.rgb = mix(color.rgb, innerGlowColor, glow);

            // add AO
            color.rgb *= aof;

            // add fog
            color.rgb = mix(bg_color.rgb, color.rgb, exp(-pow(ray_length * exp(fogFalloff * .1), 2.0) * fog * .1));


    } else {
        // Apply outer glow and fog
        ray_length = tmax;
        color.rgb = mix(bg_color.rgb, color.rgb, exp(-pow(ray_length * exp(fogFalloff * .1), 2.0)) * fog * .1);
        glow = clamp(glowAmount * outerGlowIntensity * 3.0, 0.0, 1.0);
        color.rgb = mix(color.rgb, outerGlowColor, glow);

    }

    if ( depthMap )
    {
        // add shading
        z_depth.rgb = depthMatte(vec3(0.0), ray, normal);

        // add fog
        z_depth.rgb = mix(vec3(1.0).rgb, z_depth.rgb, exp(-pow(ray_length, 2.0) * 500. * .1));
    }

    return color;
}

float rand2(vec2 p) {
    return fract(sin(dot(p ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{

    // camera position in world (NB : z < 0)
    vec3 ro=camToWorldPos(vec3(0.0));
    // screen space pos of the current fragment
    vec2 coords = gl_FragCoord.xy/input_texture_size;
    // fetch the fragment image2
    float image2 = texture2DRect(image2, res * coords).x;
    // fetch the fragment diffuse color
    vec3  diff = texture2DRect(image1, res * coords).rgb;
/*
    // get the fragment world position (NB : z < 0)
  vec3 pos = camToWorldPos(screenToCamPos(gl_FragCoord.xy,image2));
    // get the ray dir to march along
    vec3 rd=normalize(pos-ro);
    // get the ray length to march along
    float rz=distance(pos,ro);
    // output color initialize to the diffuse
    vec4 color = vec4(diff.rgb, 1.0);
  */
    ro *= .0022;

  vec4 color = vec4(diff.rgb, 1.0);

  if ( antialiasing )
    {
        float n = 0.0;
        for(int i=0; i < aa_strength; i++)
        {
            float aa_offset = rand2(vec2(i, i))-0.5;
      // get the fragment world position (NB : z < 0)
      vec3 pos = camToWorldPos(screenToCamPos(gl_FragCoord.xy + aa_offset * aa_softness, image2));
      // get the ray dir to march along
      vec3 rd=normalize(pos-ro);
      // get the ray length to march along
      float rz=distance(pos,ro);
            color += render(ro, rd, rz);
        }
        color /= float(aa_strength);

    }
    else
  {
    // get the fragment world position (NB : z < 0)
    vec3 pos = camToWorldPos(screenToCamPos(gl_FragCoord.xy,image2));
    // get the ray dir to march along
    vec3 rd=normalize(pos-ro);
    // get the ray length to march along
    float rz=distance(pos,ro);
    color = render(ro, rd, rz );
  }

    gl_FragColor = vec4(color.rgb, color.a);

}
