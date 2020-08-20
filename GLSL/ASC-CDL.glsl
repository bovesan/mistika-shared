#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2DRect image;

//Param 1 = Slope
//Nominal Value = 1
uniform vec3 param1;

//Param 2 = Offset
//Nominal Value = 0
uniform vec3 param2;

//Param 3 = Power
//Nominal Value = 1
uniform vec3 param3;

//Param 4 = Saturation ??
//Nominal Value = 1

uniform vec3 param4;

//Param 5 = Un-used
uniform vec3 param5;

//Formula : output = POW ((input*slope + offset),power)

void main()
{
	vec4 input = texture2DRect(image, gl_TexCoord[0].xy);

// CDL Calculation

	float cdl_r = pow(((input.r * param1.x) + param2.x), param3.x); 
	float cdl_g = pow(((input.g * param1.y) + param2.y), param3.y); 
	float cdl_b = pow(((input.b * param1.z) + param2.z), param3.z); 


//Calculating VIDEO LUMA using Rec 709 coeficients : Y = 0.2126 R + 0.7152 G + 0.0722 B
//http://en.wikipedia.org/wiki/Luma_%28video%29
//http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color

	float luma = cdl_r * 0.2126 + cdl_g * 0.7152 + cdl_b * 0.0722;
    
//Calculating VIDEO CHROMA = Not 100% sure about this formula to represent saturation ????
//output = (input * sat) + luma * (1.0 - sat) 

	float out_r = (cdl_r * param4.x) + luma * (1.0 - param4.x);
	float out_g = (cdl_g * param4.x) + luma * (1.0 - param4.x);
	float out_b = (cdl_b * param4.x) + luma * (1.0 - param4.x);

//Maintain original alpha

	float out_a = input.a;

    gl_FragColor = vec4(out_r, out_g, out_b, out_a);
}
