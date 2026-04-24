# Testing

How to test a skill before deploying. Absorbs grading guidance; no separate grading file.

## Test Case Format (`evals.json`)

```json
{
  "skill_name": "r-{package}",
  "evals": [
    {
      "id": 1,
      "name": "descriptive-test-name",
      "prompt": "User's task prompt",
      "files": [],
      "assertions": [
        {"type": "code_pattern", "description": "Uses fmean()", "check": "contains 'fmean('"},
        {"type": "execution",    "description": "Runs clean",   "check": "exit_code == 0"},
        {"type": "file_exists",  "description": "Creates plot", "check": "outputs/plot.png exists"},
        {"type": "qualitative",  "description": "Idiomatic code"},
        {"type": "domain_validator", "description": "Valid plot", "validator": "plot-validator.R"}
      ]
    }
  ]
}
```

Give each eval a descriptive name (not just `eval-0`) and use that name for its workspace directory.

## Run Test Cases

**Spawn with-skill AND baseline in the same turn.** Do not run with-skill first and return for baselines later -- the timing comparison breaks. If you are improving an existing skill instead of creating a new one, snapshot the old skill (`cp -r <skill> <workspace>/skill-snapshot/`) and point the baseline at the snapshot (`old_skill/outputs/`).

```
workspace/
  iteration-1/
    eval-{name}/
      with_skill/
        outputs/         # generated files
        timing.json      # {total_tokens, duration_ms, total_duration_seconds}
      without_skill/     # or old_skill/ if improving
        outputs/
        timing.json
      eval_metadata.json # {eval_id, eval_name, prompt, assertions}
      grading.json
  iteration-2/
    ...
  benchmark.json         # aggregated
```

**Capture timing immediately.** Each subagent completion notification contains `total_tokens` and `duration_ms`. Save them to `timing.json` as they arrive -- the notification is the only place this data exists.

## Grade

For each run, check each assertion against the outputs. For programmatic assertions (`code_pattern`, `file_exists`, `execution`, `domain_validator`), write a script -- faster and reusable. For `qualitative`, judge fairly: clear problems, not style nits.

`grading.json` MUST use the field names `text`, `passed`, `evidence` in its expectations array. Other variants (`name`/`met`/`details`) break downstream tooling.

```json
{
  "eval_id": "collapse-grouped-stats",
  "eval_name": "Grouped statistics with collapse",
  "expectations": [
    {"text": "Uses fmean() for grouped means", "passed": true,  "evidence": "fmean() called on line 5"},
    {"text": "Code is readable",                "passed": true,  "evidence": "Clear names, logical flow"}
  ],
  "overall_pass": true,
  "pass_count": 2,
  "total_count": 2
}
```

### Domain Validators (R)

For R-specific assertions, call the validators in `lib/r-validators/` at repo root:

```bash
Rscript lib/r-validators/plot-validator.R outputs/code.R
# -> {"valid": true, "layers": 3, "has_title": true}
```

Use the returned JSON as the `evidence` field.

## Aggregate

Combine per-eval `grading.json` + `timing.json` into a single `benchmark.json` for the iteration. For each configuration (with_skill, baseline), report `pass_rate`, and for time and tokens report `mean ± stddev` and the delta vs. baseline. Put the with_skill entry before its baseline.

After aggregation, do an analyst pass: look for assertions that always pass (non-discriminating), high-variance evals (possibly flaky), and time/token tradeoffs. Surface these as `analyst_notes` in `benchmark.json` or alongside it.

## Stopping Criteria

Stop when BOTH:

1. `pass_rate >= 90%`
2. No improvement for 2 iterations

If either fails, analyze the failing assertions, edit the skill (add guidance, remove guidance agents ignored, rework Quick Reference), and rerun into `iteration-N+1/`.

## YAGNI

If transcripts show agents consistently skipping a section, remove it and retest. If performance is unchanged, keep it removed.
