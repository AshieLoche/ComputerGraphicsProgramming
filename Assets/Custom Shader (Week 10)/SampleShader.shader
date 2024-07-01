Shader"Unlit/SampleShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 0)
        _Gloss("Gloss", float) = 1
        _LightFallOffController("LightFallOffController", Range(0.1, 1.0)) = 0.5
        _SpecularFallOffController("SpecularFallOffController", Range(0.1, 1.0)) = 0.1
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            // Mesh Data: Position, Vertex Color, Tangent, UVs, Normal
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                float3 worldPos: TEXCOORD1;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;
            float4 _Color;
            float _Gloss;
            float _LightFallOffController;
            float _SpecularFallOffController;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (VertexOutput o) : SV_Target
            {
                float2 uv = o.uv0;
                float3 normal = normalize(o.normal);
    
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb;
    
                float lightFallOff = max(0, dot(lightDir, normal));
                lightFallOff = step(_LightFallOffController, lightFallOff);
    
                float3 directDiffuseLight = lightColor * lightFallOff;
                
                //float3 ambientLight  = float3(0.83, 0.25, 0.47);
                float3 ambientLight = float3(0.1, 0.1, 0.1);
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - o.worldPos;
                float3 viewDir = normalize(fragToCam);
    
                float3 viewReflect = reflect(-viewDir, normal);
    
                float3 specularFallOff = max(0, dot(viewReflect, lightDir));
                specularFallOff = pow(specularFallOff, _Gloss);
                specularFallOff = step(_SpecularFallOffController, specularFallOff);
    
                float3 directSpecular = specularFallOff * lightColor;
    
                float3 diffuseLight = ambientLight + directDiffuseLight;
                float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecular;
    
                return float4(finalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}
