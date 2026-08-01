# Skill Ecosystem Dependency Graph (Auto-Generated)

**Generated**: 2026-08-01 06:24:29 UTC
**Total Skills Scanned**: 61
**Total Lines across all SKILL.md files**: 6686

**Circular Dependencies**: 126 potential cycle(s)
- docx → paralegal-assistant
- docx → pdf
- pdf → pdf-form-filler
- skill-creator → skill-orchestrator
- skill-creator → skill-test-suite
- cover-song-studio-master → rvc-voice-production
- covicea-brand-assistant → paralegal-assistant
- covicea-brand-assistant → pretty-kitty-model-management
- covicea-brand-assistant → skill-orchestrator
- covicea-brand-assistant → skill-test-suite
- covicea-core → covicea-distraction-image-defaults
- covicea-core → covicea-face-lock

## Clusters

### Core Meta Layer
- **skill-creator** → mcp, skill-orchestrator, skill-test-suite, tasks
- **skill-orchestrator** → covicea-brand-assistant, local-nsfw-comfyui, mcp, paralegal-assistant, pretty-kitty-model-management, rvc-voice-production ...
- **skill-test-suite** → color, covicea-brand-assistant, docx, ffmpeg, finance, image-gen-edit ...
- skill-installer

### Legal / Paralegal
- **paralegal-assistant** → covicea-brand-assistant, docx, memory-edit, pdf, pretty-kitty-model-management, skill-orchestrator ...
- **docx** → covicea-podcast-script-to-docx, episode-bible, memory-edit, paralegal-assistant, pdf, pdf-form-filler ...
- **pdf** → covicea-podcast-script-to-docx, docx, paralegal-assistant, pdf-form-filler
- **pdf-form-filler** → pdf, tasks
- **covicea-podcast-script-to-docx** → covicea-aloha-shade-ohana, docx
- **skills-learned-script** → pptx
- **memory-edit** → tasks

### COVICEA Visual & Media Production
- **covicea-core** → color, covicea-distraction-image-defaults, covicea-face-lock, covicea-realistic-hair-skin-lighting, distraction-image-defaults, skill-creator ...
- **covicea-face-lock** → color, covicea-comfyui-consistency, covicea-core, covicea-distraction-image-defaults, covicea-gym-mirror-selfie-retouch, covicea-realistic-hair-skin-lighting ...
- **covicea-selfie-image-defaults** → color, covicea-core
- **covicea-distraction-image-defaults** → color, covicea-core, distraction-image-defaults
- **covicea-realistic-hair-skin-lighting** → color, covicea-core, covicea-selfie-image-defaults, tasks
- **covicea-photoreal-workflow** → covicea-core, covicea-face-lock, local-nsfw-comfyui, skill-orchestrator, tasks
- **covicea-gym-mirror-selfie-retouch** → color, covicea-core, covicea-distraction-image-defaults, covicea-realistic-hair-skin-lighting, covicea-selfie-image-defaults, mirror-selfie-corrector ...
- **covicea-comfyui-consistency** → color, covicea-core, covicea-distraction-image-defaults, covicea-selfie-image-defaults, local-json-python-workflows, local-nsfw-comfyui ...
- **covicea-brand-assistant** → color, covicea-core, paralegal-assistant, pretty-kitty-model-management, skill-orchestrator, skill-test-suite ...
- **covicea-aloha-shade-ohana** → color
- **local-nsfw-comfyui** → color, ffmpeg, local-json-python-workflows, spicy-male-erotic-prompt-optimizer
- **negative-prompt-library** → color
- **photoreal-hair-anisotropic-master** → color, covicea-core, covicea-face-lock, local-nsfw-comfyui, negative-prompt-library, photoreal-skin-sss-master ...
- **photoreal-skin-master** → aave-assistant, color, covicea-core, covicea-realistic-hair-skin-lighting, mirror-selfie-corrector
- **photoreal-skin-sss-master** → color, covicea-core, covicea-face-lock, local-nsfw-comfyui, negative-prompt-library, photoreal-hair-anisotropic-master ...
- **photoreal-undetectable-portrait-master** → color, covicea-core, covicea-face-lock, local-nsfw-comfyui, negative-prompt-library, photoreal-hair-anisotropic-master ...
- **pretty-kitty-model-management** → covicea-brand-assistant, docx, paralegal-assistant, skill-orchestrator, skill-test-suite
- **pretty-kitty-photorealism** → covicea-core, covicea-face-lock, local-nsfw-comfyui, skill-orchestrator, tasks
- **spicy-male-erotic-prompt-optimizer** → covicea-core, covicea-face-lock, covicea-realistic-hair-skin-lighting, grok-usage-maximizer, local-nsfw-comfyui, skill-orchestrator
- **consistent-identity-batch-processor** → color
- **distraction-image-defaults** → covicea-core, covicea-distraction-image-defaults
- mirror-selfie-corrector

### Brand / Voice / Content Strategy
- **content-strategy-suite** → covicea-brand-assistant, local-json-python-workflows, local-nsfw-comfyui, paralegal-assistant, pretty-kitty-model-management, skill-test-suite ...
- episode-bible
- grok-sentient-editor
- **aave-assistant** → content-strategy-suite, covicea-brand-assistant, local-nsfw-comfyui, paralegal-assistant, pk-svwo-v1-0, pkemedia-grok-video-pipeline ...
- **pk-svwo-v1-0** → covicea-brand-assistant, grok-local-app-web-integration, local-json-python-workflows, local-nsfw-comfyui, pkemedia-grok-video-pipeline, pretty-kitty-model-management ...

### Voice & Audio Production
- **rvc-voice-production** → cover-song-studio-master, ffmpeg, voice-reference-protocol, youtube-stem-voice-production
- **voice-reference-protocol** → covicea-brand-assistant, ffmpeg, local-json-python-workflows, pretty-kitty-model-management, rvc-voice-production, vogue-photo-editing ...
- **voice-commander** → content-strategy-suite, covicea-brand-assistant, covicea-core, covicea-distraction-image-defaults, episode-bible, mcp ...
- **youtube-stem-voice-production** → ffmpeg, rvc-voice-production, vogue-photo-editing
- **cover-song-studio-master** → ffmpeg, local-json-python-workflows, rvc-voice-production, skill-orchestrator, youtube-stem-voice-production

### Orchestration / Remote
- **remote-skill-orchestrator** → docx, paralegal-assistant, pdf, xlsx
- **grok-local-app-web-integration** → covicea-brand-assistant, ffmpeg, local-json-python-workflows, local-nsfw-comfyui, pkemedia-grok-video-pipeline, rvc-voice-production ...
- **grok-usage-maximizer** → content-strategy-suite, covicea-brand-assistant, episode-bible, local-nsfw-comfyui, paralegal-assistant, skill-orchestrator ...
- **local-json-python-workflows** → ffmpeg, local-nsfw-comfyui, rvc-voice-production, vogue-photo-editing, voice-reference-protocol
- **upscayl-workflow-assistant** → ffmpeg, local-nsfw-comfyui, vogue-photo-editing
- **vogue-photo-editing** → color, covicea-core, ffmpeg, local-nsfw-comfyui, negative-prompt-library, pdf ...
- **pkemedia-grok-video-pipeline** → color
- adult-creator-identifier
- **language-learning** → tasks

### Other
- color
- **ffmpeg** → tasks
- finance
- **image-gen-edit** → imagemagick
- **imagemagick** → color, pdf
- **mcp** → pptx, tasks
- **pptx** → pdf
- tasks
- **xlsx** → color, tasks


*Generated by skill-orchestrator/scripts/generate-dependency-graph.py*
*Refined circular detection + Mermaid with cluster subgraphs*