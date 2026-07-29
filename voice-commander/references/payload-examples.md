# Voice Commander Payload Examples

## Legal Attachment
```json
{
  "command": "legal_attachment",
  "source": "gmail",
  "scenario": "legal",
  "notion_db": "legal-tracker",
  "data": {
    "claim_type": "Hotel Dispute",
    "status": "Evidence Gathering",
    "deadline_days": 30,
    "notes": "Email body or attachment description",
    "document_link": "https://drive.google.com/..."
  },
  "timestamp": "2026-07-28T20:00:00Z"
}
```

## COVICEA Visual Log
```json
{
  "command": "covicea_visual_log",
  "source": "drive",
  "scenario": "covicea",
  "notion_db": "covicea-visual-log",
  "data": {
    "project_asset": "Distraction Album Cover",
    "status": "Prompt",
    "prompt": "Apply covicea-core locked standards",
    "image_id": "drive-file-id",
    "related_episode": null
  },
  "timestamp": "2026-07-28T20:00:00Z"
}
```

## Content Strategy
```json
{
  "command": "content_schedule",
  "source": "calendar",
  "scenario": "content",
  "notion_db": "content-strategy",
  "data": {
    "pillar": "Podcast",
    "date": "2026-08-01",
    "social_cadence": "X, IG, YouTube Shorts",
    "status": "Scheduled"
  },
  "timestamp": "2026-07-28T20:00:00Z"
}
```

## Dashboard Summary
```json
{
  "command": "empire_summary",
  "source": "voice",
  "scenario": "dashboard",
  "notion_db": "master-dashboard",
  "data": {
    "period": "weekly",
    "include": ["podcast", "legal", "covicea", "content"]
  },
  "timestamp": "2026-07-28T20:00:00Z"
}
```
