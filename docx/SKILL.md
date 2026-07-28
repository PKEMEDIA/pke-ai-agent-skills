---
name: docx
description: >
  Structure professional documents and export Markdown plus Word-compatible HTML/DOC packages
  from skill outputs, orchestration plans, and validation reports. Use for playbooks, runbooks,
  executive summaries, and skill inventory docs. Triggers on docx, document, report, word, playbook.
metadata:
  short-description: "Document structure + export"
  optimized-for: [ios, web, grok-build]
---

# DOCX / Documents

Turn operational outputs into clean, shareable documents.

## When to Use
- Export skill inventories or orchestration plans
- Produce playbooks / runbooks from multi-step work
- User asks for Word, DOCX, report, or document package

## Instructions
1. Structure title, subtitle, sections, bullets, metadata
2. Prefer short executive summary then detailed sections
3. Export Markdown for agents and .doc HTML for Word
4. Include validation + iOS/web checklist when Grok Build related
5. Keep prose scannable; no placeholder lorem

## Best Practices
- One idea per bullet
- Always stamp generatedAt and owner metadata
- Pair with skill-orchestrator synthesis step
