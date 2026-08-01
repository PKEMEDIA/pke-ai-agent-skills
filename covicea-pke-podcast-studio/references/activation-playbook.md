# Activation Playbook

## Chat / iOS / web (permanent)
Say any of:
- Activate PKE Podcast Studio
- Activate Coviceá production team
- Full podcast studio online
- Produce episode on [topic]
- React live as co-host
- Social ATS push for #1

Registry: `config/permanent-activation.json` → `skills.covicea-pke-podcast-studio.permanent = true`

## Repo install
```bash
git clone https://github.com/PKEMEDIA/pke-ai-agent-skills.git
# copy skill into Grok skills dir if using local skill loader
cp -R covicea-pke-podcast-studio ~/.grok/skills/   # path may vary by surface
bash skill-creator/scripts/validate-skill.sh covicea-pke-podcast-studio
bash scripts/ci-validate-skills.sh
```

## GitHub automation
- Actions: `.github/workflows/pke-skill-ci.yml` + `pke-podcast-studio.yml`
- Manual re-validate: Actions → PKE Podcast Studio → Run workflow
- Docs: `docs/GITHUB-AUTOMATION.md`

## Orchestrator integration
After install:
```bash
bash skill-orchestrator/scripts/bulk-validate.sh
bash scripts/pke-self-heal.sh
bash scripts/pke-self-heal.sh --push
```

## Notion
- Empire OS hub tracks status
- 3-2 Podcast Production Hub DB for episode rows (Status: Idea → Script → Recorded → Edited → Published)

## Spicy
Default ON. Keep sophisticated brand voice; escalate heat only when content earns it.
