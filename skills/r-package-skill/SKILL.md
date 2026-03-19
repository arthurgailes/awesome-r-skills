---
name: r-package-skill
description: Use when gathering R package documentation (CRAN, pkgdown, vignettes) for skill creation. Invoke AFTER writing-r-skills is loaded.
---

# R Package Skill Creation

<MANDATORY-PREREQUISITE>
This skill requires writing-r-skills context. If you have not yet invoked writing-r-skills:

**STOP. Invoke writing-r-skills NOW.**

Do NOT skip this. Do NOT rationalize that you "understand TDD". Invoke the writing-r-skills Skill tool, then return here.

If you already invoked writing-r-skills, proceed below.
</MANDATORY-PREREQUISITE>

## Red Flags

Common rationalizations for skipping writing-r-skills (all incorrect):
- "I understand TDD" → TDD knowledge ≠ this process. Invoke the skill.
- "This is just doc gathering" → ALL skill creation uses TDD. Invoke the skill.
- "I already read it before" → Skills evolve. Invoke to load current version.

**If you skipped writing-r-skills: STOP and invoke it now.**

---

## Overview

This skill covers R-specific documentation gathering. The actual skill creation methodology (TDD, structure, testing, grading, optimization, packaging) comes from writing-r-skills.

## When NOT to Use

- Package is simple/well-known (tidyverse core, base R)
- One-off usage - just read the help
- Goal skill already exists that references this package

## R Documentation Sources

**Primary sources (gather first):**
- **CRAN reference manual**: `cran.r-project.org/web/packages/{pkg}/` → references/API.md (REQUIRED)
- **Vignettes**: CRAN vignettes → references/{vignette-name}.md
- **btw tools** (if R running): `btw_tool_docs_*()` for function help

**Fallback sources (only if baseline test fails after GREEN phase):**
- **pkgdown site**: `{author}.github.io/{pkg}/` for articles/examples
- **Web search**: GitHub issues, R-bloggers for real-world patterns

**Strategy:** Start with CRAN + vignettes + btw. If baseline still fails, add fallback sources in REFACTOR phase.

## Required Structure for R Package Skills

```
skills/r-{package}/
  SKILL.md              # <500 words (writing-r-skills defines format)
  references/
    API.md              # REQUIRED: Complete CRAN reference manual
    vignette-name.md    # Include all CRAN vignettes
    advanced.md         # Optional: Add in REFACTOR if tests need it
```

**Always include:** `references/API.md` + all vignettes from CRAN.

**Description must include package name** so skill triggers when user mentions package or writes `library(package)`.

## R-Specific Test Cases

When testing R package skills (using methodology from writing-r-skills):

**Test for:**
- Correct function names (e.g., `fmean()` not `mean()` for collapse)
- Correct package selection (recognizes when to use package)
- Parameter understanding (knows defaults, common gotchas)
- Pattern recognition (uses package idioms correctly)

**Use R validators** (located in `lib/r-validators/` at repository root):
- `plot-validator.R` - Check ggplot2/mapgl visualizations
- `spatial-validator.R` - Validate sf/spatial operations
- `html-validator.R` - Check flextable/Shiny outputs
- `numerical-validator.R` - Verify collapse/regression results

See writing-r-skills for how validators integrate with grading agents.

## Workflow

Follow writing-r-skills TDD methodology:

**RED Phase:** Run baseline scenario without skill
**Doc Gathering:** Fetch CRAN + vignettes + btw tools (primary sources)
**GREEN Phase:** Write minimal SKILL.md with gathered docs
**REFACTOR Phase:** If tests fail, add fallback sources (pkgdown, web search) and iterate

See writing-r-skills for complete TDD workflow details.
