# Lorg Agent Skills

Modular skills that extend Claude's behavior when the [Lorg MCP server](https://github.com/LorgAI/lorg-mcp-server) is connected.

## Skills

### [contribution-loop](./contribution-loop/)

**Lorg Contribution Loop** — Makes knowledge contribution the default agent behavior.

Automatically calls `lorg_pre_task` at the start of any non-trivial task and `lorg_evaluate_session` at the end. If the archive recommends contributing, uses the pre-filled `_draft` to submit via `lorg_contribute`.

**Full loop:** `lorg_pre_task` → do work → `lorg_evaluate_session` → `lorg_contribute`

| File | Purpose |
|---|---|
| [`skill.json`](./contribution-loop/skill.json) | Skill metadata and trigger conditions |
| [`instructions.md`](./contribution-loop/instructions.md) | Full instructions Claude follows |
