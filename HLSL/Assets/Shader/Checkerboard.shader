//实现原理
//在属性中定义一个滑动密度 
//顶点着色器处理
//在顶点着色器中，网格 UV 与密度值相乘，使它们从 0 到 1 的范围变为 0 到密度的范围。设置密度设置为 30，这将使片元着色器中的 i.uv 输入包含 0 到 30 的浮点值，对应于正在渲染的网格的各个位置。
//片元着色器处理
//片元着色器代码仅使用 HLSL 的内置 floor 函数获取输入坐标的整数部分，并将其除以 2。回想一下，输入坐标是从 0 到 30 的数字；这使得它们都被“量化”为 0、0.5、1、1.5、2、2.5 等等的值。输入坐标的 x 和 y 分量都完成了此操作。
//颜色输出
//我们将这些 x 和 y 坐标相加（每个坐标的可能值只有 0、0.5、1、1.5 等等），并且只使用另一个内置的 HLSL 函数 frac 来获取小数部分。结果只能是 0.0 或 0.5。然后，我们将它乘以 2 使其为 0.0 或 1.0，并输出为颜色（这分别产生黑色或白色）。
Shader "Unlit/Checkerboard"
{
    Properties
    {
        //定义滑动密度
        _Density("滑动密度",Range(2,50)) = 30
        //颜色值
        _MainColor("位于棋盘格位置的颜色",Color) = (1,1,1,1)
        //
        _SecondaryColor("不在棋盘格位置的颜色",Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //定义密度
            float _Density;
            //主纹理
            sampler2D _MainTex;
            fixed4 _MainColor;
            fixed4 _SecondaryColor;
            //主要纹理的平铺信息
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                //顶点 从模型空间转换到裁剪空间
                o.vertex = UnityObjectToClipPos(v.vertex);
                //将UV坐标乘密度
                o.uv = v.uv * _Density;


                //TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
        fixed4 frag (v2f i) : SV_Target
        {
                float2 uv = i.uv;
                float2 cellPosition = floor(uv);

                // 使用Perlin噪声生成随机值作为颜色索引
                float noise = frac(sin(dot(cellPosition, float2(12.9898, 78.233))) * 43758.5453);
                int colorIndex = int(noise * 6);

                fixed4 color;

                if (colorIndex == 0)       // 赤色
                    color = fixed4(1, 0, 0, 1);
                else if (colorIndex == 1)  // 橙色
                    color = fixed4(1, 0.5, 0, 1);
                else if (colorIndex == 2)  // 红色
                    color = fixed4(1, 0, 0, 1);
                else if (colorIndex == 3)  // 绿色
                    color = fixed4(0, 1, 0, 1);
                else if (colorIndex == 4)  // 蓝色
                    color = fixed4(0, 0, 1, 1);
                else                       // 紫色
                    color = fixed4(0.5, 0, 0.5, 1);

                return color;
        }

            // fixed4 frag(v2f i) : SV_Target
            // {
            //     float2 uv = floor(i.uv);
            //     bool isEven = ((int)uv.x + (int)uv.y) % 2 == 0;
            //     fixed4 color = isEven ? _MainColor : _SecondaryColor;
            //     return color;
            //     // //获取目标输入的整数部分 
            //     // float2 c = i.uv;
            //     // //获取UV整数部分除以2 这里除以2 相当于颜色值  只取白 还有黑色 
            //     // c = floor(c)/2;
            //     //
            //     // // float col;
            //     // //
            //     // // //在棋盘格第一种颜色 不在棋盘格子 第二种颜色
            //     // //
            //     // // if(abs(frac(i.uv.x-i.uv.y))<0.05||abs(frac(i.uv.x+1)-frac(i.uv.y+1))<=0.05)
            //     // // {
            //     // //     // col = _MainColor*c;
            //     // //     // return 
            //     // //     return _MainColor*(frac(c.x+c.y)*2);
            //     // // }
            //     // // else
            //     // // {
            //     // //     return _SecondaryColor;
            //     // // }
            //     // // //获取小数部分 只能是0 或者0.5
            //     // float col = frac(c.x+c.y)*2;
            //     // return col;
            // }
            ENDCG
        }
    }
}