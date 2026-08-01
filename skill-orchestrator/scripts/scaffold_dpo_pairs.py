#!/usr/bin/env python3
"""
Curriculum-DPO pair scaffolding helper for COVICEÁ / Pretty Kitty anatomy stack.

Creates OneTrainer-ready folder layout, emits win/lose caption pairs from
canonical Stage 2 / Stage 3 templates, and writes a pair_manifest.csv skeleton.

Usage examples:
  # Create full directory tree under ./curriculum_dpo_covicea
  python scaffold_dpo_pairs.py init --root ./curriculum_dpo_covicea

  # Emit Stage 2 hand captions for stems 001-004
  python scaffold_dpo_pairs.py captions --stage 2 --category hand --count 4 --out ./captions_out

  # Emit Stage 3 skin/oil captions
  python scaffold_dpo_pairs.py captions --stage 3 --category skin --count 6 --out ./captions_out

  # Build manifest rows from a simple fail list (one defect note per line)
  python scaffold_dpo_pairs.py manifest --stage 2 --category hand --fails fails.txt --out manifest.csv

  # List available template keys
  python scaffold_dpo_pairs.py list

Does NOT generate images. Pair images must come from local-nsfw-comfyui
(or production fails). This script only scaffolds structure + captions + manifest.
"""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

LOCKED_BLOCK = (
    "photorealistic portrait of COVICEÁ, exact same face and identity, "
    "medium-deep to deep brown skin with warm-to-neutral undertones, "
    "light grayish-green to hazel-blue eyes with natural limbal rings, "
    "long dark wavy hair growing from the scalp with clean organic hairline and visible roots, "
    "athletic toned muscular physique, natural skin pores and subtle oil sheen, "
    "phenotype-accurate subsurface scattering"
)

# ---------------------------------------------------------------------------
# Stage 2 templates (hands / proportions / intimate)
# Keys: (stage, category, variant) -> (win_suffix, lose_suffix)
# win/lose suffixes are appended after LOCKED_BLOCK
# ---------------------------------------------------------------------------
STAGE2 = {
    ("2", "hand", "open"): (
        "reclining on black satin, one hand resting near the torso with correct five-finger articulation, natural knuckle bend, clear finger separation, realistic fingernail shape, proper tendon tension on the back of the hand, fine art male study, soft dramatic rim light, heavy glistening oil on skin with visible pores",
        "reclining on black satin, one hand near the torso with fused fingers, melted knuckle joints, incorrect finger count, rubbery collapsed hand structure, plastic skin, flat lighting",
    ),
    ("2", "hand", "body"): (
        "low-angle power pose, hand placed on the lower abdomen with anatomically correct palm contact, distinct fingers following the body contour, natural wrist angle, no interpenetration, professional male boudoir photography, strong negative fill, rich skin texture and pore detail",
        "low-angle power pose, hand on the lower abdomen with fingers sinking into the skin, fused digits, impossible wrist twist, extra finger, broken hand anatomy, waxy plastic skin",
    ),
    ("2", "hand", "grip"): (
        "seated on hotel sheets, hand gripping draped fabric with realistic pressure whitening at the fingertips, correct thumb opposition, natural crease lines in the palm, believable tendon pull, cinematic dramatic lighting, visible oil sheen and multi-scale pores",
        "seated on hotel sheets, hand gripping fabric with floating disconnected fingers, missing thumb, claw-like unnatural curl, no palm contact, deformed hand, smooth airbrushed skin",
    ),
    ("2", "hand", "two"): (
        "both hands visible in frame with consistent scale, correct five fingers each, natural overlap without merging, proper joint hierarchy from wrist to fingertip, fine art sensual male study, golden rim light, subsurface scattering on the hands",
        "both hands visible with mismatched scale, fingers merged into a single mass, extra digits, broken wrists, incoherent joint direction, plastic shiny hands, identity soft",
    ),
    ("2", "prop", "recline"): (
        "full body reclining on black satin, natural torso-to-leg proportion, correct femur and tibia length, balanced shoulder-to-hip ratio, head size consistent with body, no limb elongation, professional male boudoir, soft window light with strong negative fill, glistening oil and visible pores",
        "full body reclining on black satin, elongated rubber legs, collapsed torso, oversized head relative to shoulders, stretched arms, broken body proportions, plastic skin, flat light",
    ),
    ("2", "prop", "lowangle"): (
        "low-angle hero pose, correct foreshortening of the thighs and torso, natural muscle bulk in shoulders and chest without distortion, believable hip width, grounded feet, cinematic dramatic lighting, rich skin texture, phenotype-accurate SSS",
        "low-angle hero pose, extreme limb stretch, tiny waist with balloon shoulders, floating feet, distorted perspective proportions, melted anatomy, airbrushed plastic skin",
    ),
    ("2", "prop", "seated"): (
        "seated on the edge of the bed, knees bent with correct joint alignment, natural thigh thickness, calves in proper proportion to thighs, spine curve believable, no telescoping limbs, fine art male study, Rembrandt lighting, oil sheen and pore detail",
        "seated on the edge of the bed, knees bending the wrong way, telescoping lower legs, mismatched left/right limb length, collapsed pelvis, broken seated proportions, waxy skin",
    ),
    ("2", "prop", "torsoarm"): (
        "three-quarter crop, arms in correct length relative to torso, shoulders level and anatomically placed, clavicle and deltoid insertion visible and natural, no truncated or stretched upper limbs, professional boudoir photography, strong rim light, multi-scale skin pores",
        "three-quarter crop, one arm significantly longer than the other, shoulders sliding off the torso, missing clavicle structure, stretched upper arm, incoherent torso-arm proportion, plastic smooth skin",
    ),
    ("2", "int", "soft"): (
        "reclining on black satin, anatomically correct relaxed genitalia with natural proportions, realistic soft tissue volume and skin texture, proper placement relative to the pelvis, clear separation from surrounding anatomy, fine art male study, soft dramatic rim light with strong negative fill, heavy glistening oil and visible pores",
        "reclining on black satin, deformed or melted genitalia, incorrect scale relative to the body, fused to the thigh, missing or duplicated structure, plastic smooth skin, flat lighting",
    ),
    ("2", "int", "erect"): (
        "low-angle power pose, anatomically accurate erect genitalia with correct shaft-to-glans proportion, natural vascular detail, believable angle from the body, consistent lighting and shadow on the form, professional male boudoir photography, cinematic rim light, multi-scale skin pores and oil sheen",
        "low-angle power pose, distorted or bent shaft, wrong scale, floating or disconnected from the body, melted glans, impossible angle, broken intimate anatomy, waxy plastic skin",
    ),
    ("2", "int", "close"): (
        "close intimate crop, highly detailed anatomically correct genitalia, realistic skin folds and texture, natural color variation, accurate subsurface scattering on the skin, coherent surrounding anatomy (lower abdomen, upper thighs), macro skin texture study, controlled dramatic light, visible pores and healthy oil sheen",
        "close intimate crop, blurred or liquified genitalia, wrong number of structures, skin fused into a single mass, no pore detail, plastic airbrushed surface, incoherent crop anatomy",
    ),
    ("2", "int", "hand"): (
        "seated on hotel sheets, hand in natural contact with genitalia, correct five-finger articulation, realistic pressure and skin deformation at contact points, anatomically accurate genitalia under the hand, no interpenetration artifacts, fine art sensual male study, strong negative fill, glistening oil and pore detail",
        "seated on hotel sheets, hand melting into genitalia, fused fingers, deformed or missing genital structure, impossible contact geometry, broken intimate anatomy, plastic skin",
    ),
}

# ---------------------------------------------------------------------------
# Stage 3 templates (skin / oil / SSS / identity under intensity)
# ---------------------------------------------------------------------------
STAGE3 = {
    ("3", "skin", "oilpores"): (
        "heavy glistening oil on skin with individual visible pores and natural irregular pore variation, realistic oil pooling and highlight breakup, soft micro-occlusion in skin folds, phenotype-accurate subsurface scattering with warm internal glow, fine art male study, dramatic rim light, no plastic or airbrushed surface",
        "heavy oil that wipes out all pore detail, painted-on uniform sheen, plastic or waxy skin under oil, flat specular highlights, no subsurface scattering, airbrushed plastic surface",
    ),
    ("3", "skin", "sweatoil"): (
        "mixed sweat and oil with natural droplet variation, pores still readable under moisture, realistic wet-skin specular response, healthy oil sheen only where light hits, photorealistic iPhone texture on dark skin, cinematic lighting",
        "plastic wet look, uniform shiny coating with no pores, melted skin under moisture, fake droplet sprites, over-smoothed airbrushed skin",
    ),
    ("3", "skin", "partial"): (
        "selective oil sheen on shoulders and chest with dry matte skin elsewhere, clear pore texture in both regions, natural transition, believable light interaction, professional male boudoir, strong negative fill",
        "inconsistent plastic patches, oil that erases texture in one region only, hard cut between shiny and matte with no natural blend, flat skin",
    ),
    ("3", "sss", "glow"): (
        "phenotype-accurate subsurface scattering with warm internal glow and soft volumetric quality on medium-deep to deep brown skin, light wrapping through the ear and nose edge, natural redness in thin tissue, organic multi-scale pore variation, Rembrandt lighting",
        "chalky or flat dark skin with no internal glow, hard cut shadow with no light transport, grayish dead undertone, plastic surface, no SSS",
    ),
    ("3", "sss", "rim"): (
        "strong golden cinematic rim light with visible subsurface scatter along the rim edge, warm glow bleeding into shadow, pore detail retained in both key and rim, fine art sensual male study",
        "rim light that only creates a hard white outline, no scatter into the skin, plastic rim, loss of pore detail under the rim, flat silhouette",
    ),
    ("3", "sss", "face"): (
        "close facial crop, accurate SSS in the nose, ears, and lip edges, warm internal glow, natural limbal rings and iris texture preserved, multi-scale pores on cheeks and forehead, iPhone Photonic Engine residual grain",
        "close facial crop with plastic mask-like skin, no internal glow, dead flat cheeks, identity soft or drifted, over-smoothed pores",
    ),
    ("3", "id", "close"): (
        "close intimate crop at high erotic intensity, exact same face and identity fully preserved, eye color and bone structure locked, long dark wavy hair with visible roots, natural skin pores and oil sheen, professional male boudoir, dramatic light",
        "close intimate crop at high erotic intensity, face drifted or swapped, wrong eye color, softened jawline, identity collapse, plastic skin, generic features",
    ),
    ("3", "id", "lowangle"): (
        "low-angle power pose at high intensity, exact same face and identity, phenotype lock retained under dramatic lighting and oil, correct anatomy from Stage 2, rich skin texture and SSS, cinematic rim light",
        "low-angle power pose at high intensity, identity collapse, face no longer matches reference, plastic skin, broken or softened features under intensity",
    ),
    ("3", "id", "contact"): (
        "hand in natural contact with body at high intensity, correct five-finger articulation, exact face identity preserved, realistic skin deformation and oil at contact, no interpenetration, fine art study, strong negative fill",
        "hand melting into body, identity drift on the face, plastic skin under contact, fused anatomy, intensity caused face and skin failure",
    ),
    ("3", "fabric", "drape"): (
        "fabric draped over oiled skin with realistic pressure and micro-folds, skin pores and oil sheen still visible at contact edges, natural cloth tension, professional boudoir, soft dramatic light",
        "fabric fused into the skin, plastic skin under cloth, no pore detail at contact, floating or interpenetrating fabric, flat lighting",
    ),
    ("3", "fabric", "minimal"): (
        "minimal fabric drape with correct skin–cloth boundary, visible pores and oil on exposed skin, believable weight and fold, fine art male study, cinematic lighting",
        "fabric cutting into plastic skin, melted boundary, lost skin texture under drape, unrealistic cloth physics",
    ),
}

ALL_TEMPLATES = {**STAGE2, **STAGE3}

CATEGORY_DIRS = {
    "2": {"hand": "hands", "prop": "proportions", "int": "intimate"},
    "3": {"skin": "skin", "sss": "sss", "id": "identity", "fabric": "fabric"},
}


def make_caption(win_suffix: str, lose_suffix: str) -> tuple[str, str]:
    win = f"{LOCKED_BLOCK}, {win_suffix}"
    lose = f"{LOCKED_BLOCK}, {lose_suffix}"
    return win, lose


def cmd_list(_: argparse.Namespace) -> None:
    print("Available template keys (stage, category, variant):\n")
    for stage in ("2", "3"):
        print(f"  Stage {stage}:")
        keys = sorted(k for k in ALL_TEMPLATES if k[0] == stage)
        for s, c, v in keys:
            print(f"    --stage {s} --category {c} --variant {v}")
        print()


def cmd_init(args: argparse.Namespace) -> None:
    root = Path(args.root)
    dirs = [
        root / "stage1_easy_framing" / "chosen",
        root / "stage1_easy_framing" / "rejected",
        root / "stage1_easy_framing" / "captions",
        root / "stage2_medium_anatomy" / "hands" / "chosen",
        root / "stage2_medium_anatomy" / "hands" / "rejected",
        root / "stage2_medium_anatomy" / "hands" / "captions",
        root / "stage2_medium_anatomy" / "proportions" / "chosen",
        root / "stage2_medium_anatomy" / "proportions" / "rejected",
        root / "stage2_medium_anatomy" / "proportions" / "captions",
        root / "stage2_medium_anatomy" / "intimate" / "chosen",
        root / "stage2_medium_anatomy" / "intimate" / "rejected",
        root / "stage2_medium_anatomy" / "intimate" / "captions",
        root / "stage3_hard_skin_physics" / "chosen",
        root / "stage3_hard_skin_physics" / "rejected",
        root / "stage3_hard_skin_physics" / "captions",
        root / "holdout_test" / "hands",
        root / "holdout_test" / "proportions",
        root / "holdout_test" / "intimate",
        root / "holdout_test" / "skin",
        root / "meta",
    ]
    for d in dirs:
        d.mkdir(parents=True, exist_ok=True)
    manifest = root / "meta" / "pair_manifest.csv"
    if not manifest.exists():
        with manifest.open("w", newline="") as f:
            w = csv.writer(f)
            w.writerow(["stem", "stage", "category", "variant", "source", "notes"])
    notes = root / "meta" / "train_notes.md"
    if not notes.exists():
        notes.write_text(
            "# Train notes\n\n"
            "- Stage 1 → Stage 2 → Stage 3, carry checkpoints.\n"
            "- Stage 2 templates: skill-orchestrator/references/curriculum-dpo-stage2-templates.md\n"
            "- Stage 3 templates: skill-orchestrator/references/curriculum-dpo-stage3-templates.md\n"
            "- Merge DPO LoRA at 0.6–0.8 via DARE-TIES into covicea-face-lock master.\n"
        )
    print(f"Initialized layout under {root.resolve()}")
    print(f"Manifest: {manifest}")


def cmd_captions(args: argparse.Namespace) -> None:
    stage = str(args.stage)
    category = args.category
    variant = args.variant
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    # If variant given, single template; else cycle all variants for category
    if variant:
        keys = [(stage, category, variant)]
        if keys[0] not in ALL_TEMPLATES:
            print(f"Unknown template: {keys[0]}", file=sys.stderr)
            sys.exit(1)
    else:
        keys = sorted(k for k in ALL_TEMPLATES if k[0] == stage and k[1] == category)
        if not keys:
            print(f"No templates for stage={stage} category={category}", file=sys.stderr)
            sys.exit(1)

    count = args.count
    written = 0
    idx = 1
    while written < count:
        for s, c, v in keys:
            if written >= count:
                break
            win_suf, lose_suf = ALL_TEMPLATES[(s, c, v)]
            win, lose = make_caption(win_suf, lose_suf)
            stem = f"s{s}_{c}_{v}_{idx:03d}"
            (out / f"{stem}.txt").write_text(win + "\n")
            (out / f"{stem}_rejected.txt").write_text(lose + "\n")
            print(f"  {stem}")
            written += 1
        idx += 1
    print(f"Wrote {written} pair caption sets to {out.resolve()}")


def cmd_manifest(args: argparse.Namespace) -> None:
    stage = str(args.stage)
    category = args.category
    variant = args.variant or "open"
    fails_path = Path(args.fails)
    out = Path(args.out)

    if not fails_path.exists():
        print(f"Fails file not found: {fails_path}", file=sys.stderr)
        sys.exit(1)

    notes = [ln.strip() for ln in fails_path.read_text().splitlines() if ln.strip()]
    rows = []
    for i, note in enumerate(notes, start=1):
        stem = f"s{stage}_{category}_{variant}_{i:03d}"
        rows.append(
            {
                "stem": stem,
                "stage": stage,
                "category": category,
                "variant": variant,
                "source": "prod_fail",
                "notes": note,
            }
        )

    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", newline="") as f:
        w = csv.DictWriter(
            f, fieldnames=["stem", "stage", "category", "variant", "source", "notes"]
        )
        w.writeheader()
        w.writerows(rows)
    print(f"Wrote {len(rows)} manifest rows to {out.resolve()}")


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Curriculum-DPO pair scaffolding helper")
    sub = p.add_subparsers(dest="cmd", required=True)

    pl = sub.add_parser("list", help="List available template keys")
    pl.set_defaults(func=cmd_list)

    pi = sub.add_parser("init", help="Create OneTrainer folder layout")
    pi.add_argument("--root", default="./curriculum_dpo_covicea")
    pi.set_defaults(func=cmd_init)

    pc = sub.add_parser("captions", help="Emit win/lose caption files from templates")
    pc.add_argument("--stage", type=int, required=True, choices=[2, 3])
    pc.add_argument("--category", required=True, help="hand|prop|int|skin|sss|id|fabric")
    pc.add_argument("--variant", default=None, help="optional specific variant")
    pc.add_argument("--count", type=int, default=4)
    pc.add_argument("--out", default="./captions_out")
    pc.set_defaults(func=cmd_captions)

    pm = sub.add_parser("manifest", help="Build pair_manifest.csv from a fails list")
    pm.add_argument("--stage", type=int, required=True, choices=[2, 3])
    pm.add_argument("--category", required=True)
    pm.add_argument("--variant", default=None)
    pm.add_argument("--fails", required=True, help="text file, one defect note per line")
    pm.add_argument("--out", default="./pair_manifest.csv")
    pm.set_defaults(func=cmd_manifest)

    return p


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
