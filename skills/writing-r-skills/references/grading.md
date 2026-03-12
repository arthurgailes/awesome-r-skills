# Grading Agents

How to evaluate test outputs against assertions.

## Grading Workflow

1. Read test outputs (code, files, plots, data) from `eval-{name}/with_skill/outputs/` or `without_skill/outputs/`
2. Read assertions from `eval_metadata.json`
3. Check each assertion
4. For qualitative assertions, make judgment calls
5. For domain validators, call specialized scripts
6. Save results to `grading.json`

## Grading Output Format

```json
{
  "eval_id": "collapse-grouped-stats",
  "eval_name": "Grouped statistics with collapse",
  "assertions": [
    {
      "text": "Uses correct function",
      "passed": true,
      "evidence": "Code contains fmean() on line 5"
    },
    {
      "text": "Code is readable",
      "passed": true,
      "evidence": "Clear variable names, good comments, logical flow"
    }
  ],
  "overall_pass": true,
  "pass_count": 2,
  "total_count": 2
}
```

## Assertion Types

See references/testing.md for assertion type definitions.

## Domain Validators

For domain-specific validation (plots, spatial data, HTML, etc.), grader calls specialized validators:

**R packages:**
- plot-validator.R, spatial-validator.R, html-validator.R, numerical-validator.R
- Located in `lib/r-validators/`
- See r-package-skill for R-specific validators

**Other languages:**
- Define validators in language-specific skill
- Follow same pattern: accept file path, return JSON

**Validator integration:**
```bash
# Call validator
Rscript lib/r-validators/plot-validator.R outputs/code.R

# Parse JSON response
{"valid":true,"layers":3,"has_title":true}

# Use as evidence in grading
```

## Qualitative Evaluation

Grader agents CAN make subjective judgments:
- Code readability (variable names, comments, structure)
- Approach quality (efficient, maintainable, follows conventions)
- Design decisions (appropriate patterns, good architecture)

Be fair: high standards but not perfection. Look for clear problems, not minor style preferences.

## For Grader Agents

See `agents/grader.md` for complete instructions on how to grade test outputs.
