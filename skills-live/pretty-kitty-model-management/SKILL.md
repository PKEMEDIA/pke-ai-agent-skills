---
name: pretty-kitty-model-management
description: Manage Pretty Kitty Entertainment model portfolios, contracts from standards, earnings, Google Forms, X trends from PKEMEDIA, plus batch media ingestion, video analysis, and compilation/film creation workflows. Use for talent onboarding, agreement customization, content production, repurposing, and compliance record keeping.
---

# Pretty Kitty Model Management

Activate for model onboarding, agreement customization, portfolio maintenance, earnings tracking or X content trend analysis tied to Pretty Kitty Entertainment.

## Contract and Model Release Generation

Load company standard contract and model release templates from assets/ (vetted DOCX with {{PLACEHOLDER}} variables; see sample format in assets/).

**Primary tool**: `scripts/generate_contract.py`
- Loads metadata.json from a model portfolio directory.
- Accepts overrides (--scene, --compensation, --shoot-date, --commission-rate) or full --overrides JSON.
- Performs mechanical {{PLACEHOLDER}} substitution across paragraphs, tables, headers/footers.
- Saves individualized .docx; auto-records reference in metadata.json under "contracts".
- Prints compliance checklist every time.

**Critical (non-negotiable)**: Script does **only** variable substitution on pre-vetted legal language. It never drafts, interprets, or adds clauses. Every output must be reviewed by qualified counsel before execution. 2257 compliance, age verification, and explicit consent remain user responsibility. Store signed originals + ID scans in documents/releases/ and id_verification/.

**Custom drafting path**: `scripts/assemble_legal_draft.py` — supply a `clauses.json` library of attorney-vetted modules. Script assembles draft by selecting/ordering modules + substituting variables. Output marked "DRAFT FOR ATTORNEY REVIEW — NOT EXECUTABLE". Only supported path for custom agreements.

## Model Portfolio Structure

One directory per model under models/ root (e.g. `models/2026-06-15_StageName/`).

Standard layout:
- metadata.json or info.md (contact, physical description, experience, limits, specialties, availability, consent status, 2257 record location)
- photos/ (headshots, body, test shoots — by date)
- videos/ (audition tapes, performance clips — date_scene)
- documents/ (signed releases, contracts, ID copies, W-9, correspondence)
- earnings/ (per-project ledgers or links to central tracker)

Update metadata after every interaction. Support search/filter across portfolios for casting.

## Compliance and Risk Controls

Mandatory workflow gates:
1. Age and identity verification documented before any contract or content.
2. Explicit written consent for every use of likeness and performance.
3. Secure storage of 2257-mandated records (ID + release) with easy retrieval.
4. Transparent compensation terms in every agreement.
5. Human sign-off on every generated document and data import.

Reject treating AI-substituted contracts as final without review. Model personal/sexual history is highly confidential — least-privilege access, encryption where feasible, separate consent for portfolio storage.

## Getting Started
1. Place vetted contract/release templates in assets/.
2. Initialize model: `python scripts/init_model_portfolio.py "Stage Name" "YYYY-MM-DD"`
3. Batch import media (see references/media-production.md).
4. For custom agreements: Build clauses.json → assemble_legal_draft.py → attorney review.
5. All media must be consensual with documented 2257 compliance.

## References (load on demand)
- `references/media-production.md` — Batch import, video analysis, compilations, public research, performer ID (compliant only)
- `references/earnings-forms-trends.md` — Google Forms, earnings ledger, X trends from PKEMEDIA

Legal language always originates from vetted modules only. Full attorney review required on every draft.

## Orchestrator Integration & Handoffs
Revenue sequence: this skill owns talent onboarding, portfolio structure, 2257/consent gates, and contract *substitution* from vetted templates. Hand off risk analysis, custom clause strategy, affidavits, and non-template legal drafting to `paralegal-assistant`. Hand off public promo, talent outreach copy, and growth messaging to `covicea-brand-assistant`. After major template or portfolio workflow changes, run `skill-orchestrator` + `skill-test-suite` validation.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

