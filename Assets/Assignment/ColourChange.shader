Shader "Custom/ColourChange"
{
    Properties
    {
        //_Intensity ("Intensity", float) = 1
		_TransitionTime ("Transition Time", float) = 3
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

		
        half _Glossiness;
        half _Metallic;
        //fixed4 _Color;
		//float _Intensity;
		float _TransitionTime;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
			float progress = frac(_Time.y * (1 / _TransitionTime)); // progress will always be a value between zero and 1, specifying how far the transition has progressed
			float red = 1;
			float green = 1;
			float blue = 1;

			float segment = 1.0f / 3.0f;

			if (progress <= segment) // 1/3
			{
				float v = progress; // Value is between 0 and 1/3
				float p = v * 3;

				red = lerp(0, 1, 1 - p);
				green = lerp(0, 1, p);
				blue = 0;
			}
			else if (progress > segment && progress <= segment * 2) // 1/3 finished, 2/3 still going
			{
				float v = progress - segment; // Value is above 1/3, has 1/3 taken away so it is between 0 and 1/3
				float p = v * 3;

				red = 0;
				green = lerp(0, 1, 1 - p);
				blue = lerp(0, 1, p);
			}
			else if (progress > segment * 2) // 2/3 finished, 3/3 still going
			{
				float v = progress - segment * 2; // Value is above 2/3, has 2/3 taken away so it is between 0 and 1/3
				float p = v * 3;

				red = lerp(0, 1, p);
				green = 0;
				blue = lerp(0, 1, 1 - p);
			}

			float4 colour = float4(red, green, blue, 1);
			
			/*
			// This version is cleaner and apparently better for performance, but I don't really understand how it works, someone on the internet gave it to me
			float red   = sin(_Time.y) + 1.0f / 2.0f;
			float green = sin(_Time.y * 2.0f) + 1.0f / 2.0f;
			float blue  = sin(_Time.y * 3.0f) + 1.0f / 2.0f;
			float4 colour = float4(red, green, blue, 1);
			*/

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * colour;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
