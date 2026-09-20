# Prompts layout

- **`vN/`** — immutable versioned copies. Never overwrite an old `vN` in place; bump to `vN+1`.
- **Root `*.md`** — live working mirror of whatever `../current.json` pins (`prompt_set`).
- Sync after pin change: `cp prompts/vN/*.md prompts/` (the three lane files only).
- See `../ECOSYSTEM.md` §1 for the full bump runbook.
