---
name: pdf-form-filler
description: Use this skill whenever filling PDF forms or creating filled-in PDF documents is required. Activate for completing fillable PDF forms, adding text annotations to non-fillable PDFs, populating tax forms contracts or applications, and generating output PDFs with entered data. Works in addition to the pdf skill for specialized form filling tasks.
---

# PDF Form Filler

## Overview

This skill provides deterministic workflows and helper scripts to fill PDF form fields (both AcroForm fillable fields and text annotations on non-fillable PDFs) and produce verified filled output files. Use it to create completed forms from blank templates.

## Core Principles

- Always start by checking if the PDF has fillable fields (`check_fillable_fields.py` now warns on deprecated XFA).
- Extract exact field IDs, labels (`/TU` tooltip), types, and flags (`/Ff` — especially `required` and `read_only`).
- **Automated validation + gap detection enabled**: Type/format rules + ability to read the form, detect missing fields (respecting Required flags from the PDF), and generate targeted questions. See `references/pdf-form-standards.md` for the AcroForm model the skill implements.
- Render every filled PDF to images and visually inspect using read_file on the PNGs.
- Prefer structure extraction for accurate coordinates over pure visual estimation.
- For tax forms use whole dollars only.

## Fillable Form Workflow (Preferred when available)

**Automated validation is now built-in.** The system applies type checks + smart label-based rules (SSN, EIN, phone, ZIP, email, date, amount/currency, etc.) automatically.

1. Detect fillable status  
   `python scripts/check_fillable_fields.py input.pdf`

2. Extract all field metadata  
   `python scripts/extract_form_field_info.py input.pdf field_info.json`  
   Output includes field_id (exact key to use), label, type, page, options, checked/unchecked values.

3. Build field_values.json  
   Create array of objects with matching "field_id", "page", and "value".  
   Use exact checked_value for checkboxes; pick valid radio/choice option.

4. **Validate first (strongly recommended)**  
   `python scripts/validate_field_values.py input.pdf field_values.json`  
   Runs full automated rule engine. Fixes errors here before filling. Exits non-zero on any violation.

5. Execute the fill (includes validation)  
   `python scripts/fill_fillable_fields.py input.pdf field_values.json output_filled.pdf`  
   Re-validates and fills only if clean.

6. Visual verification (mandatory)  
   `python scripts/convert_pdf_to_images.py output_filled.pdf verify_dir/`  
   Inspect every page PNG with `read_file` to confirm correct placement and no overlaps.

## Gathering Missing Information (Interactive / Assisted Filling)

When the user provides a PDF form but incomplete data (or none), use this capability to read the form and collect what is needed.

1. Run gap analysis  
   `python scripts/identify_form_gaps.py input.pdf [partial_field_values.json] --output questions.json`  
   This reads the PDF, compares against any data you already have, and produces a prioritized list of missing fields with natural-language questions tailored to each field's label and type.

2. Ask the user the generated questions  
   Use the `questions` array from the output. Ask one by one or in logical batches (identity/financial fields first).  
   Example question generated automatically:  
   `"Please provide the value for the field labeled \"Your first name and middle initial\" (page 1) (format: SSN, phone, date, amount, etc. — I will validate)"`

3. Compile answers into field_values.json  
   For each answered question, create an entry:  
   `{"field_id": "<exact id from questions.json>", "page": <page>, "value": "<user answer>"}`  
   For checkboxes/radios use the exact value strings.

4. Validate the completed set  
   `python scripts/validate_field_values.py input.pdf field_values.json`

5. Proceed to fill as normal.

**When to use this flow**  
- User uploads a blank or partially filled form and says "fill this out for me" or "help me complete this".  
- You have some data (from previous context, another document, or user memory) but not everything.  
- The form has 10+ fields and the user did not provide a complete values file.

The `identify_form_gaps.py` script automatically prioritizes high-importance fields (name, SSN, address, financial amounts, dates, contact info) so you ask the most critical questions first.

## Non-Fillable Form Workflow (Add text via annotations)

1. Extract structural elements for coordinates  
   `python scripts/extract_form_structure.py input.pdf form_structure.json`  
   Provides labels with (x0, top, x1, bottom), horizontal lines, checkboxes as rectangles, and calculated row_boundaries. PDF y=0 is top of page.

2. Analyze structure to map labels to entry areas  
   - Group adjacent text labels that belong together.  
   - Entry fields start after label.x1 + small gap.  
   - Use checkbox centers directly.  
   - Calculate y positions from row_boundaries or label bottoms.

3. Prepare annotations data (JSON or direct args)  
   Use coordinates to call fill_pdf_form_with_annotations.py or equivalent reportlab overlay code.  
   Common pattern: drawString or text annotation at calculated (x, y) for each field value.

4. Fill via annotations script when available  
   `python scripts/fill_pdf_form_with_annotations.py input.pdf annotations.json output.pdf`

5. Always verify visually  
   Render to PNGs and inspect as above. Adjust coordinates if text is misaligned.

## Hybrid Approach (When structure extraction is incomplete)

- Run extract_form_structure.py first.  
- Render pages to high-res images with convert_pdf_to_images.py.  
- Use visual inspection + bounding box checks (check_bounding_boxes.py) to refine missing field positions.  
- Manually calculate or measure remaining coordinates from the images/PDF points.  
- Combine automated structure data with manual overrides in your values/annotations file.

## Available Scripts

All scripts are in the scripts/ directory and executable directly:

- check_fillable_fields.py — Quick yes/no on AcroForm presence
- extract_form_field_info.py — Detailed JSON of every fillable field (IDs, labels, types, pages, options)
- fill_fillable_fields.py — Safe pypdf-based filler with validation
- validate_field_values.py — Standalone pre-flight validator with automated smart rules (SSN, EIN, phone, email, date, amount, etc.)
- identify_form_gaps.py — Analyzes form + partial data; outputs missing fields + prioritized, natural-language questions to ask the user
- extract_form_structure.py — Text labels, lines, checkboxes + coordinates for annotation placement
- fill_pdf_form_with_annotations.py — Overlay text/checkboxes at precise PDF coordinates
- convert_pdf_to_images.py — pdftoppm wrapper; produces PNGs for QA (300 DPI recommended)
- check_bounding_boxes.py / create_validation_image.py — Diagnostic helpers for coordinate debugging

## Critical Rules

- Never skip visual verification step. Field name mismatches and coordinate errors are invisible in raw PDF structure.
- Match field_id exactly (including array indices like [0]).
- For checkboxes/radios use the precise value strings from extraction.
- Backup original PDFs before filling.
- When preparing tax or official forms, round all monetary values to nearest whole dollar.
- If a form has both fillable fields and areas needing extra text, use fillable workflow first then layer annotations.

## Relation to pdf Skill

Use the core pdf skill for all other PDF operations (merge, split, text/table extraction, watermark, encryption, reportlab creation from scratch, OCR). This skill is the dedicated extension for form population and filled-document creation. Scripts here are optimized copies focused on the fill/annotate path.

## Troubleshooting

- Field not found errors: Re-extract field_info.json; confirm exact spelling/case.
- Text appears in wrong place: Re-render, measure from image, recalculate coords (PDF coords have y increasing downward from top).
- Checkbox not toggling: Use the exact checked_value string provided in extraction output.
- Scanned/image PDFs: Rely on structure extraction + visual hybrid; pure fillable detection will fail.

Run validate-skill.sh after any changes to this skill.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

