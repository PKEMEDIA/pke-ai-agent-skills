# Automated Pair Scoring for Curriculum-DPO (NSFW / Anatomy)

**Goal**: Reduce manual curation effort when building winning/losing preference pairs for Curriculum-DPO training by using automated scoring + prompt perturbation.

## Recommended Hybrid Approach (Best Balance for COVICEA Work)

### 1. Generation Phase (local-nsfw-comfyui)
- Use your current best locked stack (`covicea-core` + `covicea-face-lock` TIES + `covicea-realistic-hair-skin-lighting` + anatomy/style LoRAs).
- Generate 8–16 images per prompt with:
  - Varied seeds
  - CFG range 5–9
  - Clean prompt + deliberately degraded versions (mask/remove key anatomy, lighting, or identity tokens)

### 2. Scoring Phase (Automated)
Use a **hybrid scorer**:

**Primary (Aesthetic + Alignment)**:
- PickScore or HPSv3++ (strong general preference prediction)

**Secondary (Anatomy/Skin focused)**:
- Fine-tune a lightweight head on top of CLIP ViT-H/14 or SigLIP using your own previous winning/losing pairs.
- Focus training signal on: hand quality, genitalia coherence, skin pores + subsurface scattering, oil physics, identity consistency under intensity.

**Scoring Formula Example**:
```
final_score = 0.6 * aesthetic_reward + 0.4 * anatomy_skin_custom_score
```

### 3. Pair Construction
For each prompt group:
- Highest final_score (clean prompt) → **Winning**
- Lowest final_score (degraded or known failure) → **Losing**

**Difficulty Tagging** (for Curriculum stages):
- Easy: Large score gap + framing differences
- Medium: Moderate gap + anatomy/proportion issues
- Hard: Small gap between high-quality images + fine skin/physics failures

### 4. Export to OneTrainer
- Use OneTrainer’s built-in **DPO Pair Tool** (supports ComfyUI metadata).
- Organize output into three datasets/folders matching Easy / Medium / Hard stages.
- The tool can export ready-to-train `chosen/` and `rejected/` folders with captions.

## Lightweight Anatomy/Skin Reward Model Tips

- Start with PickScore or HPSv3++ as base.
- Fine-tune only a small MLP head (very cheap) on 500–2000 of your own pairs.
- Training signal priorities (in order):
  1. Hand/finger coherence
  2. Genitalia anatomical accuracy
  3. Skin texture (pores, sheen, SSS)
  4. Identity preservation under erotic intensity
  5. Oil physics / glistening behavior
- Store the reward model next to your LoRAs for reuse across multiple Curriculum-DPO runs.

## OneTrainer + ComfyUI Recommended Workflow

1. Generate batch in ComfyUI with your locked stack + varied parameters.
2. Run scoring script (or OneTrainer DPO Pair Tool + custom scorer).
3. Import scored pairs into OneTrainer.
4. Train Curriculum-DPO in staged fashion (carry checkpoint forward).
5. Merge final DPO LoRA with DARE-TIES.

This pipeline can generate hundreds of high-quality, phenotype-specific pairs with only light human spot-checking on the hardest examples.

---

**Integration Note**: This reference is designed to work directly with `references/curriculum-dpo-nsfw.md` and the self-healing detection rules in the orchestrator. When recurring anatomy/skin failures are detected, the system can now recommend running this automated pair scoring workflow before launching a new Curriculum-DPO training pass.