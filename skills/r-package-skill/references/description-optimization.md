# Description Optimization

Optimize skill descriptions for triggering accuracy after skill functionality is verified.

## Goal

Skill works correctly → ensure it loads at the right times (and doesn't load at wrong times).

## Test Query Format

Generate 20 realistic user queries:
- 10 SHOULD trigger skill
- 10 SHOULD NOT trigger skill

Store in `description-evals.json`:

```json
{
  "skill_name": "example-skill",
  "queries": [
    {
      "query": "How do I debug this pipe chain?",
      "should_trigger": true,
      "reason": "Direct symptom - pipe debugging"
    },
    {
      "query": "Write a new REST API endpoint",
      "should_trigger": false,
      "reason": "Unrelated to debugging or pipes"
    }
  ]
}
```

## R Package Skill Description Template

For R package skills, descriptions MUST include explicit code-recognition tokens:

```yaml
description: Use when code loads or uses {package} (library({package}), {package}::), [file-type triggers], [domain triggers]
```

**Why:** Descriptions like "Use when creating interactive maps" are action-oriented but miss recognition signals. When a user's prompt contains `pacman::p_load(mapgl)` or `library(collapse)`, Claude needs explicit package-name tokens in the description to match on. Leading with "code loads or uses {package}" ensures the package name appears as a matchable trigger.

**Required elements:**
1. `library()` and `::` patterns with the package name
2. File extensions the package works with (.pmtiles, .parquet, .docx)
3. Domain-specific problem descriptions

**Example:**
```yaml
# Good: explicit recognition tokens + domain triggers
description: Use when code loads or uses freestiler, working with .pmtiles files, converting spatial data to vector tilesets in R, or preparing tiles for mapgl/MapLibre visualization

# Bad: action-oriented, misses code-recognition signals
description: Use when creating PMTiles vector tilesets from large spatial datasets, using the freestiler package in R
```

## Should Trigger Patterns

**Direct symptoms:**
- Exact error messages the skill addresses
- Tool names mentioned in skill (ggplot2, dplyr)
- Problem symptoms (flaky tests, slow queries)

**Indirect symptoms:**
- Related problems skill solves
- Situations where skill applies
- Contextual clues (working with spatial data → r-sf)

**Edge cases to include:**
- Variant phrasings of same problem
- Related but distinct issues
- Subtle symptoms that hint at skill relevance

## Should NOT Trigger Patterns

**Unrelated domains:**
- Different technology stack
- Different problem space
- Different workflow stage

**Similar but distinct:**
- Same domain but different problem
- Overlapping terminology but different context
- Adjacent skills that should load instead

**Edge cases to include:**
- Queries that mention skill keywords but in wrong context
- Problems that sound similar but aren't
- Cases where different skill should load

## Testing Descriptions

1. Generate 20 queries (balanced should/shouldn't)
2. Test current description against held-out set
3. Calculate accuracy: (correct triggers + correct non-triggers) / 20
4. If accuracy < 90%, analyze failures
5. Update description to fix mis-triggers
6. Re-test until >= 90% accuracy

## Common Description Issues

**Too broad:**
- Description: "Use when working with data"
- Problem: Triggers on everything
- Fix: Add specific symptoms/contexts

**Too narrow:**
- Description: "Use when error message says 'could not find function fmean'"
- Problem: Misses related issues
- Fix: Include related symptoms, not just exact error

**Wrong keywords:**
- Description mentions implementation details (internal functions)
- Problem: User queries use problem language, not solution language
- Fix: Focus on problem symptoms, not solution mechanics

## Iteration Pattern

```
Current accuracy: 75%
False positives: 2 (loaded when shouldn't)
False negatives: 3 (didn't load when should)

Analysis:
- FP: Description too broad on "data processing"
- FN: Missing "slow performance" as symptom

Update description:
- Remove "data processing" → add "grouped statistics with collapse"
- Add "slow aggregation" symptom

Re-test → 90% accuracy → DONE
```

## Stop When

Description accuracy >= 90% on held-out test queries.

If can't reach 90%, consider:
- Skill scope too broad/narrow (redesign needed)
- Overlaps with existing skills (merge or clarify boundaries)
- Description length limit hit (prioritize most important triggers)
