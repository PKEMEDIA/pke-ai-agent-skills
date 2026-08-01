# PKE Face Lock Base Workflow

Load `pke-face-lock-base.json` in ComfyUI after installing custom nodes via `bash custom`.

## Required custom nodes

- IP-Adapter Plus (FaceID)
- ControlNet Aux (OpenPose preprocessor)
- Impact Pack (FaceDetailer)
- Advanced ControlNet (optional enhance)
- pke-aleah-nodes (prompt locks)

## Models

| Path | File |
| --- | --- |
| models/checkpoints/ | juggernautXL_v9.safetensors (or your XL) |
| models/ipadapter/ | FaceID Plus V2 |
| models/controlnet/ | controlnet-openpose-sdxl.safetensors |

## Order

1. Face lock identity
2. Optional black mask
3. Title seal only: PKE PRESENTS / A PKE PRODUCTION

FaceID = WHO · OpenPose = WHERE
