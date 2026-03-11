---
name: r-package-skill
description: Use when creating a skill for an R package, before gathering documentation or writing SKILL.md
---

# R Package Skill Creation

## Overview

**Creates skills for R packages using TDD methodology.** This skill embeds the RED-GREEN-REFACTOR workflow - test without skill, gather docs, write skill, iterate.

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
    API.md              # REQUIRED: Complete CRAN reference manual
    example.R           # REQUIRED: Working examples (<400 lines, <30s runtime)
    bad-code.md         # REQUIRED: Anti-patterns discovered during development
    vignette-name.md    # Optional: Full vignettes
    advanced.md         # Optional: Advanced patterns
```

**Note:** `{base_path}` is full path to skill (e.g., `~/.claude/skills/r-mapgl/`)

**REQUIRED files:**

- `references/API.md` - Complete CRAN reference manual with all function signatures
- `references/example.R` - Working code demonstrating key functionality
- `references/bad-code.md` - Common mistakes and anti-patterns

**SKILL.md should answer:**

- When to use this package vs alternatives?
- What are the 5-10 most common operations?
- What breaks or surprises people?

**DO NOT put in SKILL.md:**

- Function signatures → `references/API.md`
- Full vignettes → `references/vignette-name.md`
- Advanced edge cases → `references/advanced.md`

## Workflow (TDD: RED → GREEN → REFACTOR)

**STEP 0: Determine Installation Path**

Auto-detect personal skills directory. Only ask if:

- Contributing mentioned
- Detection fails
- Non-standard request

Silently confirm: "Creating skill at: {detected_path}"

---

## RED PHASE: Baseline Without Skill

**STEP 1: Run Pressure Scenario**

Before gathering ANY docs, test agent WITHOUT the skill:

1. Create realistic task requiring the package (e.g., "Join cities to counties with {package}")
2. Use Task tool with subagent (subagent_type="general-purpose")
3. **Do NOT provide package documentation**
4. Document exact failures:
   - Wrong function names used
   - Wrong parameter names
   - Incorrect return type assumptions
   - Connection/setup mistakes
   - API misunderstandings

**STEP 2: Gather Docs**

Now gather documentation to address baseline failures:

1. Check existing skills - support goal skills if they exist
2. Gather docs (see `references/doc-gathering.md` for sources)
3. **REQUIRED:** Extract full function reference to `{base_path}/references/API.md`
4. Extract vignettes to `{base_path}/references/` as needed
5. Identify opinions - what's the recommended approach?
6. **REQUIRED:** Create and test `{base_path}/references/example.R`:
   - Showcase 5-10 key package functions
   - Keep under 400 lines of code
   - Must run in under 30 seconds
   - Test by running with R (e.g., `Rscript example.R`)
   - If R execution fails, use `AskUserQuestion` to:
     - Get path to R installation, OR
     - Skip example.R testing (still create file)
   - Log ALL mistakes/errors to `{base_path}/references/bad-code.md`
   - Include what went wrong and the correct approach

---

## GREEN PHASE: Write Minimal Skill

**STEP 3: Write SKILL.md**

Address ONLY the specific failures from RED phase:

1. **Description**: "Use when [symptoms from baseline test]"
2. **Overview**: Core principle (1-2 sentences)
3. **When to Use**: Comparison table vs alternatives
4. **Quick Reference**: Table of common operations that failed
5. **Return Types**: If baseline showed confusion
6. **Common Mistakes**: Table of baseline errors + fixes
7. **Keep under 500 words** - move details to references/

---

## REFACTOR PHASE: Test and Iterate

**STEP 4: Verify and Close Loopholes**

1. Run same scenario WITH skill loaded
2. Agent should now succeed
3. If new mistakes appear:
   - Add to Common Mistakes table
   - Update Quick Reference
   - Add to bad-code.md
4. Re-test until agent succeeds consistently

**Detail reference:** See `writing-r-skills` skill for comprehensive TDD methodology and best practices

## Common Mistakes

| Mistake                               | Fix                                    |
| ------------------------------------- | -------------------------------------- |
| Skipping RED baseline test            | MUST run scenario without skill first  |
| Writing SKILL.md before baseline      | Baseline reveals what to document      |
| Asking too many path questions        | Auto-detect personal path (default)    |
| Not creating `references/API.md`      | REQUIRED for every package skill       |
| Not creating `references/example.R`   | REQUIRED - demonstrates key functions  |
| Not logging mistakes to `bad-code.md` | Document all errors during development |
| example.R too long (>400 lines)       | Focus on 5-10 key functions only       |
| example.R runs too slow (>30s)        | Use small datasets, limit iterations   |
| SKILL.md >500 words                   | Move content to `references/`          |
| Function signatures in SKILL.md       | All go in `references/API.md`          |

## Red Flags - STOP

- **Skipping RED phase** - gathering docs before baseline test
- **Writing SKILL.md before baseline** - must see agent fail first
- Asking user for install path when auto-detection works
- Skipping TDD because "docs are straightforward"
- **Not creating `references/API.md`**
- **Not creating `references/example.R`**
- **Not creating `references/bad-code.md`**
- Not testing example.R execution

**Stop. Run baseline test FIRST (RED), then gather docs, then write skill (GREEN).**

## Documentation Gathering

See `references/doc-gathering.md` for:

- Detailed source priority order
- btw tools usage
- CRAN/pkgdown/web search patterns
- Extraction workflows
