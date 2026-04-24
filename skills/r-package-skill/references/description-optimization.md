# Description Optimization

Tune a skill's `description` field for triggering accuracy **after** the skill's functionality is verified. The description is the primary mechanism Claude uses to decide whether to load the skill -- a skill that works but never triggers is useless.

## R Package Description Template

R package skill descriptions MUST include code-recognition tokens:

```yaml
description: Use when code loads or uses {package} (library({package}), {package}::), [file-type triggers], [domain triggers]
```

**Why:** Action-oriented descriptions ("Use when creating interactive maps") miss prompts that contain `library(mapgl)` or `pacman::p_load(mapgl)`. Leading with the package name as a recognition token ensures matches on import statements.

**Required elements:**
1. `library({pkg})` and `{pkg}::` patterns
2. File extensions the package works with (`.pmtiles`, `.parquet`, `.docx`)
3. Domain-specific problem language

```yaml
# Good: recognition tokens + domain triggers
description: Use when code loads or uses freestiler, working with .pmtiles files, or preparing vector tiles for mapgl/MapLibre in R

# Bad: action-oriented, misses recognition tokens
description: Use when creating PMTiles vector tilesets from large spatial datasets
```

## Build a Trigger Eval Set (20 queries)

Write 20 realistic queries a real user might send. Split roughly 50/50 should-trigger / should-not-trigger.

```json
[
  {"query": "...", "should_trigger": true},
  {"query": "...", "should_trigger": false}
]
```

**Queries must be concrete and specific,** not abstract. Include file paths, column names, package names in code form, bits of backstory, typos, casual phrasing, mixed case.

Bad (too abstract): `"Plot some data"`, `"Use collapse"`
Good: `"my teacher sent me a csv with 2M rows and i need to calc mean wage by industry and year, my laptop is dying running dplyr -- what else can i do"`

**Should-trigger (8-10):**
- Variant phrasings of the same intent (formal, casual)
- Cases where the user doesn't name the package but clearly needs it
- Uncommon use cases the skill handles
- Cases where this skill competes with another and should win

**Should-NOT-trigger (8-10):**
- Near-misses that share keywords with the skill but need something different
- Adjacent domains where a naive keyword match would fire
- Cases where a different skill should load
- **Not** obviously irrelevant queries -- those test nothing

## Optimization Loop (train / held-out)

Do not tune on the full eval set and declare victory -- you will overfit.

1. Split the 20 queries 60/40 into train / held-out.
2. Evaluate the current description on train (run each query 3x, compute trigger rate).
3. Propose a revised description that fixes failing train queries.
4. Evaluate the revised description on both train AND held-out.
5. Keep the description with the highest **held-out** score (not train).
6. Iterate up to ~5 revisions.

Stop when the held-out score is >= 90% or stops improving.

## Common Failure Modes

| Symptom | Likely cause | Fix |
|---|---|---|
| Triggers on unrelated queries (false positives) | Description too broad | Add specific symptoms / package name tokens |
| Misses queries that name the package in code | No `library({pkg})` / `{pkg}::` token | Add both tokens |
| Fires on sibling-package queries | Shares keywords with sibling skill | Add contrast: "...not dplyr / not data.table" |
| Train improves, held-out doesn't | Overfitting to training queries | Pick the revision with best held-out score, not best train |

If you can't reach 90% on held-out, the skill scope itself is the problem (too broad, too narrow, or overlaps with another skill). Fix the skill, not the description.
