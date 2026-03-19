# Test Suite for R Skills

This directory contains test cases for the three integrated skills in the awesome-r-skills plugin.

## Structure

```
tests/
  r-package-skill/
    evals.json          # 3 test cases for R package skill creation
  writing-r-skills/
    evals.json          # 3 test cases for universal skill methodology
  creating-r-package/
    evals.json          # 3 test cases for R package development
  README.md             # This file
```

## Test Cases Summary

### r-package-skill (3 tests)

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

### writing-r-skills (3 tests)

1. **skill-structure-validation**: Tests skill structure validation
   - Validates YAML frontmatter (name, description)
   - Checks required sections exist
   - Verifies word count < 500
   - Confirms references/ organization

2. **improvement-loop-scenario**: Tests iteration workflow
   - Creates evals.json with test cases
   - Spawns with-skill and baseline subagents
   - Grades outputs and identifies failures
   - Suggests targeted improvements

3. **description-triggering-check**: Tests description triggering accuracy
   - Evaluates whether r-collapse description triggers correctly
   - Tests with should-trigger, should-not-trigger, and ambiguous queries
   - Suggests description improvements if needed

### creating-r-package (3 tests)

1. **initialize-package-structure**: Tests package initialization
   - Creates DESCRIPTION, NAMESPACE, R/, tests/, man/ directories
   - Verifies required fields in DESCRIPTION
   - Checks package structure follows R standards

2. **add-function-with-roxygen**: Tests function creation with documentation
   - Creates R/add_numbers.R with roxygen2 comments
   - Runs devtools::document() to generate man/add_numbers.Rd
   - Verifies @param, @return, @export tags

3. **run-r-cmd-check**: Tests package validation
   - Executes R CMD check or rcmdcheck::rcmdcheck()
   - Reports errors, warnings, notes
   - Verifies package passes (0 errors, 0 warnings)

## Running Tests

Tests will be executed using the methodology from writing-r-skills:

1. **Spawn subagents**: Create workspace/iteration-N/eval-{name}/ directories
2. **Run with-skill and baseline**: Save outputs to separate directories
3. **Grade outputs**: Check assertions, save grading.json
4. **Aggregate results**: Create benchmark.json with pass rates
5. **Iterate**: If pass_rate < 90%, improve skill and re-test

## Expected Outcomes

After running this minimal test suite:

- Know which skills work and which don't
- Have evidence-based list of what needs fixing
- Can prioritize improvements based on actual failures (not hypothetical issues)

## Next Steps

1. Run these tests (Priority #2 from design doc)
2. Analyze failures (which assertions fail, why)
3. Fix broken functionality (Priority #3)
4. Only then consider elaborate infrastructure (commands, hooks, etc.)
