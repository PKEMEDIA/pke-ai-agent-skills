---
name: skill-test-suite
description: Activate for full skill suite validation end-to-end functionality testing or aggregator meta-skill tasks including testing all bundled and custom skills running validation harnesses demonstrating live skill usage overriding bundled skills permanently adding or updating skills. Trigger on test all skills run full suite validation validate every skill skill test harness end-to-end skill tests or meta skill for skills testing and integration.
metadata:
  short-description: Validate, e2e test, and integrate the PKE skill fleet
  argument-hint: "[validate | e2e | inventory]"
  surfaces: grok-bot, grok-chat, grok-ios, grok-web, grok-build, grok-cli
  slash: /skill-test-suite
---

# Skill Test Suite

## Purpose

This meta-skill provides a single reliable trigger point for comprehensive testing validation and integration management of the entire Grok skill ecosystem (bundled native skills plus custom persistent skills in the user directory). It ensures all skills remain structurally sound functionally demonstrated and permanently integrated.

## Activation Triggers

Activate on any query containing: test all skills, run full suite validation, validate every skill, skill test harness, end-to-end skill tests, meta skill for skills testing, skill aggregator tester, or similar phrases requesting broad skill testing or management.

## Core Procedures

### 1. Full Structural Validation Run

When triggered for testing or validation:

- Locate all skill directories, in order:
  - `$PKE_ROOT` package dirs and `skills-live/` (repo source of truth)
  - `~/.grok/skills/` (CLI persistence)
  - `/workspace/.grok/skills/` (Build)
  - Grok Bot library
  Never treat `/root/.grok/server-skills` or `/home/workdir/.grok/skills` as live trees.
- Resolve CREATOR as `$PKE_ROOT/skill-creator` or the sibling `skill-creator` package.
- For every directory execute exactly:
  bash "$CREATOR/scripts/validate-skill.sh" "<full-path-to-skill-dir>"
- Capture and tabulate results for each skill: name, line count, status (OK or FAIL), and any error messages.
- If all pass: Report "All X skills validated successfully. 100% pass rate. Fully integrated into Grok native."
- If any fail:
  - Read the failing SKILL.md with read_file tool.
  - Diagnose against rules: frontmatter delimiters, name/dir match, description scalar rules (no quotes, no colon-space, no angle brackets, no TODO, length limits), allowed fields only, non-empty body, no control tokens in any md files.
  - Apply targeted fixes using edit_file or write_file on the SKILL.md (or supporting files).
  - Re-execute validation on the fixed skill only.
  - Loop until zero errors remain.
- Final output: Clear summary (total skills, passes, fails fixed, actions taken), confirmation that all skills are structurally perfect and ready for native loading.

### 2. End-to-End Functionality Tests

After structural validation (or on explicit "end to end functionality tests" request), perform live demonstrations of key skills and report concrete outcomes including any generated artifacts (files, outputs, edits).

**Document Productivity & Form Skills (docx pdf xlsx pdf-form-filler pptx):**
- Generate a professional "Grok Skill Test Report" as a PDF or DOCX file saved to /workspace/artifacts/skill-test-report.pdf (or .docx).
- Include: validation summary table, list of all skills with status, E2E demo highlights, any fixes applied, permanence notes.
- Use the target skill's native generation capabilities (templates, python libraries, or instructed workflows) to create populate and format the document.
- Verify file creation with bash ls or read_file. Report exact path and basic content check (e.g. title present, page count if applicable).
- For pdf-form-filler: Demonstrate filling a simple sample form field if a fillable PDF is available or create one.

**Brand Content & Talent Strategy Skills (covicea-brand-assistant pretty-kitty-model-management):**
- Execute a realistic brand task following the skill's exact workflow and brand voice guidelines (bold unapologetic empowering Black gay male perspective; raw sexuality meets creative expression and business pragmatism; "I am that bitch" energy; high-fashion edge; avoid fluff corporate jargon or performative language).
- Example task to run: Draft an X/IG carousel caption + thread + OnlyFans post promoting a new homoerotic content series (e.g. breeding or vintage Polaroid oiled muscular Black male themes) with strong CTA, platform optimization, visual prompt suggestions for generate_image/edit_image, hashtags, and performance notes.
- Structure output per skill: hook/subject, body blocks, CTA, visual ideas, hashtags, timing/engagement notes.
- Critique the draft against brand voice rules and confirm alignment (authenticity, direct sensual descriptive language where appropriate, strategic emojis, benefit-driven).
- If talent agent angle requested: Include trend-informed recommendations or collab ideas using proactive tool use (web_search or x_keyword_search for current adult content trends) if the query context supports it.

**Media Voice Production & Image Skills (ffmpeg rvc-voice-production voice-reference-protocol youtube-stem-voice-production local-json-python-workflows local-nsfw-comfyui vogue-photo-editing image-gen-edit imagemagick):**
- ffmpeg: Confirm availability and basic function (e.g. run ffmpeg -version via bash and report version). If a short audio/video sample exists in artifacts, demonstrate a safe trim/convert command and verify output file.
- Voice/RVC pipeline: Follow voice-reference-protocol for optimized reference sample guidance (hotel-room/iPhone protocol, rehearsal script, adapted lyrics if music involved). If user provides or describes a reference audio, prepare it for encoding. Otherwise output the protocol steps and note readiness for rvc-voice-production handoff.
- ComfyUI/NSFW & advanced image/video: Confirm pipeline readiness. For safe demonstration use generate_image or edit_image with a brand-aligned prompt (e.g. photorealistic oiled muscular Black male portrait, cinematic Rembrandt lighting, accurate anatomy, vintage Polaroid or Y2K style). Save result and report file path + prompt used. For full NSFW workflows note that local-nsfw-comfyui handles unrestricted photorealistic explicit content with anatomy consistency; require explicit user intent for generation.
- Vogue-photo-editing & local-json-python-workflows: Outline or execute a mini cinematic edit workflow if assets present; otherwise confirm script/JSON handling capability.
- Report all generated files, success/failure, and any dependencies (e.g. reference audio needed for full voice clone).

**Legal Paralegal & Support Skills (paralegal-assistant memory-edit):**
- paralegal-assistant: Generate a concise sample small-claims demand letter or incident affidavit template following precise penalty-of-perjury language, risk assessment, and protective phrasing. Include key sections (facts, legal basis, relief sought, verification).
- memory-edit: Demonstrate by adding one neutral durable test fact (e.g. a sample business goal or preference with today's date) using edit_memory, then immediately read it back to confirm. Note that only factual durable personal/business info is stored; ephemeral or irrelevant data is not.
- Report the exact memory change and verification.

**Language Learning Finance Color & Utility Skills (language-learning finance color tasks mcp skill-creator skill-installer):**
- language-learning: Provide a short CEFR-aligned micro-exercise (e.g. A2-B1 vocabulary or grammar in target language) with correction model.
- finance: Run a simple calculation or report if query provides numbers (e.g. basic P&L snippet or runway projection); otherwise confirm capability.
- color imagemagick image-gen-edit: Confirm color space or basic image manipulation availability via quick command or note integration with generate/edit_image.
- tasks mcp: Confirm task orchestration or MCP protocol support if relevant to query.
- skill-creator skill-installer: Reaffirm init-skill.sh and install procedures; note that skill-installer requires network (currently disabled in this env) so GitHub installs are unavailable until enabled.

**General E2E Rules:**
- Always produce tangible outputs (files, text drafts, memory changes, command results) where possible.
- Log exact tool calls and results.
- For skills requiring external assets (audio, images, specific PDFs): Note the requirement and provide ready-to-use protocol or placeholder.
- Summarize at end: Number of E2E demos run, success rate, artifacts created (with full paths), limitations observed, and overall integration health.

### 3. Live Demonstration of Any Specific Skill

On request to demonstrate a particular skill (e.g. "demonstrate live usage of covicea-brand-assistant" or "show pdf skill in action"):

- Identify the exact skill name.
- Read its SKILL.md using read_file to load precise instructions, brand voice (if any), workflows, output formats, and resource references.
- Execute the requested task by following that skill's rules strictly and imperatively.
- Use supporting tools (bash, generate_image, edit_image, edit_memory, etc.) as the skill directs.
- Deliver the output in the format the skill specifies (e.g. structured caption blocks, filled document, edited image path).
- After delivery: Briefly note how the skill was activated and what unique value it added (consistency, domain knowledge, workflow enforcement).
- If the skill has references/ or scripts/, load them on demand as instructed.

### 4. Permanent Override or Customization of Bundled Skills

To customize any bundled (native) skill permanently so changes survive sessions:

- Check whether `~/.grok/skills/<exact-skill-name>/` already exists.
- If not: symlink `~/.grok/skills/<name>` to `$PKE_ROOT/<name>` (or copy from `skills-live/<name>`). Never `cp` from `/root/.grok/server-skills`.
- Edit the user-dir version: SKILL.md for instructions, or scripts/ references/ assets/ as needed. Use edit_file or write_file for precision.
- Immediately run validate-skill.sh on the user copy to confirm compliance.
- The user-dir version now takes precedence on every load and persists across conversations.
- Document the change reason inside the skill (e.g. under metadata or a comment) for future maintainers.
- Re-run full suite validation afterward to ensure no breakage.

### 5. Adding New Skills or Updating Existing Skills

**Adding a new skill:**
- Choose a kebab-case name (2-64 chars, lowercase alphanum + single hyphens, starts/ends with alphanum).
- Run: bash "$CREATOR/scripts/init-skill.sh" <new-name> ~/.grok/skills [--resources scripts,references,assets]
- Edit the generated SKILL.md: Replace TODOs with compliant frontmatter (name exactly matches dir; description is plain scalar, no colon-space, no <>, no TODO, <=1024 chars) and imperative body instructions.
- Add any needed scripts/ (executable helpers), references/ (long docs), or assets/ (templates).
- Run validate-skill.sh on the new directory.
- Test immediately with this skill-test-suite or direct trigger.
- The new skill is now permanently available and discoverable.

**Updating an existing skill (bundled or custom):**
- For bundled: First symlink or copy into `~/.grok/skills/` for permanence (see section 4).
- Use read_file to inspect current content.
- Make targeted edits with edit_file (preferred for precision) or write_file for larger rewrites.
- Focus only on non-obvious procedural or domain-specific knowledge; avoid duplicating what the base model already knows.
- Re-validate with validate-skill.sh.
- If the update affects triggers or behavior, test with a direct query that should activate it.
- For major refactors: Move long content to references/ files and link from SKILL.md.

### 6. Reporting Iteration & Safety

After every validation or E2E run:
- Deliver structured clear output: 
  - Validation summary (table or bullet list per skill).
  - E2E demo results with file paths and outcomes.
  - Any fixes applied and re-test confirmation.
  - Permanence status (which skills are now user-dir overrides).
  - Recommendations for next improvements or new skills.
- Use render components where helpful (e.g. render_file for generated test reports).
- Safety: Never perform destructive actions without user confirmation. Only store durable facts via memory-edit. For adult/NSFW skills respect explicit user intent and platform policies. Flag any legal or risk items per paralegal guidelines.
- If the environment changes (new skills added, internet enabled, new assets), re-run full suite to maintain integrity.

## Supporting Resources

- Official validation: `$CREATOR/scripts/validate-skill.sh`
- Skill initialization: `$CREATOR/scripts/init-skill.sh`
- This meta-skill's scripts/ directory is available for custom automation scripts (e.g. a future run-full-tests.sh wrapper).
- Individual skill references/ and assets/ are loaded on demand when the specific skill activates.
- All generated test artifacts should be placed in /workspace/artifacts/ for easy access and review.

This meta-skill guarantees repeatable one-command (or one-phrase) control over the health, functionality, and permanence of every skill in the Grok system while embedding comprehensive end-to-end verification. Use it proactively whenever skill integrity or expansion is in scope.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

