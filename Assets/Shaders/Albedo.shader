Shader "Lesson/1" // This section allows for easy sorting of our shaders in the shader menu
{
    Properties // are the public properties seen on a material
	{
		_Texture("Texture", 2D) = "black"{} // Variable name is _Texture. Display name is Texture. Texture type is 2D. Standard untextured colour is black.
	}
	
	SubShader // Multiple subshaders can exist in a shader, they run at different GPU levels on different platforms
	{
		Tags
		{
			// Shaders are basically key-value pairs. Inside a SubShader, tags are used to determine the rendering order and other parameters of a subshader.
			"RenderType" = "Opaque" // The RenderType tag categorises shaders into several predefined groups
		}
		CGPROGRAM // This is the start of our C for Graphics Language
		#pragma surface MainColour Lambert // the surface of our model is affected by the mainColour function. The material type is Lambert, which is a flat material with no highlights
		
		sampler2D _Texture; // This connects our _Texture Variable in the Properties section to our 2D _Texture variable in CG



		struct Input
		{
			float2 uv_Texture; // This is in reference to the UV map of our model. UV maps are wrappings of a model. The letters 'U' and 'V' denote the texture's 2D axes because X, Y and Z are used to denote the axes of the 3D object in model space
		};
		void MainColour(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_Texture, IN.uv_Texture).rgb; // Albedo references the surface image and RGB of our model. RGB refers to red, green and blue and is used for colours. We are setting the model's surface to the colour of our Texture2D and matching the Texture to our model's UV mapping
		}
		ENDCG // This is the end of our C for Graphics Language
	}
	FallBack "Diffuse" // if all else fails, use standard shader (Lambert and Texture)
}
