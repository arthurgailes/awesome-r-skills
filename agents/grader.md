# Grader Agent Instructions

You are evaluating test outputs against assertions to determine if a skill works correctly.

## Your Task

1. **Read test context**
   - eval_metadata.json contains eval prompt and assertions
   - Outputs in `eval-{name}/with_skill/outputs/` or `without_skill/outputs/`

2. **Check each assertion**
   - Code patterns: grep/search for strings
   - Execution: check exit codes, error messages
   - File existence: check file system
   - Qualitative: make judgment calls on quality
   - Domain validators: call specialized scripts

3. **Save results**
   - grading.json with pass/fail per assertion
   - Include evidence for each check

## Assertion Types

### Code Pattern

Check if output contains string/pattern.

**Example assertion:**
```json
{"type": "code_pattern", "description": "Uses collapse package", "check": "contains 'library(collapse)'"}
```

**How to grade:**
- Search output for pattern
- Pass if found, fail if not
- Evidence: "Code contains 'library(collapse)' on line 3"

### Execution

Check if code ran successfully.

**Example assertion:**
```json
{"type": "execution", "description": "Code runs without errors", "check": "exit_code == 0"}
```

**How to grade:**
- Look for error messages, exit codes
- Pass if no errors, fail if errors
- Evidence: "Code executed successfully, no error messages"

### File Exists

Check if expected output file was created.

**Example assertion:**
```json
{"type": "file_exists", "description": "Creates plot", "check": "outputs/plot.png exists"}
```

**How to grade:**
- Check if file exists in outputs/
- Pass if exists, fail if not
- Evidence: "File outputs/plot.png exists (23KB)"

### Qualitative

Make judgment call on code quality.

**Example assertion:**
```json
{"type": "qualitative", "description": "Code is readable and follows conventions"}
```

**How to grade:**
- Read the code
- Evaluate: variable names, comments, structure, clarity
- Pass if meets standards, fail if poor quality
- Evidence: "Clear variable names (data_cleaned, results_summary), good comments explaining logic, logical flow"

### Domain Validator

Call specialized validator script.

**Example assertion:**
```json
{"type": "domain_validator", "description": "Plot has correct layers", "validator": "plot-validator.R"}
```

**How to grade:**
- Run: `Rscript lib/r-validators/plot-validator.R outputs/code.R`
- Parse JSON response
- Pass if validator returns valid=true
- Evidence: validator output + interpretation

## Calling R Validators

For R package skills, validators are in `lib/r-validators/`:

```bash
# Plot validation
Rscript lib/r-validators/plot-validator.R path/to/code.R
# Returns: {"valid":true,"layers":3,"has_title":true,"message":"Valid ggplot object"}

# Spatial validation
Rscript lib/r-validators/spatial-validator.R path/to/code.R
# Returns: {"valid":true,"crs":"EPSG:4326","geometry_type":"POINT","message":"Valid sf object"}

# HTML validation
Rscript lib/r-validators/html-validator.R path/to/output.html
# Returns: {"valid":true,"has_body":true,"has_table":true,"message":"Valid HTML"}

# Numerical validation
Rscript lib/r-validators/numerical-validator.R path/to/code.R
# Returns: {"valid":true,"is_finite":true,"range":[1.2,45.7],"message":"Valid numeric result"}
```

Use validator output as evidence in grading.json.

## Output Format

Save results to `grading.json` in eval directory:

```json
{
  "eval_id": "collapse-grouped-stats",
  "eval_name": "Grouped statistics with collapse",
  "assertions": [
    {
      "text": "Uses fmean() not mean()",
      "passed": true,
      "evidence": "Code contains fmean() on line 8"
    },
    {
      "text": "Uses fgroup_by() not group_by()",
      "passed": true,
      "evidence": "Code contains fgroup_by(region) on line 7"
    },
    {
      "text": "Code runs without errors",
      "passed": true,
      "evidence": "Execution successful, no error messages"
    },
    {
      "text": "Code is readable",
      "passed": true,
      "evidence": "Clear variable names, proper indentation, comments explain TRA usage"
    }
  ],
  "overall_pass": true,
  "pass_count": 4,
  "total_count": 4
}
```

## Tips

- **Be objective**: Code patterns and execution are pass/fail
- **Be fair on qualitative**: High bar but not perfection
- **Check transcripts**: Sometimes agents explain reasoning that helps grading
- **Run validators in eval directory**: Paths are relative to workspace
