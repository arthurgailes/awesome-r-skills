# Autonomous Improvement Loop

Iterate automatically until quality threshold reached.

## Process

1. Run all test cases (with-skill + baseline)
2. Grade outputs, aggregate results into benchmark.json
3. Check stopping criteria:
   - If pass_rate >= 90% AND no improvement for 2 iterations: DONE
   - Else: analyze failures, update skill, goto 1

## Stopping Criteria

**Must meet BOTH conditions:**
- **90% pass rate**: High quality bar, allows for edge cases
- **No improvement for 2 iterations**: Prevents endless iteration on diminishing returns

**If either fails, keep improving.**

## Failure Analysis

When tests fail, analyze patterns:

**Which assertions failed most often?**
- If one assertion fails across all evals, it's fundamental gap in skill
- If failures scattered, might be edge cases

**Are failures consistent or flaky?**
- Consistent: Skill missing guidance
- Flaky (variance across runs): Might be model behavior, not skill issue

**Do transcripts show misunderstanding?**
- Read agent transcripts from failed runs
- Look for where agent went wrong
- Was instruction unclear? Missing? Misinterpreted?

**Common patterns across failures?**
- Multiple tests failing same way suggests systematic issue
- Add explicit guidance for the pattern

## Skill Improvements

Based on failure analysis:

**Add explicit guidance:**
- Failed assertion → new instruction addressing it
- Use examples showing correct approach
- Explain WHY (not just MUST)

**Update Common Mistakes table:**
- Each observed error → row in table
- Include fix, not just problem

**Add examples:**
- If agents confused by abstract instruction, add concrete example
- Before/after code comparisons helpful

**Simplify overcomplicated instructions:**
- If transcripts show agents spending time on unhelpful instruction, remove it
- YAGNI applies to skills: remove unused guidance

**Remove instructions that don't help:**
- Check transcripts: are agents reading this section?
- If consistently ignored, consider removing
- Maybe instruction is in wrong place, or unnecessary

## Iteration Tracking

**Directory structure:**
```
workspace/
  iteration-1/
    benchmark.json         # First run results
  iteration-2/
    benchmark.json         # After improvements
  iteration-3/
    ...
```

**Compare across iterations:**
- Is pass_rate improving?
- Are same assertions failing?
- Has plateau been reached (no improvement)?

**Stop when:**
- pass_rate >= 90% AND (iteration-N pass_rate == iteration-N-1 pass_rate)
- Indicates skill is as good as it will get for these test cases

## YAGNI for Skills

**Remove unused guidance.**

If transcripts show agents consistently ignoring a section:
- Maybe it's not needed
- Maybe it's in wrong place (hard to find)
- Maybe it's too verbose (agents skip long sections)

Test without the section - does it hurt? If not, keep it removed.
