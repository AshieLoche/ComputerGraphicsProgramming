using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PostProcessingVolumeScript : MonoBehaviour
{
    [SerializeField] Volume volume;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Space))
        {
            if(volume.profile.TryGet<Vignette>(out Vignette vignette))
            {
                vignette.intensity.value = 0f;
                vignette.active = false;
            }
        }
    }
}
