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

## Quick Reference

| Source  | How                                      | Best For                 |
| ------- | ---------------------------------------- | ------------------------ |
| Local R | `btw_tool_docs_*()`                      | Function help, vignettes |
| CRAN    | `cran.r-project.org/web/packages/{pkg}/` | Official reference       |
| pkgdown | `{author}.github.io/{pkg}/`              | Articles, examples       |
| Web     | GitHub, R-bloggers                       | Real-world patterns      |

## Required Structure

```
skills/r-{package}/
  SKILL.md              # <500 words: overview, when-to-use, gotchas
  references/
    API.md           # REQUIRED: Full function reference
    vignette-name.md    # Optional: Full vignettes
    advanced.md         # Optional: Advanced patterns
```

**REQUIRED:** `references/API.md` with complete function documentation.

**SKILL.md should answer:**

- When to use this package vs alternatives?
- What are the 5-10 most common operations?
- What breaks or surprises people?

**DO NOT put in SKILL.md:**

- Function signatures → `references/API.md`
- Full vignettes → `references/vignette-name.md`
- Advanced edge cases → `references/advanced.md`

## Workflow

**STEP 1: INVOKE `/writing-skills`**

Load TDD methodology before gathering docs.

**STEP 2: Gather Docs**

1. Check existing skills - support goal skills if they exist
2. Gather docs (see `references/doc-gathering.md` for sources)
3. **REQUIRED:** Extract full function reference to `references/API.md`
4. Extract vignettes to `references/` as needed
5. Identify opinions - what's the recommended approach?

**STEP 3: Back to `/writing-skills`**

- RED: Baseline test without skill
- GREEN: Write minimal skill
- REFACTOR: Close loopholes

## Common Mistakes

| Mistake                          | Fix                               |
| -------------------------------- | --------------------------------- |
| Not invoking `/writing-skills`   | Use Skill tool - required for TDD |
| Not creating `references/API.md` | REQUIRED for every package skill  |
| SKILL.md >500 words              | Move content to `references/`     |
| Function signatures in SKILL.md  | All go in `references/API.md`     |
| Storing final docs in refs/docs/ | `refs/docs/` is working area only |

## Red Flags - STOP

- Writing SKILL.md without baseline tests
- Skipping TDD because "docs are straightforward"
- Not invoking `/writing-skills` with Skill tool
- **Not creating `references/API.md`**

**Stop. Invoke `/writing-skills` first and follow required structure.**

## Documentation Gathering

See `references/doc-gathering.md` for:

- Detailed source priority order
- btw tools usage
- CRAN/pkgdown/web search patterns
- Extraction workflows
