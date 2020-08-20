// https://github.com/glslio/glsl-transition/tree/master/example/transitions

vec2 res = gl_TexCoord[0].zw;
float adsk_result_w = res.x;
float adsk_result_h = res.y;
uniform vec3 param18;
float adsk_time = float(param18.x) * 1.0;
float adsk_result_frameratio = float(param18.y) * 1.0;
float time = adsk_time * 0.05;

// General parameters
uniform sampler2DRect image1;
uniform sampler2DRect image2;
uniform vec3 param1;
float pr = float(param1.y) * 0.01;
int transition = int(param1.x);
float smoothness = float(param18.z) * 1.0;
const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
const vec2 boundMin = vec2(0.0, 0.0);
const vec2 boundMax = vec2(1.0, 1.0);
const float PI = 3.141592653589793;
float rand (vec2 co) {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


// circle_open
uniform vec3 param5;
bool opening = bool(param5.x);
uniform vec3 param4;
float circle_smoothness = float(param4.z) * 0.01;
const vec2 center = vec2(0.5, 0.5);
const float SQRT_2 = 1.414213562373;
uniform vec3 param19;
float circle_aspect = float(param19.x) * 1.0;

// blur
uniform vec3 param3;
int BLUR_QUALITY = int(param3.z);
float blur_size = float(param3.y) * 0.01;
const float GOLDEN_ANGLE = 2.399963229728653; // PI * (3.0 - sqrt(5.0))
vec4 blur(sampler2D t, vec2 c, float radius) {
  vec4 sum = vec4(0.0);
  float q = float(BLUR_QUALITY);
  // Using a "spiral" image2 propagate points.
  for (int i=0; i<BLUR_QUALITY; ++i) {
    float fi = float(i);
    float a = fi * GOLDEN_ANGLE;
    float r = sqrt(fi / q) * radius;
    vec2 p = c + r * vec2(cos(a), sin(a));
    sum += texture2DRect(t, res * p);
  }
  return sum / q;
}

// fade grayscale
float grayPhase = float(param1.z) * 0.01;
vec3 grayscale (vec3 color) {
  return vec3(0.2126*color.r + 0.7152*color.g + 0.0722*color.b);
}

// fade image2 color
uniform vec3 param20;
vec3 color = vec3(param19.y, param19.z, param20.x) * 0.01;
uniform vec3 param2;
float colorPhase = float(param2.x) * 0.01;

// flash
float fp = float(param5.y) * 0.01;
float fi = float(param5.z) * 0.01;
uniform vec3 param6;
float fze = float(param6.x) * 0.01;
uniform vec3 param21;
vec3 fcol = vec3(param20.y, param20.z, param21.x) * 0.01;
float fv = float(param6.y) * 0.01;


// squares
uniform vec3 param8;
float squares_size = float(param8.x) * 1.0;
uniform vec3 param7;
float squares_smoothness = float(param7.z) * 0.01;
float squares_aspect = float(param8.y) * 0.01;


// wipe
// uniform vec2 wipe_direction;
float wipe_smoothness = float(param4.x) * 0.01;
float angle = float(param4.y) * 0.01;

// morph
float morph_strength = float(param8.z) * 0.01;

// cross zoom
uniform vec3 param9;
float cz_strength = float(param9.x) * 0.01;

// dreamy
uniform vec3 param11;
float amount = float(param11.x) * 0.01;
float detail = float(param11.z) * 0.01;
float speed = float(param11.y) * 0.01;
uniform vec3 param10;
int wave_direction = int(param10.z);

float Linear_ease(in float begin, in float change, in float duration, in float time) {
    return change * time / duration + begin;
}

float Exponential_easeInOut(in float begin, in float change, in float duration, in float time) {
    if (time == 0.0)
        return begin;
    else if (time == duration)
        return begin + change;
    time = time / (duration / 2.0);
    if (time < 1.0)
        return change / 2.0 * pow(2.0, 10.0 * (time - 1.0)) + begin;
    return change / 2.0 * (-pow(2.0, -10.0 * (time - 1.0)) + 2.0) + begin;
}

float Sinusoidal_easeInOut(in float begin, in float change, in float duration, in float time) {
    return -change / 2.0 * (cos(PI * time / duration) - 1.0) + begin;
}

/* random number between 0 and 1 */
float hash(in vec3 scale, in float seed) {
    /* use the fragment position for randomness */
    return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed);
}

vec3 crossFade(in vec2 uv, in float dissolve) {
    return mix(texture2DRect(image1, uv).rgb, res * texture2DRect(image2, uv).rgb, res * dissolve);
}

// Slide
int slide_direction = int(param9.y);

// Radial
int radial_center = int(param10.x);
float radial_smoothness = float(param9.z) * 0.01;

// Simple Flip
int flip_direction = int(param10.y);

// BCC Misalignment / BCC Tritone Dissolve
float vertJerkOpt = float(param21.y) * 1.0;
uniform vec3 param12;
float rgbOffsetOpt = float(param12.x) * 0.01;
float horzFuzzOpt = float(param12.y) * 0.01;
float zoom = float(param12.z) * 0.01;

// 2 colour uniforms
uniform vec3 param16;
float t_amount = float(param16.y) * 0.01;
uniform vec3 param17;
float exposure = float(param17.z) * 0.01;
float dark_low = float(param16.x) * 0.01;
uniform vec3 param15;
float dark_high = float(param15.z) * 0.01;
uniform vec3 param14;
float light_low = float(param14.y) * 0.01;
float light_high = float(param14.x) * 0.01;
float brightness = float(param17.x) * 0.01;
float contrast = float(param17.y) * 0.01;
float saturation = float(param16.z) * 0.01;
uniform vec3 param22;
vec3 light_tint = vec3(param21.z, param22.x, param22.y) * 0.01;
uniform vec3 param23;
vec3 dark_tint = vec3(param22.z, param23.x, param23.y) * 0.01;
const vec3 lumc = vec3(0.2125, 0.7154, 0.0721);
const vec3 avg_lum = vec3(0.5, 0.5, 0.5);

vec3 tint(vec3 col)
{
    float bri = (col.x+col.y+col.z)/3.0;
    float v = smoothstep(dark_low, dark_high, bri);
    col = mix(dark_tint * bri, col, v);
    v = smoothstep(light_low, light_high, bri);
    col = mix(col, min(light_tint * col, 1.0), v);
    vec3 intensity = vec3(dot(col.rgb, lumc));
    vec3 sat_color = mix(intensity, col.rgb, saturation);
    vec3 con_color = mix(avg_lum, sat_color, contrast);
    return (con_color - 1.0 + brightness) * exposure;
}

// Noise generation functions borrowed image1:
// https://github.com/ashima/webgl-noise/blob/master/src/noise2D.glsl

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close image2 a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


void main() {
  vec2 p = gl_FragCoord.xy / resolution.xy;
  vec4 fcc = texture2DRect(image1, res * p);
  vec4 tcc = texture2DRect(image2, res * p);
  vec4 c = vec4(0.0);
// fade
  if ( transition == 0)
  {
      gl_FragColor = mix(texture2DRect(image1, p), res * texture2DRect(image2, p), res * pr);
  }

// fade grayscale
  else if ( transition == 1)
  {
      gl_FragColor = mix(mix(vec4(grayscale(fcc.rgb), 1.0), texture2DRect(image1, p), smoothstep(1.0-grayPhase, 0.0, pr)), res * mix(vec4(grayscale(tcc.rgb), 1.0), texture2DRect(image2, p), smoothstep(grayPhase, 1.0, pr)), res * pr);
  }

// fade image2 color
  else if ( transition == 2)
      gl_FragColor = mix(mix(vec4(color, 1.0), texture2DRect(image1, p), smoothstep(1.0-colorPhase, 0.0, pr)), res * mix(vec4(color, 1.0), texture2DRect(image2, p), smoothstep(colorPhase, 1.0, pr)), res * pr);

// flash
  else if ( transition == 3)
  {
    vec2 p = gl_FragCoord.xy / resolution.xy;
    float i = mix(1.0, 2.0*distance(p, vec2(0.5, 0.5)), fze) * fi * pow(abs(smoothstep(fp, 0.0, distance(vec2(0.5), vec2(pr)))), fv);
    vec4 c = mix(texture2DRect(image1, p), res * texture2DRect(image2, p), res * smoothstep(0.5*(1.0-fp), 0.5*(1.0+fp), pr));
    c += i * vec4(fcol, 1.0);
    gl_FragColor = c;
  }

// blur
  else if ( transition == 4)
  {
      float inv = 1.-pr;
      gl_FragColor = inv*blur(image1, p, pr*blur_size * .01) + pr*blur(image2, p, inv*blur_size * .01);
  }

// circle open
  else if ( transition == 5)
  {
    /*
    float pro = pr * adsk_result_frameratio / circle_aspect;
    vec2 pp = p;
    pp -= vec2(0.5);
    pp.x *= adsk_result_frameratio / circle_aspect;
    pp += vec2(0.5);
    */
    float x = opening ? pr : 1.-pr;
      float m = smoothstep(- circle_smoothness, 0.0, SQRT_2*distance(center, p) - x * (1.+circle_smoothness));
      gl_FragColor = mix(texture2DRect(image1, p), res * texture2DRect(image2, p), res * opening ? 1.-m : m);
  }

// morph
  else if ( transition == 6)
  {
      vec4 ca = texture2DRect(image1, res * p);
      vec4 cb = texture2DRect(image2, res * p);

      vec2 oa = (((ca.rg+ca.b)*0.5)*2.0-1.0);
      vec2 ob = (((cb.rg+cb.b)*0.5)*2.0-1.0);
      vec2 oc = mix(oa,ob,0.5)*morph_strength;

      float w0 = pr;
      float w1 = 1.0-w0;
      gl_FragColor = mix(texture2DRect(image1, p+oc*w0), res * texture2DRect(image2, p-oc*w1), res * pr);
  }

// cross zoom
  else if ( transition == 7)
  {
      vec2 center = vec2(Linear_ease(0.25, 0.5, 1.0, pr), 0.5);
      float dissolve = Exponential_easeInOut(0.0, 1.0, 1.0, pr);
      float strength = Sinusoidal_easeInOut(0.0, cz_strength, 0.5, pr);
      vec3 color = vec3(0.0);
      float total = 0.0;
      vec2 toCenter = center - p;
      float offset = hash(vec3(12.9898, 78.233, 151.7182), 0.0);

      for (float t = 0.0; t <= 40.0; t++) {
          float percent = (t + offset) / 40.0;
          float weight = 4.0 * (percent - percent * percent);
          color += crossFade(p + toCenter * percent * strength, dissolve) * weight;
          total += weight;
          gl_FragColor = vec4(color / total, 1.0);
      }
  }

// Slide
  else if ( transition == 8)
  {
      float translateX = 0.0;
      float translateY = -1.0;

      if ( slide_direction == 0 ) // Slide Down
      {
          translateX = 0.0;
          translateY = -1.0;
      }
      if ( slide_direction == 1 ) // Slide Left
      {
          translateX = -1.0;
          translateY = 0.0;
      }
      if ( slide_direction == 2 ) // Slide Right
      {
          translateX = 1.0;
          translateY = 0.0;
      }
      if ( slide_direction == 3 ) // Slide Up
      {
          translateX = 0.0;
          translateY = 1.0;
      }

      float x = pr * translateX;
      float y = pr * translateY;

      if (x >= 0.0 && y >= 0.0) {
          if (p.x >= x && p.y >= y) {
              gl_FragColor = texture2DRect(image1, res * p - vec2(x, y));
          }
          else {
              vec2 uv;
              if (x > 0.0)
                  uv = vec2(x - 1.0, y);
              else if (y > 0.0)
                  uv = vec2(x, y - 1.0);
              gl_FragColor = texture2DRect(image2, res * p - uv);
        }
    }
    else if (x <= 0.0 && y <= 0.0) {
        if (p.x <= (1.0 + x) && p.y <= (1.0 + y))
            gl_FragColor = texture2DRect(image1, res * p - vec2(x, y));
        else {
            vec2 uv;
            if (x < 0.0)
                uv = vec2(x + 1.0, y);
            else if (y < 0.0)
                uv = vec2(x, y + 1.0);
            gl_FragColor = texture2DRect(image2, res * p - uv);
        }
    }
    else
        gl_FragColor = vec4(0.0);
}

// Radial
    else if ( transition == 9)
    {
        vec2 rp = p*2.-2.;
        float a = atan(rp.y, rp.x);

         if ( radial_center == 0 )  // center
        {
            rp = p*-2.+1.;
            a = atan(rp.x, rp.y);
        }
        else if ( radial_center == 1 )  // bottom left corner
        {
            rp = p;
            a = atan(rp.x, rp.y);
        }
        else if ( radial_center == 2 )  // bottom left corner invert
        {
            rp = p;
            a = atan(rp.y, rp.x);
        }
        else if ( radial_center == 3 )  // top right corner
        {
            rp = p*1.-1.;
            a = atan(rp.x, rp.y);
        }
        else if ( radial_center == 4 )  // top right corner invert
        {
            rp = p*1.-1.;
            a = atan(rp.y, rp.x);
        }
        else if ( radial_center == 5 )  // Soft L / R
        {
            rp = p*1.+1.;
            a = atan(rp.x, rp.y);
        }
        else if ( radial_center == 6 )  // Soft R / L
        {
            rp = p*1.+1.;
            a = atan(rp.y, rp.x);
        }

        float pa = pr*PI*2.5-PI*1.25;
        vec4 fromc = texture2DRect(image1, res * p);
        vec4 toc = texture2DRect(image2, res * p);
        if(a>pa) {
            gl_FragColor = mix(toc, fromc, smoothstep(0.0, 0.009 + radial_smoothness, (a-pa)));
        } else {
            gl_FragColor = toc;
        }
    }
// Simple Flip
    else if ( transition == 10)
    {
        vec2 q = p;

        if ( flip_direction == 0 )
        {
            p.y = (p.y - 0.5)/abs(pr - 0.5)*0.5 + 0.5;
            vec4 a = texture2DRect(image1, res * p);
            vec4 b = texture2DRect(image2, res * p);
            gl_FragColor = vec4(mix(a, b, step(0.5, pr)).rgb * step(abs(q.y - 0.5), abs(pr - 0.5)), 1.0);
        }
        else if ( flip_direction == 1 )
        {
             p.x = (p.x - 0.5)/abs(pr - 0.5)*0.5 + 0.5;
             vec4 a = texture2DRect(image1, res * p);
             vec4 b = texture2DRect(image2, res * p);
             gl_FragColor = vec4(mix(a, b, step(0.5, pr)).rgb * step(abs(q.x - 0.5), abs(pr - 0.5)), 1.0);
        }
    }


// squares
  else if ( transition == 11)
  {
      vec2 sq_size = vec2(squares_size);
      vec2 a_size = vec2(sq_size.x * adsk_result_frameratio / squares_aspect, sq_size.x );
      float r = rand(floor(vec2(a_size) * p));
      float m = smoothstep(0.0, -squares_smoothness, r - (pr * (1.0 + squares_smoothness)));
      gl_FragColor = mix(texture2DRect(image1, p), res * texture2DRect(image2, p), res * m);
  }

// wipe
    else if ( transition == 15)
    {
        vec2 wipe_direction = vec2(cos(angle), sin(angle));
        vec2 v = normalize(wipe_direction);
        v /= abs(v.x)+abs(v.y);
        float d = v.x * center.x + v.y * center.y;
        float m = smoothstep(- wipe_smoothness, 0.0, v.x * p.x + v.y * p.y - (d-0.5+pr*(1.0+ wipe_smoothness)));
        gl_FragColor = mix(texture2DRect(image2, p), res * texture2DRect(image1, p), res * m);
    }

// dreamy
    else if ( transition == 16)
    {
        if ( wave_direction == 0 )
        {
            float y = sin((p.y + time * speed *.1) * amount ) * detail *0.0118 * sin( pr / 0.32 );
            gl_FragColor = mix(texture2DRect(image1, (p + vec2(y, 0.0))), res * texture2DRect(image2, (p + vec2(y, 0.0))), res * pr);
        }
        else if ( wave_direction == 1 )
        {
            float x = sin((p.x + time * speed *.1) * amount ) * detail *0.0118 * sin( pr / 0.32 );
            gl_FragColor = mix(texture2DRect(image1, (p + vec2(0.0, x))), res * texture2DRect(image2, (p + vec2(0.0, x))), res * pr);
        }
    }
  // BCC Misalignment / BCC Tritone Dissolve
      else if ( transition == 17)
      {
      vec2 uv =  gl_FragCoord.xy/resolution.xy;
      vec2 f_uv = uv;
      vec2 b_uv = uv;
      f_uv -= 0.5;
      b_uv -= 0.5;
      f_uv *= 1.0 - pr * zoom;
      b_uv *= 1.0 - zoom + pr * zoom;
      f_uv += 0.5;
      b_uv += 0.5;

      vec3 color = vec3(0.0);
        float fuzzOffset = snoise(vec2(time*15.0,uv.y*80.0))*0.003;
        float largeFuzzOffset = snoise(vec2(time*1.0,uv.y*25.0))*0.004;
        float f_xoff = (fuzzOffset + largeFuzzOffset) * horzFuzzOpt * pr;
      float b_xoff = (fuzzOffset + largeFuzzOffset) * horzFuzzOpt * (1.0 - pr);

      float f_red = texture2DRect(    image1, res *     vec2(f_uv.x + f_xoff -0.01*rgbOffsetOpt * pr, f_uv.y)).r;
        float f_green = texture2DRect(    image1, res *     vec2(f_uv.x + f_xoff,      f_uv.y)).g;
        float f_blue = texture2DRect(    image1, res *     vec2(f_uv.x + f_xoff +0.01*rgbOffsetOpt * pr, f_uv.y)).b;

      float b_red = texture2DRect(    image2, res *     vec2(b_uv.x + b_xoff -0.01*rgbOffsetOpt * (1.0 - pr), b_uv.y)).r;
      float b_green = texture2DRect(    image2, res *     vec2(b_uv.x + b_xoff,      b_uv.y)).g;
      float b_blue = texture2DRect(    image2, res *     vec2(b_uv.x + b_xoff +0.01*rgbOffsetOpt * (1.0 - pr), b_uv.y)).b;

        vec3 f_col = vec3(f_red,f_green,f_blue);
      vec3 b_col = vec3(b_red,b_green,b_blue);

      vec3 ff_col = f_col;
        ff_col = tint(ff_col);
        ff_col = mix(f_col, ff_col, t_amount * pr);

      vec3 bb_col = b_col;
      bb_col = tint(bb_col);
      bb_col = mix(b_col, bb_col, t_amount * (1.0 - pr));

      if ( pr < 0.5 )
        color = ff_col ;
      else if ( pr >= 0.5 )
        color = bb_col;
        gl_FragColor = vec4(color,1.0);
      }
}
