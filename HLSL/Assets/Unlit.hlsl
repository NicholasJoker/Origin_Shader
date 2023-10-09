#ifndef MY_UNLIT_INCLUDED
#define MY_UNLIT_INCLUDED
#endif
#include "Packages/ com.unity.render-pipelines.core/ ShaderLibrary / Common.hlsl"
//定义顶点的输入输出结构
struct VertexInput{
    float4 pos:POSITION;
};
struct VertexOutput{
    float4 clipPos:SV_POSITION;
};
//M矩阵 与VP矩阵放到缓冲区
// cbuffer UnityPerFrame{
//     float4x4 unity_MatrixVP;
// };
// cbuffer UnityPerDraw{}

CBUFFER_START(UnityPerFrame)
    float4x4 unity_MatrixVP;
CBUFFER_END

CBUFFER_START(UnityPerDraw)
    float4x4 unity_ObjectToWorld;
CBUFFER_END

//模型矩阵转换到世界空间
float4x4 unity_ObjectToWorld;
//视图投影矩阵
float4x4 unity_MatrixVP;
//空间转换 定义一个顶点函数程序 直接用对象空间的顶点位置作为剪辑空间的位置(后续将添加正确的空间转换)
VertexOutput UnlitPassVertex(VertexInput input){
    VertexOutput output;
    //转换模型对象空间转换到世界空间
    float4 worldPos = mul(unity_ObjectToWorld,float4(input.pos.xyz,1.0));
    // output.clipPos = worldPos;
    //世界空间转换到剪辑空间 通过视图投影矩阵完成
    output.clipPos = mul(unity_MatrixVP,worldPos);
    return output;
}
float4 UnlitPassFragment(VertexOutput input):SV_TARGET{
    return 1;
}




