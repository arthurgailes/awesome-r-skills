---
name: r-package-skill
description: Use when creating a skill for an R package, before gathering documentation or writing SKILL.md
---

# R Package Skill Creation

## Overview

**REQUIRED SUB-SKILL:** Use `writing-skills` for TDD methodology and SKILL.md structure.

**This skill ONLY covers R-specific doc gathering.** You MUST invoke `/writing-skills` using the Skill tool for:

- TDD baseline testing
- SKILL.md structure requirements
- Deployment checklist

**Both skills work together - this is NOT optional.**

## When NOT to Use

- Goal skill already exists that references this package (add to existing instead)
- Package is simple/well-known (tidyverse core, base R) - agent likely knows it
- One-off usage - just read the help, don't create a skill

## Quick Reference

| Source     | How                                      | Best For                 |
| ---------- | ---------------------------------------- | ------------------------ |
| Local R    | `btw_tool_docs_*()`                      | Function help, vignettes |
| CRAN       | `cran.r-project.org/web/packages/{pkg}/` | Official reference       |
| pkgdown    | `{author}.github.io/{pkg}/`              | Articles, examples       |
| Web search | GitHub repos, R-bloggers                 | Real-world patterns      |

## Documentation Gathering Order

Try sources in this order (prefer local/authoritative over web):

### 1. Local R Session (Best)

Use the local R installation if easily accessible, but move on immediately if something goes wrong.

If mcptools MCP is configured, use btw tools:

```
btw_tool_docs_help_page(package_name, topic)     # Function help
btw_tool_docs_available_vignettes(package_name)  # List vignettes
btw_tool_docs_vignette(package_name, vignette)   # Read vignette
btw_tool_docs_package_news(package_name)         # Recent changes
```

### 2. CRAN

Package reference manual and vignettes at:

- `https://cran.r-project.org/web/packages/{pkg}/index.html`
- `https://cran.r-project.org/web/packages/{pkg}/{pkg}.pdf` (reference manual)

### 3. Package Website

Many packages have pkgdown sites:

- `https://{author}.github.io/{pkg}/`
- `https://{pkg}.r-lib.org/`
- Check CRAN page for URL field

### 4. Online Best Practices

Search for credible examples and patterns:

- GitHub repos using the package (filter by stars)
- R-bloggers, rOpenSci blog posts
- Stack Overflow highly-voted answers
- Package author's talks/tutorials
- R Journal articles

**Credibility signals:** author's own examples, rOpenSci review, Posit/tidyverse team usage, R Journal publication, high GitHub stars.

### 5. Extract Full Function Reference

**REQUIRED:** Always save the complete function reference to `skills/r-{package}/references/API.md`

```r
# Using btw tools
help_topics <- btw_tool_docs_package_help_topics(package_name)
# Extract each function's help page
# Combine into references/API.md

# OR download CRAN manual PDF, convert to markdown
# https://cran.r-project.org/web/packages/{pkg}/{pkg}.pdf
```

**This is NOT optional.** Every package skill must have `references/API.md` with complete function documentation.

### 6. Store Working Docs

Save working materials for reference during skill writing:

```
refs/docs/{package}/
  vignettes/        # Extracted vignettes (working copies)
  examples/         # Credible code examples
  notes.md          # Your synthesis
```

This directory is gitignored - it's working material, not part of the skill.

**Flow:**

1. Gather docs → `refs/docs/{package}/` (gitignored working area)
2. Extract manual → `skills/r-{package}/references/API.md` (REQUIRED)
3. Polish vignettes → `skills/r-{package}/references/vignette-name.md` (as needed)
4. Write SKILL.md → `skills/r-{package}/SKILL.md` (<500 words)

## Skill Structure for Packages

```
skills/r-{package}/
  SKILL.md              # Overview, when-to-use, quick reference, gotchas (<500 words)
  references/           # REQUIRED
    API.md           # REQUIRED: Full function reference from CRAN/help pages
    vignette-name.md    # Full vignette converted to markdown
    advanced.md         # Advanced patterns, edge cases (as needed)
```

**REQUIRED in references/:**

- **API.md** - Complete function reference (ALWAYS include this)

**Optional in references/:**

- Full vignette content
- Advanced techniques
- Performance optimization details
- Edge cases and subtleties

**SKILL.md should answer:**

- When should I use this package vs alternatives?
- What are the 5-10 most common operations?
- What breaks or surprises people?

**DO NOT put in SKILL.md:**

- Complete function signatures (→ `references/API.md`)
- Full vignette content (→ `references/vignette-name.md`)
- Advanced edge cases (→ `references/advanced.md`)

## Common Mistakes

| Mistake                                     | Fix                                                                                |
| ------------------------------------------- | ---------------------------------------------------------------------------------- |
| Not invoking `/writing-skills`              | Use Skill tool to load writing-skills - required for TDD and structure             |
| Not creating `references/API.md`            | REQUIRED: Full function reference must be in `references/API.md`                   |
| SKILL.md >500 words                         | Move function docs, vignettes, advanced content to `references/`                   |
| Not using references/ for vignettes         | Vignettes ALWAYS go in `skills/r-{pkg}/references/`, not inline                    |
| Storing final docs in refs/docs/            | `refs/docs/` is for gathering only; polished content goes in skill's `references/` |
| Skipping btw tools when available           | Local docs are authoritative and fast                                              |
| Creating skill without checking goal skills | Package skill should support existing goals                                        |
| Putting function signatures in SKILL.md     | All function docs go in `references/API.md`, not SKILL.md                          |
| Not testing skill with subagent             | TDD applies to skills too                                                          |

## Workflow

**STEP 1: INVOKE `/writing-skills`**

Use the Skill tool now. Don't skip ahead. You need the TDD methodology loaded before gathering docs.

**STEP 2: R-Specific Doc Gathering (this skill)**

1. Check existing skills - are there goal skills that would reference this package?
2. Gather docs using order above, store in `refs/docs/{package}/`
3. **REQUIRED:** Extract full function reference to `skills/r-{package}/references/API.md`
4. Extract vignettes to `skills/r-{package}/references/` as needed
5. Identify opinions - what's the recommended approach?

**STEP 3: Back to `/writing-skills`**

Follow the TDD cycle from writing-skills:

- RED: Baseline test without skill
- GREEN: Write minimal skill addressing failures
- REFACTOR: Close loopholes

## Red Flags - STOP

- Writing SKILL.md without running baseline tests
- Skipping TDD because "docs are straightforward"
- "I'll test after writing the skill"
- Not using the Skill tool to invoke writing-skills
- **Not creating `references/API.md` with full function reference**

**All of these mean: Stop. Invoke `/writing-skills` first and follow the required structure.**
