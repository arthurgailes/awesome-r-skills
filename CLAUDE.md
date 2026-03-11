# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

R skills plugin for AI coding agents (Claude Code, Codex, OpenCode). Core value: `/r-package-skill` auto-generates skills from any R package's documentation, so agents can use packages they weren't trained on.

## Skill Types

1. **Skill generators** (`r-package-skill`, `writing-r-skills`): Tools to create new skills
2. **Package skills** (`r-collapse`, `r-mapgl`, etc.): Reference docs for specific R packages
3. **Development skills** (`creating-r-package`): R package development workflows

## Creating Skills

**Use TDD methodology** from `skills/writing-r-skills/SKILL.md`:

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

- <500 words in SKILL.md; heavy docs go to `references/` subdirectory
- Description starts with "Use when...", triggers only (NOT what skill does)
- One excellent example beats many mediocre ones
- **Update README.md** when adding a new skill (add to skills table)
- Required sections: Overview, When to Use, Quick Reference, Common Mistakes, When NOT to Use

See `skills/writing-r-skills/anthropic-best-practices.md` for Anthropic's official guidance.

## Adding Package Skills to Plugin

**When user says "add a package skill" or "add skills/r-{package}":**

- Add to `./skills/r-{package}/` in THIS repository (the plugin itself)
- Follow workflow in `skills/r-package-skill/SKILL.md`
- Update `README.md` with new skill entry
- This is DISTINCT from users adding skills to their own `~/.claude/skills/` locally

**Plugin development vs user usage:**

- **Plugin development** (this context): Creating skills in `./skills/` for distribution
- **User usage**: End users installing from marketplace to their local environment

## R Conventions

- `|>` not `%>%`
- ASCII-safe strings only (no unicode)

## Structure

```
skills/                  # Each skill: SKILL.md + optional references/
.claude-plugin/          # Plugin marketplace metadata
  marketplace.json       # Claude Code marketplace config
  plugin.json           # Plugin metadata
.codex/INSTALL.md       # Codex installation instructions
.opencode/INSTALL.md    # OpenCode installation instructions
refs/                   # Research materials (gitignored)
  docs/                 # Package vignettes, extracted docs
  clone/                # Cloned repos for reference
```

## Plugin Distribution

Plugin available for multiple agents:

- **Claude Code**: `/plugin marketplace add arthurgailes/awesome-r-skills` then `/plugin install awesome-r-skills@awesome-r-skills`
- **Codex/OpenCode**: Fetch installation instructions from `.codex/INSTALL.md` or `.opencode/INSTALL.md`

## Live R Access

If mcptools MCP server is configured, use btw tools for docs and code execution. See `refs/docs/mcptools-btw.md`.

## Updating Package Skills

**When user says "update package skills" (plural):**

1. Identify ALL R package skills in `skills/r-*/`
2. For EACH package skill, thoroughly:
   - Fetch latest documentation (pkgdown site, function reference)
   - Compare against existing `SKILL.md` and `references/API.md`
   - Identify: new functions, new parameters, changed defaults, deprecated features
   - Update all affected files (SKILL.md, API.md, reference docs)
   - Be thorough - check function reference index, not just main docs

**When user says "update skills/r-{package}" (singular):**

- Apply same process to that specific package skill only
- See `skills/r-package-skill/SKILL.md` for detailed workflow
