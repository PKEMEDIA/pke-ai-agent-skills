---
name: docx
description: Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx or .dotx files). Triggers include any mention of 'Word doc', 'word document', '.docx', '.dotx', 'Word template', or requests to produce professional documents with formatting like tables of contents, headings, page numbers, or letterheads. Also use when extracting or reorganizing content from .docx/.dotx files, inserting or replacing images in documents, performing find-and-replace in Word files, working with tracked changes or comments, or converting content into a polished Word document. If the user asks for a 'report', 'memo', 'letter', 'template', 'ticket', 'card', or similar deliverable as a Word or .docx file, use this skill. Do NOT use for PDFs, spreadsheets, Google Docs, or general coding tasks unrelated to document generation.
---

# DOCX Skill (Custom Override — Refactored July 2026)

## Overview
Handles creation, editing, analysis, and professional formatting of .docx and .dotx files. This is the persistent custom override (takes precedence over bundled version).

**Core Principle**: 
- If a template is attached → always use the editing workflow first.
- If creating from scratch → use the docx JavaScript library with the patterns in references/.
- For reading/analysis → prefer pandoc + targeted XML unpacking when needed.

## Decision Flow

1. **Template attached or .dotx provided?**  
   → Read `editing.md` (or the original bundled editing.md) immediately. Use `scripts/office/unpack.py`, `replace_text.py`, `replace_field.py`, etc. Never create from scratch when a template exists.

2. **Creating new professional document from scratch?**  
   → Use `references/creating-new-documents.md` for the full JavaScript patterns (imports, page setup, headers/footers, TOC, tables, images, tracked changes, etc.). Install `docx` via npm if needed.

3. **Reading or analyzing existing .docx?**  
   - Quick text + tracked changes: `pandoc --track-changes=all input.docx -o output.md`
   - Deep XML inspection: `python scripts/office/unpack.py input.docx unpacked/`
   - Convert to images/PDF for visual QA: Use `scripts/office/soffice.py --headless --convert-to pdf` + `pdftoppm`

4. **Legacy .doc files?**  
   Convert first: `python scripts/office/soffice.py --headless --convert-to docx document.doc`

5. **Complex professional output** (reports, legal packets, scripts, contracts)?  
   Combine with `pdf`, `pdf-form-filler`, `paralegal-assistant`, or `covicea-podcast-script-to-docx` as needed.

## Key Workflows

**Editing a Template (Most Common)**
- Unpack → Replace text/fields/sections using the provided scripts → Repack and validate.
- See `editing.md` for the complete step-by-step + all available scripts.

**Creating New Documents**
- Use the `docx` library with explicit US Letter page size (docx-js defaults to A4).
- Follow the patterns and full import list in `references/creating-new-documents.md`.
- Always validate after creation: `python scripts/office/validate.py output.docx`

**Tracked Changes & Comments**
- Accept all: Use `scripts/accept_changes.py`
- Preserve or manipulate comments: Handled via XML editing after unpacking.

**Images & Media**
- Add via `ImageRun` in the docx library or by manually editing relationships after unpacking.
- See `references/creating-new-documents.md` for both methods.

## Integration with Ecosystem
- Works closely with `pdf` / `pdf-form-filler` for hybrid document pipelines.
- Used by `paralegal-assistant`, `covicea-podcast-script-to-docx`, `skills-learned-script`, and `episode-bible` for professional output.
- Memory-edit can store document templates or standard clauses when appropriate.

## References (Load On Demand)
- `editing.md` — Primary guide for template editing (read first when template is present).
- `references/creating-new-documents.md` — Full JavaScript patterns, imports, page setup, headers/footers, TOC, tables, images, advanced features.
- `references/tracked-changes-and-comments.md` — Detailed XML-level handling (if needed beyond editing.md).
- `references/validation-and-conversion.md` — LibreOffice, pandoc, pdftoppm, and validation scripts usage.

## Anti-Patterns
- Never create a new document from scratch when a .dotx or filled template is attached.
- Do not edit XML directly when script-based replacement tools exist.
- Always set explicit page size (US Letter) when using the docx library.
- Validate documents after creation or major edits.

This refactored version keeps the core lean while preserving full capability through progressive disclosure to references/ and the existing editing.md. All original scripts remain available in `scripts/`.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

