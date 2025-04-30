Shader "Unlit/easy cel shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                half3 lightDir : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.lightDir = normalize(ObjSpaceLightDir(v.vertex));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                
                float3 norm = normalize(i.normal);
                float3 lightDir = normalize(i.lightDir);
                float diff = max(dot(norm, lightDir), 0.0);
                float3 diffuse = _LightColor0.rgb * diff;

                diffuse *= step(0.3,diff);

                float3 final = ambient + diffuse;
                col.rgb *= final; 
                col.a = 1.0;
                return col;
            }
            ENDCG
        }
    }
}
