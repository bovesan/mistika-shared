#ifdef GL_ES
precision mediump float;
#endif

// Based on http://glslsandbox.com/e#20985.0

uniform sampler2DRect image1;

uniform vec3 param1;
uniform vec3 param2;
uniform vec3 param3;
uniform vec3 param4;
uniform vec3 param5;

void main(void)
{
	float time = param1.x*0.0001;
	vec2 mouse = param1.yz*0.1;
	
	//Comments are default values
	
	int iterations = int(param2.x); // 16
	float formuparam = param2.y*0.01; // 0.53

	int volsteps = int(param2.z); // 7
	float stepsize = param3.x*0.01; // 0.1

	float zoom = param3.y*0.01; // 0.800
	float tile = param3.z*0.01; // 0.850

	float brightness = param4.x*0.0001; // 0.0015
	float darkmatter = param4.y*0.01; // 0.300
	float distfading = param4.z*0.01; // 0.730
	float saturation = param5.x*0.01; // 0.850
	
	vec2 resolution = gl_TexCoord[0].zw;
	//get coords and direction
	vec2 uv=gl_FragCoord.xy/resolution.xy*.5;
	uv.y*=resolution.y/resolution.x;
	vec3 dir=vec3(uv*zoom,1.);

	//mouse rotation
	float a1=.5+mouse.x/resolution.x*2.;
	float a2=.8+mouse.y/resolution.y*2.;
	mat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));
	mat2 rot2=mat2(cos(a2),sin(a2),-sin(a2),cos(a2));
	dir.xz*=rot1;
	dir.xy*=rot2;
	vec3 from=vec3(1.,.5,0.5);
	from+=vec3(time*2.,time,-2.);
	from.xz*=rot1;
	from.xy*=rot2;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	vec3 col = v*.01;
	if(col.x+col.y+col.z<0.6)col = vec3(0.0,0.,1.);
	gl_FragColor = vec4(v*.04,1.);	
	
}