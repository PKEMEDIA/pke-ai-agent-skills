# Ecosystem self-improvement (AI-XXX)

**Immutable locks:** Face Lock + Black Mask — never train, unlock, or document unlocks. Minors ban hard.

1. **Prompt versioning** — `prompts/vN/` + root `CHANGELOG.md`. `current.json` pins live set; never overwrite old versions in place.
2. **Model notes** — `models/notes/<lora-or-ckpt>.md`: base, triggers, strength bands, failure modes, sample seeds.
3. **Run log** — append-only `runs/YYYY-MM.md` → feeds polish.
4. **GitHub SoT** — mirror healthy bumps to PKEMEDIA/pke-ai-agent-skills (or content subtree).
5. **Heal triggers** — quality drop or Face Lock check fail → freeze deploys; patch prompts/notes only.
6. **Contagious patterns** — winners → shared prompt-pack templates; failures → anti-patterns in model notes.

Owner: Ecosystem (+ Aleah free-tier learn, Orchestrator health).

7. **Aleah offline routing** — `comfyui/aleah-offline-routing.md`: L0 local Comfy → L1 sim/slideshow → L2 rented GPU only; heal/learn never burns Imagine; Face Lock / Black Mask immutable.
