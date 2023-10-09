Shader "Origin Shader/Unlit"
{
    Properties{}
    SubShader{
      
        Pass{
            //使用HLSL
            HLSLPROGRAM
            //顶点程序和片段程序函数 放在.hlsl文件中
    //对于顶点着色器程序与片元着色器程序的program指令
    #program vertex UnlitPassVertex
    #program fragment UnlitPassFragment
    $include "Unlit.hlsl"

ENDHLSL
            ENDHLSL
        }
    }
    
}
