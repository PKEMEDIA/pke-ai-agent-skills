#!/usr/bin/env python3
"""Skill ecosystem dependency graph generator for skill-orchestrator."""
from __future__ import annotations

import re
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

CLUSTERS = {
    "Core Meta Layer": [
        "skill-creator",
        "skill-orchestrator",
        "skill-test-suite",
        "skill-installer",
    ],
    "Legal / Paralegal": [
        "paralegal-assistant",
        "docx",
        "pdf",
        "pdf-form-filler",
        "covicea-podcast-script-to-docx",
        "skills-learned-script",
        "memory-edit",
    ],
    "COVICEA Visual & Media Production": [
        "covicea-core",
        "covicea-face-lock",
        "covicea-selfie-image-defaults",
        "covicea-distraction-image-defaults",
        "covicea-realistic-hair-skin-lighting",
        "covicea-photoreal-workflow",
        "covicea-gym-mirror-selfie-retouch",
        "covicea-comfyui-consistency",
        "covicea-brand-assistant",
        "covicea-aloha-shade-ohana",
        "local-nsfw-comfyui",
        "negative-prompt-library",
        "photoreal-hair-anisotropic-master",
        "photoreal-skin-master",
        "photoreal-skin-sss-master",
        "photoreal-undetectable-portrait-master",
        "pretty-kitty-model-management",
        "pretty-kitty-photorealism",
        "spicy-male-erotic-prompt-optimizer",
        "consistent-identity-batch-processor",
        "distraction-image-defaults",
        "mirror-selfie-corrector",
    ],
    "Brand / Voice / Content Strategy": [
        "content-strategy-suite",
        "episode-bible",
        "grok-sentient-editor",
        "aave-assistant",
        "pk-svwo-v1-0",
    ],
    "Voice & Audio Production": [
        "rvc-voice-production",
        "voice-reference-protocol",
        "voice-commander",
        "youtube-stem-voice-production",
        "cover-song-studio-master",
    ],
    "Grok Build / App Skills": [
        "design-ui",
        "building-games",
        "controls",
        "generate2dsprite",
        "generate2dmap",
        "video2dsprite",
        "imagine",
        "auth",
        "neon",
        "threejs",
        "multiplayer-p2p",
        "game-asset-core",
        "game-animation-frames",
        "game-character-consistency",
        "game-tilesets",
        "game-ui-icons",
    ],
    "Orchestration / Remote": [
        "remote-skill-orchestrator",
        "grok-local-app-web-integration",
        "grok-usage-maximizer",
        "local-json-python-workflows",
        "upscayl-workflow-assistant",
        "vogue-photo-editing",
        "pkemedia-grok-video-pipeline",
        "adult-creator-identifier",
        "language-learning",
    ],
}


def scan_skills(base_paths):
    skills = {}
    for base in base_paths:
        root = Path(base)
        if not root.is_dir():
            continue
        for skill_dir in sorted(root.iterdir()):
            if not skill_dir.is_dir():
                continue
            md = skill_dir / "SKILL.md"
            if not md.is_file():
                continue
            name = skill_dir.name
            text = md.read_text(encoding="utf-8", errors="replace")
            lines = text.count("\n") + (0 if text.endswith("\n") else 1 if text else 0)
            skills[name] = {
                "path": str(skill_dir),
                "lines": lines,
                "text": text,
            }
    return skills


def get_real_skill_names(skills):
    return sorted(skills.keys(), key=len, reverse=True)


def extract_refs(text, all_names):
    refs = set()
    lower = text.lower()
    for name in all_names:
        # word-ish boundary match for skill name tokens
        if re.search(rf"(?<![a-z0-9-]){re.escape(name)}(?![a-z0-9-])", lower):
            refs.add(name)
    return refs


def cluster_skills(skills):
    assigned = set()
    clusters = {}
    for label, members in CLUSTERS.items():
        present = [m for m in members if m in skills]
        if present:
            clusters[label] = present
            assigned.update(present)
    other = sorted(n for n in skills if n not in assigned)
    if other:
        clusters["Other"] = other
    return clusters


def build_full_graph(skills):
    all_names = get_real_skill_names(skills)
    dependency_map = {}
    for name, data in skills.items():
        refs = extract_refs(data["text"], all_names)
        refs.discard(name)
        dependency_map[name] = sorted(refs)

    # Simple cycle detection on mutual refs (2-cycles) and DFS for longer
    cycles = []
    for a, refs in dependency_map.items():
        for b in refs:
            if a in dependency_map.get(b, []) and a < b:
                cycles.append([a, b])

    # DFS cycles
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {n: WHITE for n in skills}
    stack = []

    def dfs(u):
        color[u] = GRAY
        stack.append(u)
        for v in dependency_map.get(u, []):
            if v not in color:
                continue
            if color[v] == GRAY:
                if u < v or True:
                    i = stack.index(v)
                    cyc = stack[i:] + [v]
                    if cyc not in cycles and list(reversed(cyc)) not in cycles:
                        cycles.append(cyc)
            elif color[v] == WHITE:
                dfs(v)
        stack.pop()
        color[u] = BLACK

    for n in skills:
        if color[n] == WHITE:
            dfs(n)

    clusters = cluster_skills(skills)
    stats = {
        "total_skills": len(skills),
        "total_lines": sum(s["lines"] for s in skills.values()),
        "generated": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC"),
    }
    return dependency_map, clusters, stats, cycles


def generate_markdown(dependency_map, clusters, stats, cycles):
    lines = []
    lines.append("# Skill Ecosystem Dependency Graph (Auto-Generated)")
    lines.append("")
    lines.append(f"**Generated**: {stats['generated']}")
    lines.append(f"**Total Skills Scanned**: {stats['total_skills']}")
    lines.append(f"**Total Lines across all SKILL.md files**: {stats['total_lines']}")
    lines.append("")
    if cycles:
        lines.append(f"**Circular Dependencies**: {len(cycles)} potential cycle(s)")
        for c in cycles[:12]:
            lines.append(f"- {' → '.join(c)}")
    else:
        lines.append("**Circular Dependencies**: None detected ✓")
    lines.append("")
    lines.append("## Clusters")
    lines.append("")
    for label, members in clusters.items():
        lines.append(f"### {label}")
        for skill in members:
            refs = dependency_map.get(skill, [])
            if refs:
                lines.append(
                    f"- **{skill}** → {', '.join(refs[:6])}"
                    + (" ..." if len(refs) > 6 else "")
                )
            else:
                lines.append(f"- {skill}")
        lines.append("")
    lines.append("")
    lines.append("*Generated by skill-orchestrator/scripts/generate-dependency-graph.py*")
    lines.append("*Refined circular detection + Mermaid with cluster subgraphs*")
    return "\n".join(lines)


def generate_mermaid(dependency_map, clusters):
    out = ["flowchart LR"]
    # Limit edges for readability
    edges = set()
    for src, refs in dependency_map.items():
        for dst in refs[:4]:
            edges.add((src, dst))
    for i, (label, members) in enumerate(clusters.items()):
        sid = f"c{i}"
        safe_label = label.replace('"', "'")
        out.append(f'  subgraph {sid}["{safe_label}"]')
        for m in members:
            out.append(f"    {m}")
        out.append("  end")
    for src, dst in sorted(edges)[:200]:
        out.append(f"  {src} --> {dst}")
    return "\n".join(out)


if __name__ == "__main__":
    BASE_PATHS = [
        "/root/.grok/server-skills",
        "/root/.grok/skills",
        "/home/workdir/.grok/skills",
        "/workspace/.grok/skills",
    ]

    print("Scanning skills...")
    skills = scan_skills(BASE_PATHS)
    print(f"Found {len(skills)} skills.")

    print("Building refined dependency graph...")
    dependency_map, clusters, stats, cycles = build_full_graph(skills)

    print(
        f"Detected cross-references for "
        f"{len([k for k, v in dependency_map.items() if v])} skills."
    )
    if cycles:
        print(f"⚠️  Potential circular dependencies found: {len(cycles)}")
    else:
        print("✓ No harmful circular dependencies detected.")

    markdown = generate_markdown(dependency_map, clusters, stats, cycles)
    mermaid = generate_mermaid(dependency_map, clusters)

    written = []
    for candidate in [
        Path("/home/workdir/.grok/skills/skill-orchestrator/references"),
        Path("/root/.grok/server-skills/skill-orchestrator/references"),
    ]:
        candidate.mkdir(parents=True, exist_ok=True)
        (candidate / "dependency-graph.md").write_text(markdown, encoding="utf-8")
        (candidate / "dependency-graph.mmd").write_text(mermaid, encoding="utf-8")
        written.append(str(candidate))

    print("\n✅ Updated files under:")
    for w in written:
        print(f"   - {w}/dependency-graph.md")
        print(f"   - {w}/dependency-graph.mmd")

    print("\n=== Preview ===")
    print("\n".join(markdown.split("\n")[:45]))
