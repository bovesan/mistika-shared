// based on http://hirnsohle.de/test/fractalLab/
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

// Constants TAB
#define dE Mandelbox             // {"label":"Fractal type", "control":"select", "options":["MengerSponge", "SphereSponge", "Mandelbulb", "Mandelbox", "OctahedralIFS", "DodecahedronIFS"]}
uniform vec3 param23;
int maxIterations = int(param23.x);
int stepLimit = int(param23.y);
uniform vec3 param11;
int aoIterations = int(param11.z);
//#define antialiasing 0.5            // {"label":"Anti-aliasing", "control":"bool", "default":false, "group_label":"Render quality"}
bool antialiasing = bool(param23.z);
uniform vec3 param24;
float aa_strength = float(param24.x) * 0.01;


// Fractal TAB
uniform vec3 param1;
float scale = float(param1.x) * 0.01;
float surfaceDetail = float(param1.y) * 0.01;
float surfaceSmoothness = float(param1.z) * 0.01;
uniform vec3 param2;
float boundingRadius = float(param2.x) * 0.01;
uniform vec3 param25;
vec3 offset = vec3(param25.x, param25.y, param25.z) * 0.01;
// uniform mat3  objectRotation;       // {"label":["Rotate x", "Rotate y", "Rotate z"], "group":"Fractal", "control":"rotation", "default":[0,0,0], "min":-360, "max":360, "step":1, "group_label":"Object rotation"}
uniform vec3 param26;
vec3 objRotation = vec3(param26.x, param26.y, param26.z) * 0.1;


uniform vec3 param27;
vec3 fracRotation1 = vec3(param27.x, param27.y, param27.z) * 0.1;
uniform vec3 param28;
vec3 fracRotation2 = vec3(param28.x, param28.y, param28.z) * 0.1;
uniform vec3 param6;
float sphereScale = float(param6.y) * 0.01;
float boxScale = float(param6.z) * 0.01;
uniform vec3 param7;
float boxFold = float(param7.x) * 0.01;
float fudgeFactor = float(param7.y) * 0.01;




// Camera TAB
float cameraRoll = float(param7.z) * 0.1;
uniform vec3 param8;
float cameraPitch = float(param8.x) * 0.1;
float cameraYaw = float(param8.y) * 0.1;
float cameraFocalLength = float(param8.z) * 0.01;
uniform vec3 param29;
vec3 cameraPosition = vec3(param29.x, param29.y, param29.z) * 0.01;

// Colour TAB
uniform vec3 param12;
int colorIterations = int(param12.z);
uniform vec3 param30;
vec3 color1 = vec3(param30.x, param30.y, param30.z) * 0.01;
uniform vec3 param20;
float color1Intensity = float(param20.z) * 0.01;
uniform vec3 param31;
vec3 color2 = vec3(param31.x, param31.y, param31.z) * 0.01;
uniform vec3 param21;
float color2Intensity = float(param21.x) * 0.01;
uniform vec3 param32;
vec3 color3 = vec3(param32.x, param32.y, param32.z) * 0.01;
float color3Intensity = float(param21.y) * 0.01;
uniform vec3 param13;
float ambientColor = float(param13.x) * 0.01;
float ambientIntensity = float(param13.y) * 0.01;
uniform vec3 param33;
vec3 background1Color = vec3(param33.x, param33.y, param33.z) * 0.01;
uniform vec3 param34;
vec3 background2Color = vec3(param34.x, param34.y, param34.z) * 0.01;

// Shading TAB
uniform vec3 param35;
vec3 light = vec3(param35.x, param35.y, param35.z) * 0.1;
uniform vec3 param36;
vec3 innerGlowColor = vec3(param36.x, param36.y, param36.z) * 0.01;
float innerGlowIntensity = float(param21.z) * 0.01;
uniform vec3 param37;
vec3 outerGlowColor = vec3(param37.x, param37.y, param37.z) * 0.01;
uniform vec3 param22;
float outerGlowIntensity = float(param22.x) * 0.01;
float fog = float(param12.x) * 0.01;
float fogFalloff = float(param12.y) * 0.01;
float specularity = float(param22.y) * 0.01;
float specularExponent = float(param22.z) * 0.01;
float aoIntensity = float(param11.x) * 0.01;
float aoSpread = float(param11.y) * 0.01;


vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;


bool depthMap = bool(param24.y);
bool super_aa = bool(param24.z);

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
float frac1x = deg2rad(fracRotation1.x);
float frac1y = deg2rad(fracRotation1.y);
float frac1z = deg2rad(fracRotation1.z);
mat3 fracr1x = mat3(1.0, 0.0, 0.0, 0.0, cos(frac1x), sin(frac1x), 0.0, -sin(frac1x), cos(frac1x));
mat3 fracr1y = mat3(cos(frac1y), 0.0, -sin(frac1y), 0.0, 1.0, 0.0, sin(frac1y), 0.0, cos(frac1y));
mat3 fracr1z = mat3(cos(frac1z), sin(frac1z), 0.0, -sin(frac1z), cos(frac1z), 0.0, 0.0, 0.0, 1.0);
mat3 fractalRotation1 = fracr1y * fracr1x * fracr1z;

// Rotates in ZXY order
float frac2x = deg2rad(fracRotation2.x);
float frac2y = deg2rad(fracRotation2.y);
float frac2z = deg2rad(fracRotation2.z);
mat3 fracr2x = mat3(1.0, 0.0, 0.0, 0.0, cos(frac2x), sin(frac2x), 0.0, -sin(frac2x), cos(frac2x));
mat3 fracr2y = mat3(cos(frac2y), 0.0, -sin(frac2y), 0.0, 1.0, 0.0, sin(frac2y), 0.0, cos(frac2y));
mat3 fracr2z = mat3(cos(frac2z), sin(frac2z), 0.0, -sin(frac2z), cos(frac2z), 0.0, 0.0, 0.0, 1.0);
mat3 fractalRotation2 = fracr2y * fracr2x * fracr2z;
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



// Pre-calculations
float mR2 = boxScale * boxScale;    // Min radius
float fR2 = sphereScale * mR2;      // Fixed radius
vec2  scaleFactor = vec2(scale, abs(scale)) / mR2;

// Details about the Mandelbox DE algorithm:
// http://www.fractalforums.com/3d-fractal-generation/a-mandelbox-distance-estimate-formula/
vec3 Mandelbox(vec3 w)
{
    w *= objectRotation;
    float md = 1000.0;
    vec3 c = w;
    
    // distance estimate
    vec4 p = vec4(w.xyz, 1.0),
        p0 = vec4(w.xyz, 1.0);  // p.w is knighty's DEfactor
    
    for (int i = 0; i < int(maxIterations); i++) {
        // box fold:
        // if (p > 1.0) {
        //   p = 2.0 - p;
        // } else if (p < -1.0) {
        //   p = -2.0 - p;
        // }
        p.xyz = clamp(p.xyz, -boxFold, boxFold) * 2.0 * boxFold - p.xyz;  // box fold
        p.xyz *= fractalRotation1;
        
        // sphere fold:
        // if (d < minRad2) {
        //   p /= minRad2;
        // } else if (d < 1.0) {
        //   p /= d;
        // }
        float d = dot(p.xyz, p.xyz);
        p.xyzw *= clamp(max(fR2 / d, mR2), 0.0, 1.0);  // sphere fold
        
        p.xyzw = p * scaleFactor.xxxy + p0 + vec4(offset, 0.0);
        p.xyz *= fractalRotation2;

        if (i < colorIterations) {
            md = min(md, d);
            c = p.xyz;
        }
    }
    
    // Return distance estimate, min distance, fractional iteration count
    return vec3((length(p.xyz) - fudgeFactor) / p.w, md, 0.33 * log(dot(c, c)) + 1.0);
}

 
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
            // Ray intersects front of sphere
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
    float k = aoIntensity / eps;    // Set intensity factor
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
vec4 render(vec2 pixel)
{
    vec3  ray_direction = rayDirection(pixel);
    float ray_length = minRange;
    vec3  ray = cameraPosition + ray_length * ray_direction;
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

// ============================================================================================ //


// The main loop
void main()
{
    vec4 color = vec4(0.0);
    float aa_mulitplier = 1.0;
    
    float n = 0.0;
    
    cameraRotation = rotationMatrixVector(v, 180.0 - cameraYaw) * rotationMatrixVector(u, -cameraPitch) * rotationMatrixVector(w, cameraRoll);
    
    
    if ( antialiasing )
    {
        if ( super_aa )
            aa_mulitplier = 2.0;
        for (float x = 0.0; x < 1.0; x += float(1.0 - aa_strength * .7 * aa_mulitplier )) {
            for (float y = 0.0; y < 1.0; y += float(1.0 - aa_strength * .7)) {
                color += render(gl_FragCoord.xy + vec2(x, y));
                n += 1.0;
            }
        }
        color /= n;
    }

    else
        color = render(gl_FragCoord.xy);
    
    if ( depthMap )
            gl_FragColor = vec4(color.rgb, z_depth.r);
    else
        gl_FragColor = vec4(color.rgb, color.a);
    
}
