Shader "Unlit/RainbowBroad" {
    Properties {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _SecondaryColor ("Secondary Color", Color) = (0,0,0,1)
        _CellSize ("Cell Size", Range(1,50)) = 10
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 pos : SV_POSITION;
            };

            float4x4 _WorldViewProjection;

            v2f vert (appdata v) {
                v2f o;
                o.pos = mul (_WorldViewProjection, v.vertex);
                return o;
            }

            fixed4 _MainColor;
            fixed4 _SecondaryColor;
            float _CellSize;

            float4 frag (v2f i) : SV_Target {
                float2 uv = i.pos.xy / _CellSize;
                uv = floor(uv);

                if (abs(frac(uv.x) - frac(uv.y)) < 0.05 || abs(frac(uv.x + 1) - frac(uv.y + 1)) < 0.05) {
                    return _MainColor;
                }
                else {
                    return _SecondaryColor;
                }
            }
            ENDCG
        }
    }
}