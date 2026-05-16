# AI Coding Configuration

Shared user-level rules and personal skills for AI coding tools.

## Rules

Maintain each rule once under:

```text
rules/*.md
```

Claude Code reads them directly through:

```text
~/.claude/rules -> ~/.config/ai-coding/rules
```

Codex only reads a single user-level AGENTS file, so `make setup-ai`
generates:

```text
generated/codex/AGENTS.md
```

and deploys:

```text
~/.codex/AGENTS.md -> ~/.config/ai-coding/generated/codex/AGENTS.md
```

Do not edit generated files directly.

## Skills

Maintain personal skills under:

```text
skills/<skill-name>/SKILL.md
```

Claude Code reads them through:

```text
~/.claude/skills -> ~/.config/ai-coding/skills
```

Codex keeps its system skills in `~/.codex/skills/.system`, so `make setup-ai`
links only personal skill subdirectories into `~/.codex/skills/`.

opencode can read:

```text
~/.config/opencode/skill -> ~/.config/ai-coding/skills
```

## Deploy

```bash
make setup-ai
```
