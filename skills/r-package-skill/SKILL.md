---
name: r-package-skill
description: Use when creating a skill for an R package, before gathering documentation or writing SKILL.md
---

# R Package Skill Creation

## Overview

**Gather comprehensive package documentation before writing the skill.** This skill handles R-specific doc gathering; use `writing-skills` for TDD methodology and SKILL.md structure.

## When NOT to Use

- Goal skill already exists that references this package (add to existing instead)
- Package is simple/well-known (tidyverse core, base R) - agent likely knows it
- One-off usage - just read the help, don't create a skill

## Quick Reference

| Source | How | Best For |
|--------|-----|----------|
| Local R | `btw_tool_docs_*()` | Function help, vignettes |
| CRAN | `cran.r-project.org/web/packages/{pkg}/` | Official reference |
| pkgdown | `{author}.github.io/{pkg}/` | Articles, examples |
| Web search | GitHub repos, R-bloggers | Real-world patterns |

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

### 5. Store Gathered Docs

Save comprehensive docs for reference during skill writing:

```
refs/docs/{package}/
  vignettes/        # Extracted vignettes
  examples/         # Credible code examples
  notes.md          # Your synthesis
```

This directory is gitignored - it's working material, not part of the skill.

## What to Extract

Focus on judgment-relevant content:

| Extract                         | Skip                      |
| ------------------------------- | ------------------------- |
| When to use vs alternatives     | Basic function signatures |
| Common gotchas and pitfalls     | Obvious parameter docs    |
| Non-obvious patterns            | Exhaustive API reference  |
| Performance considerations      | Rarely-used features      |
| Integration with other packages |                           |

## Skill Structure for Packages

```
skills/r-{package}/
  SKILL.md              # Overview, when-to-use, quick reference, gotchas
  references/           # Optional: heavy docs split by topic
    formatting.md
    advanced.md
```

**SKILL.md should answer:**

- When should I use this package vs alternatives?
- What are the 5-10 most common operations?
- What breaks or surprises people?

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Skipping btw tools when available | Local docs are authoritative and fast |
| Creating skill without checking goal skills | Package skill should support existing goals |
| Exhaustive API documentation | Focus on judgment and gotchas, not signatures |
| Not testing skill with subagent | TDD applies to skills too |
| Storing gathered docs in skill directory | Use `refs/docs/` (gitignored) |

## Workflow

1. **Check existing skills** - are there goal skills (r-fast-data, r-spatial, etc.) that would reference this package? The package skill should support them.
2. **Gather docs** using order above, store in `refs/docs/{package}/`
3. **Identify opinions** - what's the recommended approach?
4. **Apply writing-skills TDD** - baseline test, write skill, verify
5. **Cross-reference** - link from/to goal skills that use this package

**REQUIRED:** Use `writing-skills` for TDD methodology, SKILL.md structure, and deployment checklist. Both skills are available - invoke writing-skills directly.
