Shader "Unlit/SampleShader"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        //LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            // Mesh Data: Position, Vertex Color, Tangent, UVs, Normal
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                //float2 uv : TEXCOORD0;
            };
            
            struct VertexOutput
            {
                //float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float4 frag (VertexOutput i) : SV_Target
            {
                //// sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                //// apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //return col;
                float2 uv = i.uv0;
                float3 lightDir = normalize(float3(1, 1, 1));
                //float3 normals = i.normal * 0.5 + 0.5;
                float simpleLight = dot(lightDir, i.normal);
                float3 lightColor = float3(0.1, 0.2, 0.7);
                return float4(lightColor * simpleLight, 0);
            }
            ENDCG
        }
    }
}
