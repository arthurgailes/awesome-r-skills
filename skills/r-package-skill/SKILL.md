---
name: r-package-skill
description: Use when creating, editing, or validating R package skills, gathering R package documentation (CRAN, pkgdown, vignettes) for skill creation
---

# R Package Skill Creation

## Overview

Single entry point for creating R package skills using TDD methodology. Pulls documentation from CRAN/pkgdown, writes a tested skill, and iterates until it passes.

<MANDATORY-CONTEXT>
Before creating any skill, you MUST read these references:

- [ ] `references/doc-gathering.md` - Documentation source priorities and extraction workflow
- [ ] `references/anthropic-best-practices.md` - Skill writing quality (token efficiency, progressive disclosure)
- [ ] `references/description-optimization.md` - Description triggering accuracy and code-recognition tokens
- [ ] `references/installation-paths.md` - Agent-specific installation directories

DO NOT fetch package docs or write any files until you have read ALL references above.

Testing-phase references (read when running tests, not before doc gathering):
- `references/testing.md` - evals.json format and assertion types
- `references/grading.md` - Grading workflow and domain validators
- `references/improvement-loop.md` - Iteration and stopping criteria
</MANDATORY-CONTEXT>

## When NOT to Use

- Package is simple/well-known (tidyverse core, base R)
- One-off usage -- just read the help
- Goal skill already exists that references this package

## Installation Path Selection

Ask the user where to install before proceeding. Do NOT default silently. If the user's message already specifies a path, use that instead of asking. See `references/installation-paths.md` for the exact prompt and agent-specific paths.

## Required Structure

```
{install-path}/r-{package}/
  SKILL.md              # <500 words
  references/
    API.md              # REQUIRED: Complete CRAN reference manual
    vignette-name.md    # Include all CRAN vignettes
    advanced.md         # Optional: Add in REFACTOR if tests need it
```

**Always include:** `references/API.md` + all vignettes from CRAN.

## SKILL.md Template Requirements

**Description MUST include code-recognition tokens** (`library({package})`, `{package}::`), file extensions, and domain triggers. See `references/description-optimization.md` for template and examples.

**Every generated SKILL.md must include a mandatory context block after Overview:**

```markdown
## Overview

[Package description]

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

- `references/API.md` - Complete function reference
- `references/getting-started.md` - Usage patterns and examples

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>
```

**Quick Reference table must be COMPLETE:**
- Show ALL important parameters, even if optional/advanced
- Mark tiers: required (no mark), `(opt)` optional, `(adv)` advanced
- DO NOT hide parameters that affect performance/output size (e.g., zoom levels, batch sizes)

## R-Specific Testing

**Use R validators** (in `lib/r-validators/` at repository root):
- `plot-validator.R` -- ggplot2/mapgl visualizations
- `spatial-validator.R` -- sf/spatial operations
- `html-validator.R` -- flextable/Shiny outputs
- `numerical-validator.R` -- collapse/regression results

**Test for:**
- Correct function names (e.g., `fmean()` not `mean()` for collapse)
- Correct package selection (recognizes when to use package)
- Parameter understanding (knows defaults, common gotchas)
- Pattern recognition (uses package idioms correctly)
- Agent reads ALL `references/` before writing code (not just SKILL.md)

**Test infrastructure:** See `references/testing.md` for evals.json format, `references/grading.md` for grading workflow, `references/improvement-loop.md` for iteration.

## R Execution Patterns

**Prefer ad hoc code over script files:**
- Default: `Rscript -e "code"` or mcptools MCP
- Only create scripts if user requests OR code is long-running

**If scripts are unavoidable:**
- Label as temp: `temp_*.R` or use `tempfile()`
- Clean up: `on.exit(unlink("temp_script.R"))` or `file.remove()`

## Workflow

Follow RED-GREEN-REFACTOR:

**RED Phase:** Run baseline scenario without skill. Document what the agent gets wrong.

**Doc Gathering:** Fetch CRAN + vignettes + btw tools (primary sources).

**GREEN Phase:** Write minimal SKILL.md + references/ addressing baseline failures.

**REFACTOR Phase:**
- If tests fail, add fallback sources (pkgdown, web search) and iterate
- Verify Quick Reference didn't hide critical parameters
- Iterate until pass_rate >= 90% AND no improvement for 2 iterations

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Missing `references/API.md` | REQUIRED for every package skill. Extract from CRAN manual. |
| Missing vignettes | Include ALL CRAN vignettes as `references/*.md`. |
| Quick Reference hides parameters | Show ALL params that affect performance/output. Mark optional with `(opt)`. |
| No `<MANDATORY-CONTEXT>` block | Generated skill must list ALL reference files with checkboxes. |
| Agents skip references | Verify agents read references before writing code during testing. |
| Description too generic | Include `library({pkg})` and `{pkg}::` tokens for code recognition. |
| Skipping baseline test | Run without skill first. You don't know what to teach without seeing failures. |
| Missing R validators | Reference plot/spatial/html/numerical validators where applicable. |
