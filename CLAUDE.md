# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

R skills plugin for AI coding agents (Claude Code, Codex, OpenCode). Core value: `/r-package-skill` auto-generates skills from any R package's documentation, so agents can use packages they weren't trained on.

## Skill Types

1. **Skill generator** (`r-package-skill`): Creates new skills from R package docs
2. **Package skills** (`r-collapse`, `r-mapgl`, etc.): Reference docs for specific R packages

## Creating Skills

**Use TDD methodology** from `skills/r-package-skill/SKILL.md`:

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

For general skill-writing methodology, see `superpowers:writing-skills`.

## Adding Package Skills to Plugin

**When user says "add [or write] a package skill" or "add skills/r-{package}":**

- Read all contents of `skills/r-package-skill`
- Add to `./skills/r-{package}/` in THIS repository (the plugin itself)
- Update `README.md` with new skill entry
- This is DISTINCT from users adding skills to their own `~/.claude/skills/` locally

**Plugin development vs user usage:**

- **Plugin development** (this context): Creating skills in `./skills/` for distribution
- **User usage**: End users installing from marketplace to their local environment

## Testing

### Skill-triggering tests (bash scripts)

```bash
# Run all triggering tests
cd tests/skill-triggering && ./run-all-tests.sh

# Run single triggering test
./tests/skill-triggering/run-test.sh r-mapgl ./tests/skill-triggering/prompts/usage/mapgl-library-call.txt
```

These verify skills trigger from natural language (no explicit `/skill-name`). Prompts live in `tests/skill-triggering/prompts/{creation,usage}/`. Output goes to `tests/skill-triggering/output/{timestamp}/`.

### Eval-based tests (evals.json)

Each skill's test cases are in `tests/{skill-name}/evals.json`. Assertion types: `file_exists`, `code_pattern`, `qualitative`, `execution`, `domain_validator`.

Tests run via TDD methodology: spawn with-skill and baseline subagents, grade outputs with `agents/grader.md`, save `grading.json`, iterate until pass_rate >= 90%.

### R validators

Domain-specific validation scripts in `lib/r-validators/`:

```bash
Rscript lib/r-validators/plot-validator.R path/to/code.R
Rscript lib/r-validators/spatial-validator.R path/to/code.R
Rscript lib/r-validators/html-validator.R path/to/output.html
Rscript lib/r-validators/numerical-validator.R path/to/code.R
```

Each returns JSON with `valid`, `message`, and domain-specific fields.

## R Conventions

- `|>` not `%>%`
- ASCII-safe strings only (no unicode)

## Structure

```
skills/                  # Each skill: SKILL.md + optional references/
  r-{package}/           # Package skills
  r-package-skill/       # Skill generator (creates new skills)
agents/grader.md         # Grader agent instructions for evaluating test outputs
lib/r-validators/        # R scripts for domain-specific validation
tests/                   # Test cases and triggering tests
  {skill-name}/evals.json
  skill-triggering/      # Bash-based natural language trigger tests
.claude-plugin/          # Plugin marketplace metadata
refs/                    # Research materials (gitignored)
```

## Plugin Distribution

Plugin available for multiple agents:

- **Claude Code**: `/plugin marketplace add arthurgailes/r-package-skills` then `/plugin install r-package-skills@r-package-skills`
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
