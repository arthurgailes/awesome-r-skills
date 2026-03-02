# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

AwesomeRSkills: Opinionated R skills for Claude Code. **Goal-oriented, not package-centric.** The value is judgment (when to use which tool), opinions (recommended approaches), and cross-cutting patterns.

## Skill Types

1. **Goal skills** (`r-{goal}`): Encode judgment, recommend tools for a goal
2. **Package refs** (`r-{package}`): Detailed patterns for goal skills to reference
3. **Meta skills**: How to create skills (e.g., `writing-skills`)

## Creating Skills

**Use TDD methodology** from `skills/writing-skills/SKILL.md`:
1. Run pressure scenario WITHOUT skill (baseline)
2. Write minimal skill addressing failures
3. Re-test and close loopholes

**SKILL.md structure:**
```yaml
---
name: skill-name-with-hyphens
description: Use when [triggering conditions]. Third person, no workflow summary.
---
```

**Key constraints:**
- <500 lines in SKILL.md; heavy docs go to `references/` subdirectory
- Description starts with "Use when...", triggers only (NOT what skill does)
- One excellent example beats many mediocre ones

See `skills/writing-skills/anthropic-best-practices.md` for Anthropic's official guidance.

## R Conventions

- `|>` not `%>%`
- ASCII-safe strings only (no unicode)

## Structure

```
skills/           # Each skill: SKILL.md + optional references/
refs/             # Research materials (gitignored)
  docs/           # Package vignettes, extracted docs
  clone/          # Cloned repos for reference
plan.md           # Roadmap and interview queue
```

## Live R Access

If mcptools MCP server is configured, use btw tools for docs and code execution. See `refs/docs/mcptools-btw.md`.
