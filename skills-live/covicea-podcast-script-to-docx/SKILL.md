---
name: covicea-podcast-script-to-docx
description: Use to convert Covicea-Aloha-Shade-Ohana podcast episode content into a professionally branded .docx script document with timed sections, headers, footers, page numbers and blockchain forensics subsection. Trigger on create podcast script docx, podcast to word, aloha shade ohana script document, covicea episode docx, generate script file.
---

# Covicea Podcast Script to .docx Generator

## Purpose
This skill makes turning your Covicea podcast scripts into polished, ready-to-record Word documents fast and consistent. It applies the signature Aloha-Shade-Ohana branding, proper formatting for timed sections, and includes the full blockchain forensics analysis block.

## How to Use (Simple Workflow)
1. Prepare your episode content as plain text or markdown with clear section headings and timestamps (example: "COLD OPEN (0:00 – 3:30)", "SECTION 1: ...").
2. Open the generator script: `/home/workdir/.grok/skills/covicea-podcast-script-to-docx/scripts/generate-episode-docx.js`
3. Edit only the `children:` array — replace the example sections with your new episode content. Keep the title block, header, footer, and styling intact.
4. Run the generator:
   ```bash
   node /home/workdir/.grok/skills/covicea-podcast-script-to-docx/scripts/generate-episode-docx.js
   ```
5. The finished .docx appears in `/home/workdir/artifacts/` (named Covicea_Podcast_Script_Final.docx or edit the path in the script for custom names).

## What the Generator Includes (Do Not Change Unless Needed)
- Branded header with "Covicea-Aloha-Shade-Ohana | Podcast Script"
- Page numbers and professional footer
- Styled Heading 1 for each timed section
- Italic production notes in gray
- Dedicated Blockchain Forensics subsection ready to drop in
- Consistent Covicea visual identity (colors, fonts, spacing)
- Clean US Letter layout with 0.75" margins

## Customization Tips
- For a new episode, duplicate the generator file and rename it (e.g. generate-33ep-docx.js).
- Change only the content inside the `children` array.
- To add images or tables later, extend the script using the docx library patterns already in place.
- The output is always validated automatically.

## Why This Skill Exists
Creating a properly formatted, on-brand .docx script used to require writing custom JS every time. This skill turns it into a repeatable, low-effort task so you can focus on the content and the show.

## Related Skills
- covicea-aloha-shade-ohana (for writing the actual episode content in your voice)
- docx (the underlying engine this skill wraps)

Run the generator now with your latest episode content and you will have the document in seconds.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

