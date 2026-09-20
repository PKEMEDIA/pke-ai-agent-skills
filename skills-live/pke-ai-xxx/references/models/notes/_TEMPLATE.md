# <trigger-or-ckpt-id> — model / LoRA note

**Status:** template | drafting | trained | production  
**Trigger:** `triggerword`  
**Age band:** 21+  
**Locks:** Face Lock / Black Mask NEVER used as refs, training data, IP-Adapter, or unlock docs.

## Sheet checklist (before LoRA)
- [ ] 20–40 stills, varied angles (face, 3/4, body, hands)
- [ ] Consistent lighting; no other people in frame
- [ ] Captions include trigger + body tokens
- [ ] No locked-face likeness
- [ ] Crop junk / text / watermarks

## Body / face tokens
- Body: _(customize)_
- Face: _(open phenotype — not Face Lock / not Black Mask)_

## LoRA / checkpoint
- Path: `models/loras/<name>.safetensors` _(or ckpt path)_
- Strength band: _(e.g. 0.6–0.85 — log after grids)_
- Base ckpt: _(fill after first successful train)_

## Sample seeds
_(fill after first grid)_

## Failure modes / anti-patterns
_(append from run log losers)_

## Contagious winners
_(snippets promoted into prompts/vN+1 — link CHANGELOG entry)_
