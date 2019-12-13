using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
[AddComponentMenu("Image Effects/NightVisionGoggles")]
public class NightVisionGoggles : MonoBehaviour
{
    #region Public Variables
    public Color tint = Color.green;
    public Vector2 fuzz = new Vector2(0.005f, 0.005f);
    public float contrast = 1;
    #endregion

    #region Private Variables
    [SerializeField]
    Shader _shader;
    Material _material;
    #endregion

    #region MonoBehaviour Functions
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }
        
        // Apply values here. Any calculations that need to be done using Unity's variables can be done here.
        _material.SetVector("_ColourTint", tint);
        _material.SetVector("_Fuzz", fuzz);
        _material.SetFloat("_Contrast", contrast);

        Graphics.Blit(source, destination, _material);
    }
    #endregion
}
