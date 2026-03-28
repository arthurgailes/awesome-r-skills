# Test Suite for R Skills

This directory contains test cases for skills in the r-package-skills plugin.

## Structure

```
tests/
  r-package-skill/
    evals.json          # 9 test cases for R package skill creation
  r-freestiler/
    evals.json          # 2 test cases for reference-reading and parameter intelligence
  skill-triggering/     # Simple trigger tests (bash scripts)
  README.md             # This file
```

## Test Cases Summary

### r-package-skill (9 tests)

1. **ggplot2-plot-validation**: Tests if skill creation handles plot validation patterns
   - Creates skills/r-ggplot2/SKILL.md and references/API.md
   - Verifies plot-validator.R is referenced
   - Checks description includes package name

2. **sf-geometry-validation**: Tests if skill creation handles spatial/geometry validation
   - Creates skills/r-sf/SKILL.md and references/API.md
   - Verifies spatial-validator.R is referenced
   - Checks for CRS and geometry guidance

3. **data-table-syntax-gotchas**: Tests if skill captures data.table syntax gotchas
   - Creates skills/r-data.table/SKILL.md and references/API.md
   - Verifies data.table syntax patterns (:=, .SD, .N, DT[i,j,by])
   - Checks Common Mistakes section exists

4. **installation-path-prompt**: Tests that agent presents numbered installation path choices
   - Must present 3 options (plugin, personal, custom)
   - Must wait for user response before creating files

5. **installation-path-explicit**: Tests that agent skips prompt when path is specified
   - Recognizes "personal skills directory" as ~/.claude/skills/
   - Proceeds directly without presenting choices

6. **skill-structure-validation**: Tests skill structure validation
   - Validates YAML frontmatter (name, description)
   - Checks required sections exist
   - Verifies word count < 500
   - Confirms references/ organization

7. **improvement-loop-scenario**: Tests iteration workflow
   - Creates evals.json with test cases
   - Spawns with-skill and baseline subagents
   - Grades outputs and identifies failures
   - Suggests targeted improvements

8. **description-triggering-check**: Tests description triggering accuracy
   - Evaluates whether r-collapse description triggers correctly
   - Tests with should-trigger, should-not-trigger, and ambiguous queries
   - Suggests description improvements if needed

9. **reads-all-references-before-creating**: Tests that agent reads r-package-skill references before acting
   - Must read doc-gathering.md before fetching package docs
   - Must read anthropic-best-practices.md before writing SKILL.md
   - Must read description-optimization.md before writing description
   - Must not skip straight to creating output files

### r-freestiler (2 tests)

1. **county-zoom-intelligence**: Tests parameter intelligence from references
   - Agent creates tileset for 3,222 county features
   - Verifies max_zoom = 8-11 (appropriate for counties, NOT default 0-14)
   - Checks code includes max_zoom parameter
   - Confirms agent read zoom-strategy.md reference

2. **mandatory-context-compliance**: Tests that <MANDATORY-CONTEXT> block works
   - Agent creates tileset for building footprints (small features)
   - Verifies max_zoom = 12-16 (appropriate for buildings)
   - Confirms agent demonstrates reading references before writing code
   - Tests that references/ docs are not skipped

**Why these tests exist**: Prevents regression of the "intelligence gap" where skills provide correct API but fail to surface parameter guidance. Before the `<MANDATORY-CONTEXT>` fix, agents would skip references and generate bloated tilesets (195k+ tiles at zoom 11 for counties).

## Running Tests

Tests use TDD methodology (see `skills/r-package-skill/SKILL.md`):

1. **Spawn subagents**: Create workspace/iteration-N/eval-{name}/ directories
2. **Run with-skill and baseline**: Save outputs to separate directories
3. **Grade outputs**: Check assertions, save grading.json
4. **Aggregate results**: Create benchmark.json with pass rates
5. **Iterate**: If pass_rate < 90%, improve skill and re-test

## Expected Outcomes

After running this test suite:

- Know which skills work and which don't
- Have evidence-based list of what needs fixing
- Can prioritize improvements based on actual failures (not hypothetical issues)
