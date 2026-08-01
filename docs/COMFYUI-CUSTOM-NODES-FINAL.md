# ComfyUI Custom Nodes — FINAL (Aleah)

## Status

**FINALIZED 2026-08-01** · Injector v2.1 · verify STATUS=HEALTHY · free-tier safe

## On your computer

```bash
cd /path/to/ComfyUI
# Clone or pull PKEMEDIA/comfyui, then:
bash /path/to/PKEMEDIA/comfyui/custom --root "$(pwd)"
# Fully restart ComfyUI
# Load: pke-ai-agent-skills/comfyui/pke-face-lock-base.json
```

Or download the full offline pack from Aleah Empire OS → **Nodes → Download pack for your computer**
(`pke-aleah-comfyui-final.zip` includes vendored node sources).

## Injected

| Pack | Role |
| --- | --- |
| ComfyUI-Manager | Core manager |
| Impact Pack | FaceDetailer |
| WAS Suite | Utilities |
| IP-Adapter Plus | FaceID WHO |
| ControlNet Aux | OpenPose WHERE |
| Advanced ControlNet | Apply path |
| AnimateDiff Evolved | Video optional |
| Video Helper Suite | Video optional |
| Lumi Batcher | Batch optional |
| **pke-aleah-nodes** | Brand + credit guard |

## Native Aleah classes

- PKEFaceLockPrompt
- PKEMaskLockPrompt
- PKETitleSeal
- PKECreditGuard
- PKEGenOrderNote

## Verify

```bash
python3 /path/to/comfyui-pack/scripts/verify_inject.py --root /path/to/ComfyUI
# STATUS=HEALTHY
```

## Credit rules

- Inject = git/vendor only · Imagine calls = 0
- GPU renders = local ComfyUI
- Never call Imagine from learn/heal loops
