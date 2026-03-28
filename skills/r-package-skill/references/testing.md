# Testing Infrastructure

Complete guide to testing skills before deployment.

## Test Case Format

Store test cases in `evals.json`:

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "name": "descriptive-test-name",
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": [],
      "assertions": [
        {
          "type": "code_pattern",
          "description": "Uses correct function",
          "check": "contains 'fmean()'"
        },
        {
          "type": "execution",
          "description": "Code runs without errors",
          "check": "exit_code == 0"
        },
        {
          "type": "qualitative",
          "description": "Code is readable and follows conventions"
        }
      ]
    }
  ]
}
```

## Running Tests

**Step 1: Spawn subagents** (with-skill + baseline)
- Create `workspace/iteration-1/eval-{name}/` for each test
- Spawn with skill: save outputs to `with_skill/outputs/`
- Spawn baseline: save outputs to `without_skill/outputs/` (or `old_skill/outputs/` if improving)
- Capture timing.json (tokens, duration_ms from task notifications)

**Step 2: Grade outputs**
- Spawn grader agent (see agents/grader.md)
- Check each assertion against outputs
- Save grading.json with pass/fail per assertion

**Step 3: Aggregate results**
- Combine into benchmark.json
- Calculate pass_rate, timing mean ± stddev, tokens
- Compare with-skill vs baseline

**Step 4: Iterate**
- If pass_rate < 90%: analyze failures, improve skill
- If pass_rate >= 90% AND no improvement for 2 iterations: DONE
- Else: create iteration-N+1/ and re-test

## Assertion Types

### Code Pattern Matching

Check if output contains string/pattern.

```json
{"type": "code_pattern", "description": "Uses collapse", "check": "contains 'library(collapse)'"}
```

### Execution Validation

Check if code ran successfully.

```json
{"type": "execution", "description": "No errors", "check": "exit_code == 0"}
```

### Output Validation

Check if expected files created.

```json
{"type": "file_exists", "description": "Creates plot", "check": "outputs/plot.png exists"}
```

### Qualitative

Grader agent makes judgment call.

```json
{"type": "qualitative", "description": "Code is readable and follows conventions"}
```

### Domain Validators

Call specialized validation scripts.

```json
{"type": "domain_validator", "description": "Valid plot", "validator": "plot-validator.R"}
```

For language-specific validators (R, Python, etc.), see language-specific skill creation guidance (e.g., r-package-skill for R validators).

## Workspace Organization

```
workspace/
  iteration-1/
    eval-descriptive-name/
      with_skill/
        outputs/              # Generated files
        timing.json          # {total_tokens, duration_ms}
      without_skill/
        outputs/
        timing.json
      eval_metadata.json     # {eval_id, name, prompt, assertions}
      grading.json          # {assertions: [{text, passed, evidence}]}
  iteration-2/
    ...
  benchmark.json           # Aggregated results across evals
```

## Stopping Criteria

**Stop when BOTH:**
1. pass_rate >= 90%
2. No improvement for 2 iterations

**90% threshold:** High quality bar, allows for edge cases

**2 iteration plateau:** Prevents endless iteration on diminishing returns

If either condition fails, keep improving.
