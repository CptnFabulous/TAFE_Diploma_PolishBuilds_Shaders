Shader "Lesson/5" // This section allows for easy sorting of our shaders in the shader menu
{
    Properties // are the public properties seen on a material
	{
		_MainTex("Albedo (RGB)", 2D) = "white"{}
		_EffectAmount("Effect Amount", Range(0,1)) = 1.0
	}
	
	SubShader // Multiple subshaders can exist in a shader, they run at different GPU levels on different platforms
	{
		Tags
		{
			// Shaders are basically key-value pairs. Inside a SubShader, tags are used to determine the rendering order and other parameters of a subshader.
			"RenderType" = "Transparent" "IgnoreProjector"="True" "Queue"="Transparent" // The RenderType tag categorises shaders into several predefined groups
		}
		LOD 200
		CGPROGRAM // This is the start of our C for Graphics Language
		#pragma surface ImageTransparentGreyScale Lambert alpha
		
		sampler2D _MainTex;
		uniform float _EffectAmount;

		struct Input
		{
			float2 uv_MainTex;
		};

		void ImageTransparentGreyScale(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = lerp(c.rgb, dot(c.rgb, float3(0.3,0.59,0.11)), _EffectAmount);
			o.Alpha = c.a;
		}
		ENDCG // This is the end of our C for Graphics Language
	}
	FallBack "Transparent/VertexLit" // if all else fails, use standard shader
}
