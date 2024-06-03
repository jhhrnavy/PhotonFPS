Shader "Custom/RimShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RimDensity("Rim Density", Range(0,10)) = 3
        _RimColor("Rim Color",Color) = (1,1,1,1)

        _BumpMap("Normal Map", 2D) = "bump"{}
        //_BumpRate("Normal Rate", Range(0,1)) = 0.5
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Lambert noambient

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _BumpMap;

            struct Input
            {
                float2 uv_MainTex;
                float3 viewDir;

                float2 uv_BumpMap;
            };

            half _RimDensity;
            fixed4 _RimColor;
            fixed4 _Color;

            fixed _BumpRate;

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

                fixed4 n = tex2D(_BumpMap, IN.uv_BumpMap);
                fixed3 Normal = UnpackNormal(n);

                //if (_BumpRate >= 0.01)
                    //o.Normal = float3(Normal.x * _BumpRate, Normal.y * _BumpRate, Normal.z);

                float rim = saturate(dot(o.Normal, IN.viewDir));
                rim = pow(1 - rim, _RimDensity);

                //o.Emission = rim * _RimColor.rgb * abs(sin(_Time.y * 3)) + c.rgb; // * abs(sin(_Time.y * 5)) ∏≤∂Û¿Ã∆Æ ±Ù∫˝¿”
                o.Emission = rim * _RimColor.rgb + c.rgb;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
