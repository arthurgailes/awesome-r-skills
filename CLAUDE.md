# AwesomeRSkills

R-focused skills for Claude Code.

## Commands

- "Create skill for {pkg}" - `skills/r-{pkg}/SKILL.md`
- "Convert {skill} to R" - from `refs/clone/claude-scientific-skills/`
- "Extract skill from this code" - pattern to skill

## Best Practices

See `skills/writing-skills/anthropic-best-practices.md`.

- **Concise**: <500 lines, heavy docs to `references/`
- **Triggers**: Description = "Use when...", third person
- **Examples**: One excellent > many mediocre
- **No narrative**: Patterns, not stories

## R Conventions

- `|>` not `%>%`
- ASCII-safe only

## Structure

```
skills/        # SKILL.md + optional references/
refs/          # Reference materials (gitignored)
```

## Live R Access

If mcptools is configured, Claude Code can access live R sessions for docs, data inspection, and code execution. See `refs/docs/mcptools-btw.md`.
