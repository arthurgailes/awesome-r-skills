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

## Installation Path Selection

**Before gathering docs, ask the user where to install the skill:**

```
Where should I install the skill?
  1. Plugin directory (./skills/r-{package}/) — for contributing to this plugin repo
  2. Personal directory (~/.claude/skills/r-{package}/) — for your own use
  3. Custom path — specify your own location
```

**You MUST present these choices and wait for the user's answer before proceeding.** Do NOT default to any option silently. If the user's original message already specifies a path, use that instead of asking.

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
{install-path}/r-{package}/
  SKILL.md              # <500 words (writing-r-skills defines format)
  references/
    API.md              # REQUIRED: Complete CRAN reference manual
    vignette-name.md    # Include all CRAN vignettes
    advanced.md         # Optional: Add in REFACTOR if tests need it
```

Where `{install-path}` is the directory chosen by the user (see Installation Path Selection above).

**Always include:** `references/API.md` + all vignettes from CRAN.

**Description MUST follow this pattern** for reliable triggering:

```yaml
description: Use when code loads or uses {package} (library({package}), {package}::), [file-type triggers if applicable], [domain-specific triggers]
```

**Required elements:**
1. Package name with `library()` and `::` call patterns (explicit tokens Claude matches on)
2. Relevant file extensions if the package works with specific file types (.pmtiles, .parquet, .docx)
3. Domain-specific problem descriptions (what the user is trying to do)

## SKILL.md Template Requirements

**Every generated SKILL.md must include a mandatory context block immediately after Overview:**

```markdown
## Overview

[Package description]

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/API.md` - Complete function reference
□ `references/getting-started.md` - Usage patterns and examples
□ `references/[other-key-doc].md` - [specific guidance]

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>
```

**Checkpoint list must:**
- List ALL files in `references/` (except truly optional advanced docs)
- Use checkbox format (`□`) for clear verification
- Include brief description of what each reference contains

**Quick Reference table must be COMPLETE:**
- Show ALL important parameters, even if optional/advanced
- Mark tiers: required (no mark), `(opt)` optional, `(adv)` advanced
- DO NOT hide parameters that affect performance/output size
- Example: For tiling functions, MUST show zoom parameters even if they have defaults

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

## R Execution Patterns

**Prefer ad hoc code over script files:**
- Default: `Rscript -e "code"` or mcptools MCP
- Only create scripts if user requests OR code is long-running (hours+)

**If scripts are unavoidable:**
- Label as temp: `temp_*.R` or use `tempfile()`
- Clean up: `on.exit(unlink("temp_script.R"))` or `file.remove()`
- Never leave `download_data.R`, `analysis.R`, etc. cluttering the project

## Workflow

Follow writing-r-skills TDD methodology:

**RED Phase:** Run baseline scenario without skill
**Doc Gathering:** Fetch CRAN + vignettes + btw tools (primary sources)
**GREEN Phase:** Write minimal SKILL.md with gathered docs
**REFACTOR Phase:** If tests fail, add fallback sources (pkgdown, web search) and iterate

See writing-r-skills for complete TDD workflow details.
