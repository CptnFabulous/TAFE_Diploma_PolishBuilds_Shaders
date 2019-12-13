Shader "Custom/Fog" // This section allows for easy sorting of our shaders in the shader menu
{
    Properties // are the public properties seen on a material
	{
		_Texture("Texture", 2D) = "black"{} // Variable name is _Texture. Display name is Texture. Texture type is 2D. Standard untextured colour is black.
		_NormalMap("Normal", 2D) = "bump"{} // Uses an rgb colour value to create xyz depth to the material. The 'bump' variable tells Unity this material neds to be marked as a normal map, so it can be used correctly.
		_Colour("Tint", Color)=(0,0,0,0) // RGBA value for Tint
		_FogColour("Fog Colour", Color)=(0,0,0,0) // RGBA value for fog colour
	}
	
	SubShader // Multiple subshaders can exist in a shader, they run at different GPU levels on different platforms
	{
		Tags
		{
			// Shaders are basically key-value pairs. Inside a SubShader, tags are used to determine the rendering order and other parameters of a subshader.
			"RenderType" = "Transparent" "IgnoreProjector"="True" "Queue"="Transparent" // The RenderType tag categorises shaders into several predefined groups
		}
		CGPROGRAM // This is the start of our C for Graphics Language
		#pragma surface MainColour Lambert alpha finalcolor:FogColour vertex:Vert // the surface of our model is affected by the mainColour function. The material type is Lambert, which is a flat material with no highlights
		
		sampler2D _Texture; // This connects our _Texture Variable in the Properties section to our 2D _Texture variable in CG
		sampler2D _NormalMap; // Connects out _NormalMap variable from Properties to the _NormalMap Variable in CG
		fixed4 _Colour; // reference to the input _Colour in the Properties section, fixed4 refers to 4 small decimals and is being used to store an RGBA value.
		fixed4 _FogColour; // reference to the input _FogColour in the Properties section, fixed4 refers to 4 small decimals and is being used to store an RGBA value.



		/*
		High precision: float = 32 bits
		Medium precision: half = 16 bits, range = -60000 to +60000
		Low precision: fixed = 11 bits, range = -2.0 to +2.0
		*/


		struct Input
		{
			float2 uv_Texture; // This is in reference to the UV map of our model. UV maps are wrappings of a model. The letters 'U' and 'V' denote the texture's 2D axes because X, Y and Z are used to denote the axes of the 3D object in model space
			float2 uv_NormalMap; // UV map link to the _NormalMap image
			half fog;
		};

		void Vert(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);
			float4 hpos = UnityObjectToClipPos(v.vertex);
			hpos.xy /= hpos.w;
			data.fog = min(1, dot(hpos.xy, hpos.xy) * 0.5);
		}

		void FogColour(Input IN, SurfaceOutput o, inout fixed4 colour)
		{
			fixed3 fogColour = _FogColour.rgb;
			
			#ifdef UNITY_PASS_FORWARDADD

			fogColour = 0;
			#endif
			colour.rgb = lerp(colour.rgb, fogColour, IN.fog);
		}

		void MainColour(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_Texture, IN.uv_Texture).rgb * _Colour; // Albedo references the surface image and RGB of our model. RGB refers to red, green and blue and is used for colours. We are setting the model's surface to the colour of our Texture2D and matching the Texture to our model's UV mapping
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)); // Normal map is in reference to the bump map in Properties. UnpackNormal is required because the file is compressed. We need to decompress and get the true value from the Image. Bump maps are visibla when light reflects off. The light is bounced off at angles according to the images RGB or XYZ values. This creates the illusion of depth.
			o.Alpha = lerp(_Colour.a, _FogColour.a, IN.fog); // Alters transparency DOES NOT WORK
		}
		ENDCG // This is the end of our C for Graphics Language
	}
	FallBack "Diffuse" // if all else fails, use standard shader (Lambert and Texture)
}
