# pke-face-lock-base.json

ComfyUI workflow for official PKE company face (skill: `pke-face-lock`).

## Model folders (from setup table)

| Folder | File you provide |
| --- | --- |
| `models/checkpoints/` | e.g. `juggernautXL_v9.safetensors` or Flux fine-tune |
| `models/ipadapter/` | FaceID Plus V2 (or InstantID stack) |
| `models/controlnet/` | OpenPose SDXL/Flux-matched |
| `models/loras/` | optional character/skin |
| `models/vae/` | only if not baked into checkpoint |

## Input images

Copy from Brand app assets:

- Face ref (required): `public/pke/IMG_4441.jpg` → Comfy input as `pke_face_ref_IMG_4441.jpg`
- Optional pose ref: any clean full-body / half-body pose still as `pke_pose_ref.png`

## FaceID vs OpenPose (do not mix roles)

| System | Answers | Controls | Typical strength |
| --- | --- | --- | --- |
| **FaceID / InstantID** | *Who* is this? | Face identity, freckles, eyes, braids | 0.75–0.90 |
| **OpenPose** | *Where* do limbs sit? | Skeleton pose only | 0.80–1.0 |

- FaceID does **not** set pose.
- OpenPose does **not** lock freckles/eyes/hair color.
- If identity drifts: raise FaceID, check face ref quality.
- If pose collapses: raise OpenPose or fix pose ref; do not crank FaceID for pose.

## Run order

1. Install custom nodes (IPAdapter_plus, InstantID optional, controlnet_aux, Impact Pack).
2. Drop models into folders above; rename widgets in graph to match filenames.
3. Load this JSON in ComfyUI (Load → select file).
4. Queue prompt. Save path prefix: `pke/face_lock_base`.
5. For mask/title cards: duplicate graph, add mask prompt block from `pke-official-black-mask`, keep same FaceID ref.

## Sampler defaults

- Steps 30, CFG 6, dpmpp_2m + karras
- Latent 832×1216 (~9:16)
- Change **one** variable per batch (seed *or* pose *or* crop)

## Pairing skills

1. `pke-face-lock` (this workflow)
2. `pke-official-black-mask` when mask worn
3. Title seals: **PKE PRESENTS** / **A PKE PRODUCTION**
