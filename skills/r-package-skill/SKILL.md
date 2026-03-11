---
name: r-package-skill
description: Use when creating a skill for an R package, before gathering documentation or writing SKILL.md
---

# R Package Skill Creation

## Overview

**REQUIRED SUB-SKILL:** Use `writing-skills` for TDD methodology and SKILL.md structure.

**This skill ONLY covers R-specific doc gathering.** You MUST invoke `/writing-skills` using the Skill tool for TDD and structure.

## When NOT to Use

- Package is simple/well-known (tidyverse core, base R)
- One-off usage - just read the help
- Goal skill already exists that references this package

## Where to Install

**DEFAULT: Personal skills directory** (auto-detected, no questions)

Agent-specific paths:
- Claude Code: `~/.claude/skills/`
- Codex: `~/.agents/skills/`
- OpenCode: `~/.config/opencode/skills/`

**Only ask about path if:**
- User says "contributing to a repository"
- Working directory is a skills plugin repo
- Agent detection fails

**Max 1 question:** Personal vs Contributing vs Custom

**See `references/installation-paths.md` for detection logic and edge cases**

## Quick Reference

| Source  | How                                      | Best For                 |
| ------- | ---------------------------------------- | ------------------------ |
| Local R | `btw_tool_docs_*()`                      | Function help, vignettes |
| CRAN    | `cran.r-project.org/web/packages/{pkg}/` | Official reference       |
| pkgdown | `{author}.github.io/{pkg}/`              | Articles, examples       |
| Web     | GitHub, R-bloggers                       | Real-world patterns      |

## Required Structure

```
{base_path}/
  SKILL.md              # <500 words: overview, when-to-use, gotchas
  references/
    API.md           # REQUIRED: Complete CRAN reference manual
    vignette-name.md    # Optional: Full vignettes
    advanced.md         # Optional: Advanced patterns
```

**Note:** `{base_path}` is full path to skill (e.g., `~/.claude/skills/r-mapgl/`)

**REQUIRED:** `references/API.md` - replicate CRAN reference manual with all function signatures and descriptions.

**SKILL.md should answer:**

- When to use this package vs alternatives?
- What are the 5-10 most common operations?
- What breaks or surprises people?

**DO NOT put in SKILL.md:**

- Function signatures → `references/API.md`
- Full vignettes → `references/vignette-name.md`
- Advanced edge cases → `references/advanced.md`

## Workflow

**STEP 0: Determine Installation Path**

Auto-detect personal skills directory. Only ask if:
- Contributing mentioned
- Detection fails
- Non-standard request

Silently confirm: "Creating skill at: {detected_path}"

**STEP 1: INVOKE `/writing-skills`**

Load TDD methodology before gathering docs.

**STEP 2: Gather Docs**

1. Check existing skills - support goal skills if they exist
2. Gather docs (see `references/doc-gathering.md` for sources)
3. **REQUIRED:** Extract full function reference to `{base_path}/references/API.md`
4. Extract vignettes to `{base_path}/references/` as needed
5. Identify opinions - what's the recommended approach?

**STEP 3: Back to `/writing-skills`**

- RED: Baseline test without skill
- GREEN: Write minimal skill to `{base_path}/SKILL.md`
- REFACTOR: Close loopholes

## Common Mistakes

| Mistake                          | Fix                                       |
| -------------------------------- | ----------------------------------------- |
| Asking too many path questions   | Auto-detect personal path (default)       |
| Not detecting agent              | Check env vars, common paths exist        |
| Not invoking `/writing-skills`   | Use Skill tool - required for TDD         |
| Not creating `references/API.md` | REQUIRED for every package skill          |
| SKILL.md >500 words              | Move content to `references/`             |
| Function signatures in SKILL.md  | All go in `references/API.md`             |

## Red Flags - STOP

- Asking user for install path when auto-detection works
- Writing SKILL.md without baseline tests
- Skipping TDD because "docs are straightforward"
- Not invoking `/writing-skills` with Skill tool
- **Not creating `references/API.md`**

**Stop. Auto-detect path, invoke `/writing-skills` first, and follow required structure.**

## Documentation Gathering

See `references/doc-gathering.md` for:

- Detailed source priority order
- btw tools usage
- CRAN/pkgdown/web search patterns
- Extraction workflows
