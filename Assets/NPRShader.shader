//https://celestialbody.tistory.com/15?category=762154
Shader "Custom/NPRShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Outline ("Outline",Range(0,0.1)) = 0.01
        _ShadeLevel("명암단계",Range(0,100)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        cull front
        //---1Pass
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert noshadow
        #pragma target 3.0

        sampler2D _MainTex;
        float _Outline;

        struct Input
        {
            float4 color:COLOR;
        };

        void vert(inout appdata_full v)
        {
            v.vertex.xyz = v.vertex.xyz + v.normal * _Outline;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
        }

        float Lightingno(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 1);
        }

        ENDCG

        //--2Pass

        cull back
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _ShadeLevel;


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

        //float4 Lightingcell(SurfaceOutput s, float3 lightDir, float atten)
        //{
        //    float ndotl = dot(normalize(s.Normal), normalize(lightDir)) * 0.5 + 0.5;
        //    ndotl = ndotl * ndotl * ndotl;

        //    ndotl = ceil(ndotl * _ShadeLevel) / _ShadeLevel;

        //    return ndotl;
        //}

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            //o.Albedo = c.rgb;
            o.Albedo = ceil(c.rgb * _ShadeLevel) / _ShadeLevel;;
            o.Alpha = c.a;
        }



        ENDCG

    }
    FallBack "Diffuse"
}
