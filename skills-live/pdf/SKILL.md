---
name: pdf
description: Use this skill whenever the user wants to create, read, edit, fill, merge, split, or manipulate PDF files. Triggers include any mention of 'PDF', '.pdf', 'pdf form', 'fillable pdf', 'pdf report', or requests involving PDF generation, OCR, annotation, watermarking, or conversion from/to other formats. Also use for tax documents, forms, and high-quality print-ready output.
---

# PDF Skill (Custom Override — Refactored July 2026)

## Overview
Handles PDF creation, form filling, reading (text + OCR), editing, merging, splitting, and professional output. This is the persistent custom override.

## Decision Flow

1. **Fillable PDF form to complete?** → Use `pdf-form-filler` skill (primary) + this skill for advanced cases.
2. **Creating new PDF from scratch or Markdown?** → Use `references/creating-pdfs.md` or pandoc + weasyprint / reportlab patterns.
3. **Reading / extracting text from PDF?** → `pdftotext`, `pdfinfo`, or OCR via tesseract / ocrmypdf when needed.
4. **Merging, splitting, or page manipulation?** → Use `pdfunite`, `pdftk`, `qpdf`, or Python (pypdf / PyMuPDF).
5. **High-quality reports, tax forms, or branded output?** → Combine with `docx` (for source) + LibreOffice conversion, or direct PDF libraries.
6. **Visual QA or page images?** → `pdftoppm` (from poppler-utils).

## Key Integrations
- Works tightly with `pdf-form-filler` for form filling workflows.
- Used by `paralegal-assistant` for legal packets and affidavits.
- Supports `covicea-podcast-script-to-docx` when final output needs to be PDF.
- Often paired with `docx` for hybrid document pipelines (create in Word → convert to PDF).

## References (Load On Demand)
- `forms.md` and `forms/` directory — Fillable form handling patterns.
- `reference.md` and `tax.md` — Existing specialized references (keep and expand as needed).
- `references/creating-pdfs.md` — Patterns for generating PDFs from Markdown, HTML, or code (to be expanded).
- `references/pdf-manipulation.md` — Merging, splitting, page extraction, watermarking, encryption (to be expanded).

## Common Tools Available
- `pdftotext`, `pdfinfo`, `pdftoppm`, `pdfunite`, `qpdf`, `pdftk`
- Python: pypdf, PyMuPDF (fitz), reportlab, weasyprint
- LibreOffice for high-fidelity conversion from .docx / .odt

## Anti-Patterns
- Do not use this skill for simple text extraction when pandoc on .docx is sufficient.
- For complex form filling, prefer the dedicated `pdf-form-filler` skill first.
- Always validate page count and visual layout after major transformations.

This refactored core is lean. Detailed patterns live in the references/ and existing supporting files (forms.md, tax.md, etc.).

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

