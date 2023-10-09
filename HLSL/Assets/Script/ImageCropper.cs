using System.Collections;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
public class ImageCropper :MonoBehaviour
{
    private static ImageCropper s_instance;
    public static ImageCropper GetInstance()
    {
        return s_instance;
    }
    // 原始图片
    private Texture2D sourceImage;
    // public Rect cropRect; // 裁剪矩形
    public Image targetImage;
    [SerializeField]
    Image rectImage;
    [SerializeField]
    Canvas canvas;
    // public float scaleRatio = 0.5f;
    private void Awake()
    {
        s_instance = this;
    }

    private void Start()
    {
        sourceImage = targetImage.sprite.texture;
        // string path = AssetDatabase.GetAssetPath (targetImage.GetInstanceID ());
        // TextureImporter importer = (TextureImporter)AssetImporter.GetAtPath(path); // 获取文件
        // importer.isReadable = true;
    }
    /// <summary>
    /// 点击按钮
    /// </summary>
    public void onCLickButton(int tf)
    {
        // targetImage.SetNativeSize();
        switch (tf)
        {
            case 0:
                ZoomImage(375, 812);
                break;
            case 1:
                ZoomImage(1, 1);
                break;
            case 2:
                // xx = (16 / 9)*(sourceImage.sprite.rect.height/sourceImage.sprite.rect.width);
                //ScaleImage(xx);
                ZoomImage(16, 9);
                break;

            case 3:
                ZoomImage(3, 4);
                break;
        }
    }

    /// <summary>
    /// 缩放图片
    /// </summary>
    /// <param name="image"></param>
    /// <param name="destHeight"></param>
    /// <param name="destWidth"></param>
    public void ZoomImage(float width, float height)
    {
        targetImage.SetNativeSize();
        float originalWidth = sourceImage.width;
        float originalHeight = sourceImage.height;
        // 计算目标宽度和高度
        int targetHeight = (int)(originalWidth * (height / width));
        int targetWidth = (int)(originalHeight * (width / height));
        //Texture2D sourceImage;  // 原始的Texture2D
        // int targetWidth;  // 新的宽度
        // int targetHeight;  // 新的高度

        Debug.LogFormat("宽度---{0}---高度--{1}---", targetWidth, targetHeight);
        // 创建一个新的Texture2D，并设置新的宽高
        Texture2D resizedTexture = new Texture2D(targetWidth, targetHeight);

        // 将原始Texture的像素数据复制到新的Texture中
        for (int y = 0; y < targetHeight; y++)
        {
            for (int x = 0; x < targetWidth; x++)
            {
                // 计算原始Texture中对应的像素坐标
                int originalX = Mathf.FloorToInt((float)x / targetWidth * sourceImage.width);
                int originalY = Mathf.FloorToInt((float)y / targetHeight * sourceImage.height);

                // 获取原始Texture的像素颜色
                Color pixelColor = sourceImage.GetPixel(originalX, originalY);
                // 将像素颜色设置到新的Texture中
                resizedTexture.SetPixel(x, y, pixelColor);
            }
        }

        // 应用到新的Texture创建新的纹理数据
        resizedTexture.Apply();
        //复制到image
        CopyTextureToImage(resizedTexture);
        CaptureScreen();
        
    }

    private void CaptureScreen() 
    {
        StartCoroutine(CaptureScreenTest());
    }
    public void CopyTextureToImage(Texture2D img)
    {
        // 创建一个新的Sprite来存储Texture的内容
        Sprite sprite = Sprite.Create((Texture2D)img, new Rect(0, 0, img.width, img.height), Vector2.zero);
        targetImage.sprite = sprite;
        // 将新的Sprite设置给目标Image组件
        targetImage.rectTransform.sizeDelta = new Vector2(img.width, img.height);
    }
    
    IEnumerator CaptureScreenTest()
    {
        //等待渲染完成
        yield return new WaitForEndOfFrame();
        RectTransform tag = rectImage.GetComponent<RectTransform>();
        // 计算出这个物体在屏幕的宽度（因为画布是经过缩放的，所以用实际宽度* 画布的缩放率）
        int w = (int)(tag.rect.width * canvas.scaleFactor);
        int h = (int)(tag.rect.height * canvas.scaleFactor);
        Texture2D tex = new Texture2D((int)w, (int)h, TextureFormat.RGB24, false);
        float _x= rectImage.transform.position.x + tag.rect.xMin;
        float _y = rectImage.transform.position.y + tag.rect.yMin;
        //用新建立的Texture2D，读取屏幕像素。
        tex.ReadPixels(new Rect(_x, _y, w, h), 0, 0);
        tex.Apply();
        //后面就是将Texture2D转换为sprinte并显示出来
        Sprite temp = Sprite.Create(tex, new Rect(0, 0, w, h), Vector2.zero);
        targetImage.sprite = temp;
        Debug.LogFormat("rectImage.sprite.rect.width{0}------------------------rectImage.sprite.rect.height{1}",rectImage.rectTransform.rect.width,rectImage.rectTransform.rect.height);
        targetImage.rectTransform.sizeDelta = new Vector2(rectImage.rectTransform.rect.width, rectImage.rectTransform.rect.height);
    }
}