---
name: r-package-skill
description: Use when creating, editing, or validating R package skills (library(pkg), pkg::), or gathering R package documentation (CRAN, pkgdown, vignettes) to generate a skill
---

# R Package Skill Creation

## Overview

Generates a new `r-{package}` skill from an R package's documentation. Core loop: capture intent → gather docs → draft skill → run test cases (with-skill + baseline in parallel) → grade → iterate until pass_rate >= 90% and no improvement for 2 iterations → optimize description.

## When NOT to Use

- Package is simple/well-known (tidyverse core, base R)
- One-off usage -- just read the help
- A skill already exists that references this package

## Ask Where to Install

Always ask before creating files. No silent defaults. If the user already specified a path, use it. See `references/installation-paths.md` for the prompt and agent-specific paths.

## R-Specific Skill Structure

```
{install-path}/r-{package}/
  SKILL.md              # <500 words
  references/
    API.md              # REQUIRED: Complete CRAN reference manual
    vignette-name.md    # Include all CRAN vignettes
```

- `references/API.md` is required for every package skill.
- Include every CRAN vignette as `references/{vignette}.md`.
- Each generated SKILL.md must tell its reader: "Read `references/API.md` before writing code."
- Quick Reference table must show ALL important parameters, including optional/advanced. Mark tiers: required (no mark), `(opt)` optional, `(adv)` advanced. Never hide parameters that affect performance or output size (zoom levels, batch sizes, etc.).

## Workflow

1. **Capture intent.** Ask what the user needs the skill to do, edge cases, input/output formats, and what makes it a success. Don't fetch docs until this is clear.
2. **Gather docs.** Fetch CRAN reference, vignettes, and (if available) btw tools. See `references/doc-gathering.md`.
3. **Draft.** Write SKILL.md, `references/API.md`, and vignettes.
4. **Test.** Spawn with-skill and baseline subagents **in the same turn** (parallel, not sequential). Grade outputs. Aggregate into `benchmark.json`. See `references/testing.md`.
5. **Iterate.** If `pass_rate < 90%` or it's still improving, analyze failures, edit the skill, rerun. Remove guidance transcripts show agents ignoring (YAGNI). Stop when `pass_rate >= 90%` AND no improvement for 2 iterations.
6. **Optimize the description last.** See `references/description-optimization.md`.

## Description Recognition Tokens

Descriptions MUST include `library({pkg})` and `{pkg}::` tokens plus file-extension and domain triggers. Without the package-name tokens, descriptions that read as action-oriented ("Use when creating interactive maps") miss user prompts that contain `library(mapgl)` or `mapgl::`.

```yaml
# Good
description: Use when code loads or uses freestiler, working with .pmtiles files, or preparing tiles for mapgl/MapLibre in R

# Bad: no recognition tokens
description: Use when creating PMTiles vector tilesets from large spatial datasets
```

See `references/description-optimization.md` for the train/held-out test method.

## R Validators

Domain assertions call R validators in `lib/r-validators/` at repo root via `Rscript`:

- `plot-validator.R` -- ggplot2/mapgl visualizations
- `spatial-validator.R` -- sf/spatial operations
- `html-validator.R` -- flextable/Shiny outputs
- `numerical-validator.R` -- collapse/regression results

Each returns JSON (`valid`, `message`, domain fields) for use as grading evidence.

## R Execution Patterns

- Default: `Rscript -e "code"` or mcptools MCP.
- Create script files only if code is long-running or the user asks.
- If unavoidable: prefix `temp_*.R` or use `tempfile()`, clean up with `on.exit(unlink(...))` or `file.remove()`.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Missing `references/API.md` | REQUIRED. Extract from CRAN reference manual. |
| Missing vignettes | Include every CRAN vignette as `references/*.md`. |
| Quick Reference hides parameters | Show ALL params that affect performance/output. Mark optional with `(opt)`. |
| Running with-skill first, baseline later | Spawn both in the same turn so timing is comparable. |
| Assertion schema drift | Use `text` / `passed` / `evidence` in `grading.json`, not `name` / `met` / `details`. |
| Description too generic | Include `library({pkg})` and `{pkg}::` tokens. |
| Skipping baseline | Without a baseline, you can't tell whether the skill helped. |
| Optimizing description before skill works | Fix functionality first; tune triggering last. |
