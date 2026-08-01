# Curriculum-DPO & Curriculum-DPO++ Training Strategies for NSFW / Anatomy (COVICEA / Pretty Kitty)

**Purpose**: Provide a concrete, reusable curriculum-based DPO training workflow optimized for locked character erotic/NSFW generation. Focuses on progressive difficulty in both data (preference pairs) and model capacity to achieve superior anatomy, skin realism (PBR/SSS), and erotic fidelity while preserving the locked COVICEA phenotype.

This guide integrates directly with:
- `spicy-male-erotic-prompt-optimizer`
- `local-nsfw-comfyui` + ComfyUI workflows
- `covicea-core` + `covicea-face-lock` (TIES) + `covicea-realistic-hair-skin-lighting`
- Existing anatomy/style/character LoRAs
- DARE-TIES merging
- OneTrainer (recommended DPO trainer)

## 1. Why Curriculum-DPO for Your Work
Standard DPO treats all preference pairs equally. For NSFW/anatomy this frequently causes:
- Early overfitting to easy wins (artistic framing, basic lighting).
- Poor learning on hard failures (deformed genitalia/hands, plastic skin, identity collapse under intensity, bad oil physics).

**Curriculum-DPO** orders training from easy → hard.
**Curriculum-DPO++** adds a model-level curriculum (gradually increasing capacity).

Benefits for COVICEA locked work:
- Much stronger anatomy on your specific tan caramel skin + curly hair + hazel-green eyes phenotype.
- Better preservation of identity at high erotic intensity.
- More reliable glistening oil + visible pores + SSS/PBR behavior.
- Higher success rate when combined with the refined prompts from `spicy-male-erotic-prompt-optimizer`.

## 2. Recommended 3-Stage Curriculum (Data + Model)

### Stage 1: Easy — Artistic Framing & Legitimacy (Foundation)
**Goal**: Strongly bias the model toward well-framed, artistically legitimate erotic images.

**Preference Pair Construction** (create 80–150 pairs):
- **Winning examples**: Strong artistic framing language already emphasized in spicy skill ("fine art male study", "professional male boudoir photography", "cinematic dramatic lighting with strong negative fill", reclining or low-angle power poses, heavy glistening oil + visible skin texture/pores).
- **Losing examples**: Direct genital focus without framing, standing aggressive poses, clinical/medical language, obvious moderation artifacts, flat lighting.

**Training Settings (OneTrainer or equivalent)**:
- LoRA Rank: 16–24
- Alpha: 8–12
- Learning Rate: 8e-5 to 1e-4
- Steps: 800–1500 (or ~40–60% of total planned steps)
- Reference Model: Frozen base or early snapshot of your current character LoRA
- Batch Size: As high as VRAM allows (gradient accumulation if needed)
- Optimizer: AdamW8bit or Prodigy
- Resolution: 1024×1024 (or your target native resolution)

**Success Criteria to Move to Stage 2**:
- Clear improvement in artistic framing and prompt adherence on easy erotic prompts.
- Reduced moderation-style refusals/artifacts even on moderately spicy prompts.

### Stage 2: Medium — Core Anatomy & Proportions
**Goal**: Fix the most common anatomy failures on the locked COVICEA phenotype.

**Preference Pair Construction** (create 150–250 pairs, mix with Stage 1 data):
- **Winning**: Correct muscle origins/insertions, believable hand and genitalia rendering, natural proportions, consistent tan caramel skin tone with visible pores and subsurface scattering, proper oil sheen behavior.
- **Losing**: Deformed/extra/missing fingers, elongated or collapsed limbs, plastic/waxy skin, identity drift, broken anatomy in complex or intimate poses.

**Training Settings**:
- Increase Rank to 24–32
- Learning Rate: 6e-5 to 1e-4 (slightly lower than Stage 1 to protect earlier learning)
- Steps: Continue from Stage 1 checkpoint for another 1200–2000 steps
- Introduce some ControlNet (OpenPose + Depth) pairs where one version has correct spatial relationships and the other does not.
- Begin weighting anatomy-related tokens more heavily in winning captions.

**Success Criteria**:
- Significant reduction in hand/genitalia/proportion failures on medium-difficulty prompts.
- Identity remains stable even when anatomy is pushed.

### Stage 3: Hard — Advanced Erotic Fidelity + Skin/Physics
**Goal**: Master fine details that elevate output from "good NSFW" to exceptional locked-character work.

**Preference Pair Construction** (create 100–200 high-quality hard pairs):
- **Winning**: Rich individual skin pores + realistic glistening oil physics, accurate subsurface scattering (SSS) under dramatic lighting, proper fabric interaction with skin, dynamic and believable genitalia with correct lighting/shadows, full identity preservation at high intensity.
- **Losing**: Loss of skin detail under oil/sheen, flat or plastic appearance, identity collapse, poor oil physics, anatomical breakdown in close-ups or high-motion poses.

**Training Settings (Curriculum-DPO++ style)**:
- Rank: 32–48 (or dynamically increase rank mid-stage)
- Learning Rate: 4e-5 to 8e-5 (lower to allow fine refinement)
- Steps: Final 1500–2500 steps on the hardest pairs
- Heavily emphasize PBR/SSS lighting language and your specific phenotype descriptors in winning examples.
- Use your most difficult real failure cases (from previous generations) as losing examples.

**Success Criteria**:
- Dramatic improvement in skin realism, oil behavior, and anatomical coherence on the most challenging erotic prompts.
- Locked COVICEA identity remains rock-solid even at high intensity.

## 3. OneTrainer Recommended Settings Summary (per Stage)

| Parameter              | Stage 1 (Easy)     | Stage 2 (Medium)   | Stage 3 (Hard)      |
|------------------------|--------------------|--------------------|---------------------|
| LoRA Rank              | 16–24              | 24–32              | 32–48 (or dynamic)  |
| Alpha                  | 8–12               | 12–16              | 16–24               |
| Learning Rate          | 8e-5 – 1e-4        | 6e-5 – 1e-4        | 4e-5 – 8e-5         |
| Steps (cumulative)     | 800–1500           | +1200–2000         | +1500–2500          |
| Reference Model        | Frozen base/early  | Previous checkpoint| Previous checkpoint |
| Focus                    | Framing + legitimacy | Anatomy & proportions | Skin physics + SSS/PBR + identity under intensity |

**General Tips**:
- Always keep the Locked Character Block (from `references/locked-phenotype-templates.md`) in winning captions.
- Use gradient checkpointing + 8-bit AdamW for VRAM efficiency.
- Save checkpoints frequently and test on your hardest prompts after each stage.
- After final stage, merge the DPO LoRA with your existing stack using DARE-TIES (recommended ratios: 0.6–0.8 for the new DPO LoRA).

## Synthetic Preference Data Generation (Reducing Manual Curation)

Manual creation of high-quality winning/losing pairs is the main bottleneck for Curriculum-DPO. The following hybrid approach significantly reduces manual effort while maintaining high relevance to the locked COVICEA phenotype and anatomy/skin goals.

### Hybrid Reward Model + Prompt Perturbation Method (Recommended for COVICEA)

**Core Idea**:
Combine two complementary synthetic signals:
1. **Reward Model Scoring** — Automatically rank generations by overall quality + anatomy/skin fidelity.
2. **Prompt Perturbation** — Create controlled difficulty by degrading prompts (especially anatomy, lighting, and identity descriptors).

This produces both high-quality pairs and natural easy → hard ordering for the curriculum.

**Step-by-Step Workflow**:

1. **Batch Generation in `local-nsfw-comfyui`**:
   - Use your current best locked stack (`covicea-core` + `covicea-face-lock` TIES + `covicea-realistic-hair-skin-lighting` + existing anatomy/style LoRAs).
   - Generate 8–16 images per prompt with varied seeds, CFG (5–9), and slight prompt variations.
   - Include both clean prompts and intentionally degraded versions (remove or mask key anatomy/lighting/identity tokens).

2. **Automated Scoring**:
   - Use one or more reward models:
     - General aesthetic: PickScore, ImageReward, or HPS v2.
     - Anatomy/skin focused: Fine-tune or use a lightweight custom reward model on your previous winning/losing examples (focus on hand quality, genitalia coherence, skin pores/sheen, identity consistency).
   - Score every generated image.
   - For each prompt group, select:
     - Highest-scoring clean version → Winning
     - Lowest-scoring degraded version (or known failure modes) → Losing

3. **Difficulty Ranking for Curriculum**:
   - Easy pairs: Large score gap + simple framing differences.
   - Medium pairs: Moderate score gap + anatomy/proportion issues.
   - Hard pairs: Small score gap between high-quality images + fine skin/SSS/physics failures.

4. **OneTrainer Integration**:
   - Export the scored pairs using OneTrainer’s DPO Pair Tool (it already supports ComfyUI metadata).
   - Organize into three folders/datasets corresponding to Easy / Medium / Hard stages.
   - Train sequentially, carrying over the checkpoint from the previous stage (as described in the 3-stage settings table).

### Integrating Synthetic Pairs into Easy → Medium → Hard Stages

- **Stage 1 (Easy)**: Heavily weight prompt perturbation on framing/lighting tokens. Use reward model mainly for overall aesthetic filtering.
- **Stage 2 (Medium)**: Increase focus on anatomy/proportion failures. Mix perturbed prompts with real failure cases from previous generations.
- **Stage 3 (Hard)**: Prioritize high-scoring vs low-scoring pairs on skin physics, oil behavior, and identity under intensity. Use the most difficult real + synthetic negatives here.

This staged synthetic approach lets you generate thousands of pairs with minimal manual review (only spot-check the hardest 10–15%).

### Tips for Lightweight Anatomy/Skin Reward Models

- Start with an existing aesthetic reward model (PickScore or ImageReward) and fine-tune it on a small set of your own winning/losing examples focused on anatomy and skin.
- Key signals to emphasize during fine-tuning: hand coherence, genitalia accuracy, skin pore visibility + subsurface scattering, oil physics, identity consistency under erotic intensity.
- You can train a small MLP head on top of CLIP or a vision encoder using your curated pairs — this is much lighter than full model training.
- For quick wins, combine multiple open reward models with a simple weighted ensemble (e.g., 0.5 × aesthetic + 0.5 × custom anatomy score).
- Store the reward model alongside your LoRAs so it can be reused across future Curriculum-DPO runs and self-healing detection.

This synthetic pipeline turns the data bottleneck into a strength: you can rapidly generate targeted, phenotype-specific preference data that directly attacks the exact failure modes you see in production.

## 4. Integration with Existing Ecosystem

**With `spicy-male-erotic-prompt-optimizer`**:
- The refined artistic + technical prompts produced by this skill become even more effective when the underlying model has been Curriculum-DPO trained.
- Use the same "implied eroticism", oil + texture, and framing language in your winning preference captions.

**With Locked Visual Identity Stack**:
- Always include the full `covicea-core` + `covicea-face-lock` descriptors in winning examples.
- Use real reference images (via IP-Adapter/FaceID or img2img) for the winning set to reinforce phenotype lock.

**With `local-nsfw-comfyui` + DARE-TIES**:
- Generate both winning and losing images in high-fidelity local-nsfw-comfyui workflows.
- After training, merge the Curriculum-DPO LoRA into your production stack with DARE-TIES for maximum compatibility and minimal interference with existing LoRAs.

**With Self-Healing / skill-orchestrator**:
- Recurring anatomy or skin failures in generated batches can now trigger a recommendation to run a new Curriculum-DPO training pass focused on those specific failure modes.

## 5. Data Curation Tips Specific to COVICEA Phenotype
- Prioritize variety in lighting (dramatic rim + strong negative fill, natural window light with sheen, Rembrandt-style).
- Include both solo and duo/intimate scenes in later stages.
- For genitalia and intimate anatomy: Use clinical accuracy in winning examples but artistic/erotic framing language.
- Always maintain consistent tan caramel skin tone, curly hair behavior, and eye color across pairs.
- Create "identity stress tests": same prompt, one version with correct identity + good anatomy, one with identity drift or anatomical collapse.

## 6. Expected Outcomes
After completing all three stages and merging:
- Noticeably higher first-pass success rate on difficult erotic prompts.
- Much stronger skin realism and oil physics.
- Better preservation of the locked COVICEA phenotype even at high intensity.
- Reduced need for heavy negative prompting or post-processing.

This curriculum approach turns DPO from a general quality booster into a precision tool for your specific locked character erotic work.

---

**Next Recommended Actions**:
- Use this guide to curate your first Curriculum-DPO dataset.
- Stage 2 templates: `references/curriculum-dpo-stage2-templates.md` (hands, proportions, intimate).
- Stage 3 templates: `references/curriculum-dpo-stage3-templates.md` (skin/oil/SSS, identity under intensity).
- Scaffold folders + captions: `scripts/scaffold_dpo_pairs.py` (`init`, `captions`, `manifest`, `list`).
- After training, test the merged LoRA thoroughly with `spicy-male-erotic-prompt-optimizer` refined prompts.
- Log results and feed any recurring failure modes back into the self-healing system for the next targeted Curriculum-DPO run.

This document is the canonical reference for Curriculum-DPO NSFW training. Stage 2/3 pair templates and the pair-scaffolding script live alongside it.