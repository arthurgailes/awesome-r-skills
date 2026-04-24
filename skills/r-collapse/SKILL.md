---
name: r-collapse
description: Use when code loads or uses collapse (library(collapse), collapse::), performing fast grouped or weighted statistics in R, or seeking faster alternatives to dplyr aggregation
---

# collapse: Fast Data Transformation

## Overview

**collapse provides C/C++-based high-performance grouped and weighted statistics.** 50-100x faster than dplyr for grouped operations, matches data.table speed while working with any data frame type (tibbles, data.tables, xts).

**Core principle:** Fast aggregation, transformation, and panel data operations through vectorized C code.

## References

Read `references/API.md` before writing code.

- `references/API.md` - Complete function reference
- `references/collapse-for-tidyverse-users.md` - Migration guide and patterns
- `references/collapse-documentation.md` - Core concepts and usage
- `references/collapse-and-sf.md` - Working with spatial data
- `references/collapse-object-handling.md` - Data structure handling

## When to Use

**Use collapse when:**

- Dataset >100k rows
- Weighted statistics required
- Panel data (between/within transformations)
- Time series lags/diffs/growth rates
- Performance bottleneck in dplyr pipeline

**Don't use:**

- Small datasets (<10k rows) - dplyr is clearer
- Need arbitrary grouped functions (use dplyr)
- Working with sf (use sf and dplyr)
- Need reference semantics/in-place modification (use data.table)
- Complex joins (data.table's keyed/rolling/non-equi joins better)

**vs Alternatives:**

| Scenario                  | Use This   |
| ------------------------- | ---------- |
| Large grouped stats       | collapse   |
| Weighted computations     | collapse   |
| sf manipulation           | dplyr      |
| Reference semantics       | data.table |
| Complex joins             | data.table |
| Arbitrary group functions | dplyr      |

## Quick Reference

| Task              | Function/Example                          |
| ----------------- | ----------------------------------------- |
| **Grouped stats** | `fmean()`, `fsum()`, `fsd()`, `fmedian()` |
| **Aggregation**   | `collap(df, ~ by, list(fmean, fsd))`      |
| **Transform**     | `ftransform()`, `fmutate()`               |
| **Selection**     | `fselect()`, `fsubset()` (~100x faster)   |
| **Time series**   | `flag()`, `fdiff()`, `fgrowth()`          |
| **Panel data**    | `fwithin()`, `fbetween()`, `qsu()`        |
| **Grouping**      | `fgroup_by()`, `GRP()`                    |

## Core Pattern

```r
library(collapse)

# Basic: grouped mean (50-100x faster than dplyr)
data |> fgroup_by(category) |> fmean()

# Weighted aggregation
data |> fgroup_by(region) |> fmean(w = weight_col)

# Multiple stats at once
collap(data, ~ category, list(fmean, fsd, fmedian))

# TRA transformations (key differentiator - single C pass)
data |> fgroup_by(id) |> fmean(TRA = "-")    # Demean: subtract group mean
data |> fgroup_by(id) |> fsd(TRA = "/")      # Scale: divide by group SD
data |> fgroup_by(id) |> fmean(TRA = "fill") # Fill: replace NA with group mean
# See references/API.md for full TRA options ("-", "/", "fill", "-+", "replace")
```

## Common Mistakes

| Mistake                                    | Fix                                                      |
| ------------------------------------------ | -------------------------------------------------------- |
| Using `group_by()` with collapse functions | Use `fgroup_by()` or pass `g = GRP(groupvar)`            |
| `collap()` applies to ALL numeric columns  | Explicitly select columns before calling                 |
| Expecting `na.rm = FALSE` default          | collapse defaults to `na.rm = TRUE`                      |
| `fwithin()`/`fbetween()` collapse rows     | They return same # rows (centered/group means)           |
| Global options affect behavior             | Set arguments explicitly in package code                 |
| Ignoring `sort = FALSE` speedup            | Add `sort = FALSE` when order doesn't matter (3x faster) |

## Advanced

See `references/` for API reference, vignette content (tidyverse comparison, sf integration, object handling, development guidelines), and panel data patterns.

**Validator:** `lib/r-validators/numerical-validator.R`

**Resources:** [Docs](https://sebkrantz.github.io/collapse/)
