---
name: pke-synthetic-intellect
description: Autonomous free-tier-safe learning loop for PKE skills that always observes heals and improves from local signals without Imagine or SuperGrok burn. Triggers on synthetic intellect, autonomous learning, always learning, self improve, free tier learn, pke mind, continuous improvement, autodidact, self evolving skill pack.
metadata:
  short-description: Free-tier autonomous self-improving PKE intellect
  platforms: grok-ios, grok-web, grok-build, free-tier
  version: "1.0.0"
---

# PKE Synthetic Intellect

A **local-first, free-tier-safe** autonomous mind for the PKE skill pack. It keeps learning and improving skills from logs and structure — **never** spends SuperGrok Heavy / Imagine on self-improvement.

## Free-tier hard rules

| Allowed | Forbidden in learn loop |
|---|---|
| Read heal logs, skill MD, asset gates | `image_gen` / Imagine |
| Patch SKILL.md text for clarity & efficiency | Video generation |
| Update `artifacts/pke-mind/` knowledge | Speculative cloud re-gens |
| Run self-heal | Burning quota to "practice" |
| Optional GitHub push of text | Secrets in mind store |

## Run (autonomous cycle)

```bash
bash /workspace/scripts/pke-learn.sh          # observe → heal → improve → stamp
bash /workspace/scripts/pke-learn.sh --push   # + publish lessons/skill patches
```

Wire to revive (optional): call learn from `startup.sh` only if you want a cycle on wake — default is **on-demand** so startup stays fast.

## Cycle pipeline

```text
1. SELF-HEAL     pke-self-heal.sh
2. OBSERVE       validate skills, app HTTP, assets, heal-log signals
3. SCORE         health · integrity · efficiency · brand lock · autonomy
4. IMPROVE       patch skill docs (free-tier blocks, missing sections)
5. REMEMBER      artifacts/pke-mind/state.json + lessons.md
6. OPTIONAL PUSH GitHub text-only sync
```

## Knowledge store

| Path | Purpose |
|---|---|
| `artifacts/pke-mind/state.json` | Scores, cycles, failure_counts, improvements |
| `artifacts/pke-mind/lessons.md` | Human-readable lesson log |
| `artifacts/pke-mind/cycles/` | Per-cycle reports |

## How it stays intellectual

- **Pattern memory** — failure_counts accumulate across cycles.
- **Gap detection** — missing free-tier / efficiency sections get written in.
- **Prompt discipline** — flags verbose blocks; never auto-truncates brand locks (identity risk).
- **Heal-first** — broken pack is repaired before learning.
- **No vanity gens** — intelligence is textual and structural, not image spam.

## Pairing

| Skill | Role |
|---|---|
| `skill-orchestrator` | Health gates, export, orchestration |
| `pke-face-lock` / `pke-official-black-mask` | Locks that learn must not violate |
| `skill-creator` | Validate after every patch |
| `pke-self-heal` (script) | Pre-learn repair |

## Hard stops

- Never invent a second company face
- Never recolor the official mask
- Never call Imagine from this skill
- Never claim learning required paid tier
- Never store secrets in `pke-mind`

## iOS / web

Same triggers on free or SuperGrok. On free tier, this is how the pack **keeps getting smarter** without quota.


## PKE agent ecosystem (always load)

| Agent / skill | When |
|---|---|
| `pke-face-lock` | Company face / casting / roster |
| `pke-official-black-mask` | Mask / title stills |
| `skill-orchestrator` | Health, export, self-heal, deploy |
| `pke-synthetic-intellect` | Free-tier autonomous learn cycle |
| `skill-creator` | Validate after any SKILL.md edit |

**Autonomous ops (local, free tier):**

```bash
bash /workspace/scripts/pke-self-heal.sh
bash /workspace/scripts/pke-learn.sh
```

**Hard locks:** one company face · pure-black mask · title seals **PKE PRESENTS** / **A PKE PRODUCTION** only · no Imagine in learn loop.
