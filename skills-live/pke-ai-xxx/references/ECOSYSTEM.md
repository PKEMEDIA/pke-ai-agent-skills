# Ecosystem self-improvement runbook (AI-XXX)

**Immutable locks (never rewrite / unlock / document unlock):** Face Lock · Black Mask · Minors ban. Additive-only around locks.

**Honest platform wall:** This loop polishes playbooks, prompts, notes, graphs, and scripts. It does **not** change foundation model weights, fine-tunes locked faces, or burn Imagine / SuperGrok credits. Free-tier local docs/scripts only.

**Owner:** Ecosystem (+ Aleah free-tier learn, Orchestrator health). Coviceá / Chief of Staff greenlight for polish.

---

## 0. Quick loop

```
validate (scripts/heal-check.sh) → diagnose → fix (prompts/notes/graphs only) → re-test → log → (optional) GitHub SoT
```

Bounded: max 5 heal iterations per session. Freeze deploys on Face Lock check fail or scored quality drop (see §5).

---

## 1. Prompt versioning (bump)

**Rule:** Never overwrite an old `prompts/vN/` in place. Always copy forward.

1. Read pin: `current.json` → `"prompt_set": "vN"`.
2. Create next dir: `mkdir -p prompts/v$((N+1))` (e.g. `v1` → `v2`).
3. Copy **from the current pin** (not ad-hoc edits only at root):
   ```bash
   cp prompts/vN/*.md prompts/v$((N+1))/
   ```
4. Edit only files under `prompts/v$((N+1))/`.
5. Sync the **live working mirror** at pack root `prompts/*.md` from the new pin (see §1b).
6. Update `current.json`: `"prompt_set": "v$((N+1))"`, bump `"updated"`.
7. Append `CHANGELOG.md` with why + what changed.
8. Run `scripts/heal-check.sh` — must PASS before treating bump as live.

### 1b. Root `prompts/*.md` = working mirror of pin

- Versioned copies live **only** under `prompts/vN/`.
- Root `prompts/*.md` (excluding any README) are the **live mirror** of whatever `current.json` pins.
- After any pin change: `cp prompts/vN/*.md prompts/` (three files: `capability-matrix.md`, `double-oral-mmf.md`, `male-models.md`).
- Do not invent a divergent root-only prompt set. If you draft at root, promote into a new `vN+1` before declaring ready.

---

## 2. Update `current.json`

Keep keys lean. After polish or bump:

| Field | Purpose |
|-------|---------|
| `prompt_set` | e.g. `"v1"` — must match existing `prompts/vN/` |
| `updated` | `YYYY-MM-DD` (America/New_York calendar date) |
| `locks` | always include `"face-lock"`, `"black-mask"` |
| `status` | e.g. `ready` |
| `ecosystem_loop` | `active` when self-improve runbook + heal-check are operational |
| `skill` | `pke-ai-xxx` |
| `aleah_routing` | path to offline router doc |
| `graphs` | stills / animatediff paths + status |

Do not remove the `locks` array.

---

## 3. Append `CHANGELOG.md`

Dated `## YYYY-MM-DD — short title` sections. Bullet what changed and why. Note heal-check PASS when shipping a polish. Never document unlock paths for Face Lock / Black Mask.

---

## 4. Model notes

- Path: `models/notes/<lora-or-ckpt>.md` (+ optional `.yaml` card).
- Start from `models/notes/_TEMPLATE.md`.
- Record: base ckpt, trigger tokens, strength bands, failure modes, sample seeds, **locks reminder** (Face Lock / Black Mask never as refs).
- Age band always 21+.

---

## 5. Run log

- Append-only: `runs/YYYY-MM.md` (create new month file from the Template block in `runs/2026-09.md`).
- One scored block per run (see template in that file).
- Scene detail may live under `runs/scenes/` and be linked from the monthly log.
- Feed keepers → contagious promotion (§7); failures → anti-patterns in model notes.

---

## 6. Heal / freeze criteria

**Freeze deploys** (no new OF/X publish from this pack lane) when either:

1. **Face Lock check fail** — heal-check or graph validate flags locked-face asset paths / unlock language; or human review finds Face Lock / Black Mask used as training/ref material.
2. **Quality drop** — scored run quality ≤ previous keeper average by ≥1 point on the 1–5 scale for the same lane, or systematic anatomy/prompt failures across a grid.

**While frozen:** patch prompts (`vN+1`), model notes, graph placeholders, and checklists only. Re-run heal-check. Unfreeze only when PASS + at least one scored recovery run logged (or Orchestrator/Aleah explicitly clears).

**Heal actions allowed:** prompt text, notes, graph structure (no locked assets), scripts, docs.  
**Never:** unlock Face Lock / Black Mask, train those faces, burn Imagine in the learn loop, minors wording.

---

## 7. Contagious pattern promotion

| Signal | Action |
|--------|--------|
| Winner (quality ≥4, reusable angle/token stack) | Promote snippet into shared prompt pack under new `prompts/vN+1/` (or capability-matrix lane note); mention in CHANGELOG |
| Failure / anti-pattern | Append to relevant `models/notes/*.md` Failure modes; optionally capability-matrix “avoid” line |
| Graph that queues clean on live Comfy | Mark `graphs.status` → `gpu-validated` in `current.json` after re-export |

Additive only into creative-adjacent files. Never inject unlock or minors content.

---

## 8. GitHub SoT

Mirror healthy bumps to `PKEMEDIA/pke-ai-agent-skills` (or content subtree) **only when** credentials are available **and** `scripts/heal-check.sh` PASSes. If push is not possible: leave pack local and note “local polished; GitHub sync pending” in the session report. Never push secrets or private legal case details.

---

## 9. Aleah offline routing

See `comfyui/aleah-offline-routing.md`:

- **L0** local Comfy → **L1** sim/slideshow → **L2** rented GPU only when needed.
- Heal/learn never burns Imagine / SuperGrok.
- Face Lock / Black Mask immutable on every route.

---

## 10. Validate command

```bash
bash /workspace/pke-content/ai-xxx/scripts/heal-check.sh
# or: python3 /workspace/pke-content/ai-xxx/scripts/heal-check.py
```

PASS required before declaring pack ready after material change.
