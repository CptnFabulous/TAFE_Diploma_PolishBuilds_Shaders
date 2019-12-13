// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyFirstShader"
{
    // The properties section is used to declare variables that can be altered in the Inspector depending on the shader
	Properties
	{
		_Tint ("Tint", Color) = (1, 1, 1, 1)
	}
	
	
	// Subshaders are used to specify different shader variants in a single file, e.g. to have different shader variants for different platforms like desktop vs. mobile.
	// We only need one subshader for this script, however
	SubShader
	{
		// A shader pass is the function where the object is actually rendered. Some shaders will have multiple passes to render a lot of different effects.
		Pass
		{
			CGPROGRAM // Specifies the start of the code in the shader pass
			/*
			Each shader consists of two programs, a vertex (vert) program and a fragment (frag) program.
			A vertex program processes the vertex data of a mesh, and converts it from object space to display space.
			A fragment program is used to colour pixels inside the mesh's triangles.
			*/

			// The #pragma directive is used to tell the shader which programs to use
			#pragma vertex MyVertexProgram // Use MyVertexProgram for vertex rendering
			#pragma fragment MyFragmentProgram // Use MyFragmentProgram for fragment rendering



			/*
			The #include directive is used to easily reference code from other shaders, to work off of. This code is copied into the shader file automatically when compiling.
			We're including UnityCG.cginc because it's bundled with Unity and contains several essential files and generic functionality, listed below
			UnityShaderVariables.cginc defines many variables that are necessary for rendering, such as transform, camera and light data, which are specified by Unity when needed.
			HLSLSupport.cginc standardises data types allowing the same shader code to work on multiple platforms
			UnityInstancing.cginc is used for instancing support, a technique to reduce draw calls and improve performance.
			*/
			#include "UnityCG.cginc"



			// Variables defined in Properties must also be declared here, by the exact name and with the appropriate variable type designation
			float4 _Tint;



			// There are different types of programs, the same as with regular C# functions, e.g. void, float, float4, etc.

			// As we are using this program to output the position of the vertex, we need to attach the SV_POSITION semantic to it (sort of like how you derive a class from another class in C#)
			// First, the program obtains an actual vertex position value. It does this by declaring a float4 parameter, then adding the POSITION semantic
			float4 MyVertexProgram (float4 position : POSITION) : SV_POSITION
			{
				//return position; // Returns a raw object space position value. This needs to be converted into a screen position value, otherwise it will appear as an unmoving shape on screen.
				return UnityObjectToClipPos(position); // Converts coordinates from object to screen position
				//return mul(UNITY_MATRIX_MVP, position); // Alternate method, presumably outdated
			}

			/*
			Shader programs can have parameters in them, the same as C# functions
			The output of the vertex program is used as input for the fragment program. Therefore the fragment program should have a parameter variable that matches the shader program's output type.
			Since we want to reference MyVertexProgram with this parameter, which has the SV_POSITION semantic, we need to add the appropriate semantic after the parameter in MyFragmentProgram.
			We are outputting a local position, we only need 3 values so .
			*/
			float4 MyFragmentProgram (float4 position : SV_POSITION/*, out float3 localPosition : TEXCOORD0*/) : SV_TARGET // SV_TARGET is the default shader target. This is the frame buffer, which contains the image that we are generating.
			{
				// return 0; // Returns black
				//return float4(1, 1, 0, 1); // Returns yellow
				//return 0.1 * _Time.y; // Returns colour that slowly shifts over time but stays, this function is broken
				return _Tint; // Returns user-defined _Tint colour variable



				// You would expect the A value being a zero would result in a completely transparent and invisible shape, but this shader does not presently support transparency.
				
			}

			ENDCG // Specifies the end of the code in the shader pass
		}
	}
}
