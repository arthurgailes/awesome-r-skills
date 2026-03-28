---
name: r-package-skill
description: Use when creating, editing, or validating R package skills, gathering R package documentation (CRAN, pkgdown, vignettes) for skill creation
---

# R Package Skill Creation

## Overview

Single entry point for creating R package skills using TDD methodology. Pulls documentation from CRAN/pkgdown, writes a tested skill, and iterates until it passes.

See `references/anthropic-best-practices.md` for Anthropic's official guidance on writing concise, well-structured skills (token efficiency, progressive disclosure, reference organization).

## When NOT to Use

- Package is simple/well-known (tidyverse core, base R)
- One-off usage -- just read the help
- Goal skill already exists that references this package

## Installation Path Selection

**Before gathering docs, ask the user where to install the skill:**

```
Where should I install the skill?
  1. Plugin directory (./skills/r-{package}/) -- for contributing to this plugin repo
  2. Personal directory (~/.claude/skills/r-{package}/) -- for your own use
  3. Custom path -- specify your own location
```

**You MUST present these choices and wait for the user's answer before proceeding.** Do NOT default to any option silently. If the user's original message already specifies a path, use that instead of asking.

See `references/installation-paths.md` for agent-specific paths (Claude Code, Codex, OpenCode).

## R Documentation Sources

**Primary sources (gather first):**
- **CRAN reference manual**: `cran.r-project.org/web/packages/{pkg}/` -> references/API.md (REQUIRED)
- **Vignettes**: CRAN vignettes -> references/{vignette-name}.md
- **btw tools** (if R running): `btw_tool_docs_*()` for function help

**Fallback sources (only if baseline test fails):**
- **pkgdown site**: `{author}.github.io/{pkg}/` for articles/examples
- **Web search**: GitHub issues, R-bloggers for real-world patterns

See `references/doc-gathering.md` for detailed source priority and extraction workflow.

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

**Description MUST include explicit code-recognition tokens:**

```yaml
description: Use when code loads or uses {package} (library({package}), {package}::), [file-type triggers if applicable], [domain-specific triggers]
```

Required elements:
1. Package name with `library()` and `::` call patterns
2. Relevant file extensions (.pmtiles, .parquet, .docx)
3. Domain-specific problem descriptions

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

See `references/description-optimization.md` for triggering accuracy testing.

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

Follow RED-GREEN-REFACTOR (see `superpowers:writing-skills` for general TDD methodology).

**RED Phase:** Run baseline scenario without skill. Document what the agent gets wrong.

**Doc Gathering:** Fetch CRAN + vignettes + btw tools (primary sources).

**GREEN Phase:** Write minimal SKILL.md + references/ addressing baseline failures.

**REFACTOR Phase:**
- If tests fail, add fallback sources (pkgdown, web search) and iterate
- Verify agents read ALL `references/` before writing code
- Verify Quick Reference didn't hide critical parameters
- Iterate until pass_rate >= 90% AND no improvement for 2 iterations

## R-Specific Checklist

In addition to the general skill creation checklist from `superpowers:writing-skills`:

- [ ] `references/API.md` contains complete CRAN reference manual
- [ ] All CRAN vignettes included as `references/*.md`
- [ ] `<MANDATORY-CONTEXT>` block lists ALL reference files with checkboxes
- [ ] Quick Reference shows ALL important parameters (including performance-critical ones)
- [ ] Description includes `library()` and `::` code-recognition tokens
- [ ] R validators referenced where applicable (plot, spatial, html, numerical)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Missing `references/API.md` | REQUIRED for every package skill. Extract from CRAN manual. |
| Quick Reference hides parameters | Show ALL params that affect performance/output. Mark optional with `(opt)`. |
| Agents skip references | Add `<MANDATORY-CONTEXT>` block with checkbox list. |
| Description too generic | Include `library({pkg})` and `{pkg}::` tokens for code recognition. |
| Skipping baseline test | Run without skill first. You don't know what to teach without seeing failures. |
