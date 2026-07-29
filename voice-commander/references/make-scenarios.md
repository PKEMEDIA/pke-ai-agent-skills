# The 5 Core Make.com Scenarios

## Scenario 1: Legal Attachment → Legal Tracker
**Trigger**: Gmail "New Email" (label: Legal-Evidence or subject contains "Legal" or attachment present) OR Google Drive "Watch Files in Folder" (Evidence folder).

**Actions**:
- Parse email/Drive file metadata.
- Create page in Legal & Paralegal Tracker DB.
- Set properties:
  - Claim Type: SELECT from email subject or filename (MHRC, Theft/Chargeback, Hotel Dispute, Small Claims, etc.).
  - Status: "Open" or "Evidence Gathering".
  - Deadline: Calculate from email date + 7/30/90 days (use Make date functions).
  - Document Links / Evidence Log: Attach file or link to Drive file.
  - Notes: Full email body or file description.
- Optional: Send confirmation Gmail + trigger native Notion automation for deadline reminder.

**Notes**: Use exact SELECT options from DB schema. For multiple files: Iterator + Array Aggregator. Security: Scope Gmail/Drive connection to specific labels/folders only.

## Scenario 2: Drive file → COVICEA Visual Log
**Trigger**: Google Drive "Watch Files in Folder" (COVICEA Raw or Distraction BTS).

**Actions**:
- Get file metadata (name, ID, link, created time).
- Create page in COVICEA Visual Production Log DB.
- Set Project/Asset from filename, Status "Prompt" or "ComfyUI", Prompt enriched from covicea-core locked standards, Image ID/Link, Related Podcast/Content if keywords match.
- Optional: Call ComfyUI consistency workflow or notify via Voice Commander.

**Key**: Uses covicea-distraction-image-defaults and covicea-core for prompt enrichment.

## Scenario 3: Calendar event → Content Strategy
**Trigger**: Google Calendar "Watch Events" (Content/Podcast calendar).

**Actions**:
- On new/updated event: Create or update page in Content Strategy & Calendar DB.
- Map Pillar/Content Type, Date, Social Cadence, Status "Scheduled", Link to Podcast Hub if episode/guest mentioned.
- Optional: Auto-create social post drafts.

## Scenario 4: Master Dashboard Summary
**Trigger**: Schedule (daily 8am or weekly Monday).

**Actions**:
- Query multiple DBs via Notion modules.
- Aggregate Podcast production counts, Legal open claims/deadlines, COVICEA recent assets, Content Strategy scheduled vs posted.
- Generate formatted email or rich text summary to Gmail or Master Dashboard.
- Enhancement: Triggerable by Voice Commander "send empire summary".

## Scenario 5: Voice Commander Webhook Trigger
**Make Side**: Webhook trigger module → router/filters on payload "scenario" field → execute Scenarios 1-4 actions → Webhook Response `{ "status": "ok", "notion_page_id": "xxx" }`.

**Voice Commander Side**: Construct JSON payload and POST to Make webhook URL. On success confirm with Notion page links. Fallback: direct Notion MCP create/update.

**Security**: Scope connections narrowly. Delay between Notion calls (3 req/sec). Legal requires confirmation step. Log all webhook calls in Automation Log DB.
