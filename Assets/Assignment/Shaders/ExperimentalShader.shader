Shader "Custom/ExperimentalShader"
{
    /* / Properties section for variables that need to be altered based on the material
	Properties
	{
		_Color("Color", Color) = (0.5, 0.65, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}

		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)

		[HDR]
		_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		_Glossiness("Glossiness", Float) = 32

		// Light rim
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
	}
	*/
	
	SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
		struct Input
		{
			float4 color : COLOR;
		};

		/*
		void vert()
		{
			
		}
		*/

        void surf (Input IN, inout SurfaceOutput o)
		{
          //o.Albedo = 1;
		  
		}
        ENDCG
    }
    FallBack "Diffuse"
}
