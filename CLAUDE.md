# AwesomeRSkills

Opinionated R skills for Claude Code.

## Core Principle

**Goal-oriented, not package-centric.**

The value isn't in documenting packages (LLMs can fetch docs). The value is in:
- **Judgment**: When to use collapse vs dplyr
- **Opinions**: Which tool is best for a goal
- **Cross-cutting patterns**: GDAL underneath sf, Arrow underneath DuckDB

See `plan.md` for full context.

## Skill Types

1. **Goal skills** (`r-{goal}`): Encode judgment, recommend tools
2. **Package refs** (`r-{package}`): Detailed patterns for goal skills to reference
3. **Meta skills**: How to create skills

## Commands

- "Create goal skill for {goal}" - Judgment + tool recommendations
- "Create package reference for {pkg}" - Use `skills/r-pkg-skill/SKILL.md`

## Best Practices

See `skills/writing-skills/anthropic-best-practices.md`.

- **Concise**: <500 lines, heavy docs to `references/`
- **Triggers**: Description = "Use when...", third person
- **Judgment over docs**: Opinions, gotchas, when-to-use

## R Conventions

- `|>` not `%>%`
- ASCII-safe only

## Structure

```
skills/        # SKILL.md + optional references/
refs/          # Reference materials (gitignored)
  docs/        # Package vignettes, extracted docs
  clone/       # Cloned repos
```

## Live R Access

If mcptools configured, use for docs and code execution. See `refs/docs/mcptools-btw.md`.
