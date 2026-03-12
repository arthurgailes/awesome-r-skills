---
name: r-collapse
description: Use when performing fast grouped/weighted statistical operations, panel data analysis, using the collapse package in R, or when dplyr performance is insufficient
---

# collapse: Fast Data Transformation in R

## Overview

**collapse is a C/C++-based package for high-performance grouped and weighted statistical computing.** It's 50-100x faster than dplyr for grouped operations and matches data.table speed while working with any data frame type.

## When to Use collapse vs Alternatives

| Use collapse when...        | Use dplyr when...           | Use data.table when...            |
| --------------------------- | --------------------------- | --------------------------------- |
| Grouped stats on large data | Readability matters most    | Reference semantics (`:=` chains) |
| Weighted computations       | Arbitrary grouped functions | Keyed joins, rolling joins        |
| Panel data (between/within) | Small datasets              | Non-equi joins                    |
| Time series lags/diffs      | Plugin ecosystem            | In-place modification needed      |

**Key insight:** collapse works on tibbles, data.tables, and xts without conversion.

## Quick Start

```r
library(collapse)

# Fast grouped mean (50-100x faster than dplyr)
data |> fgroup_by(category) |> fmean()

# Weighted aggregation
data |> fgroup_by(region) |> fmean(w = weight_col)

# Multiple stats
collap(data, ~ category, list(fmean, fsd, fmedian))
```

## The TRA Argument (Key Differentiator)

Apply transformations in a single C pass - far faster than separate mutate steps:

```r
data |> fgroup_by(id) |> fmean(TRA = "-")    # Demean (fixed effects)
data |> fgroup_by(id) |> fsd(TRA = "/")      # Scale by group SD
data |> fgroup_by(id) |> fmean(TRA = "fill") # Fill with group mean
```

| TRA      | Operation | Use             |
| -------- | --------- | --------------- |
| `"-"`    | Subtract  | Demeaning       |
| `"/"`    | Divide    | Scaling         |
| `"fill"` | Replace   | Imputation      |
| `"-+"`   | Center    | Standardization |

## Quick Reference

| Task          | Function                                   |
| ------------- | ------------------------------------------ |
| Grouped stats | `fmean`, `fsum`, `fsd`, `fmedian`, `fmode` |
| Aggregation   | `collap(df, ~ by, FUN)`, `fsummarise()`    |
| Transform     | `ftransform()`, `fmutate()`                |
| Selection     | `fselect()`, `fsubset()` (~100x faster)    |
| Time series   | `flag()`, `fdiff()`, `fgrowth()`           |
| Panel data    | `qsu()`, `fwithin()`, `fbetween()`         |

## Common Gotchas

1. **Grouping incompatibility:** `group_by()` groups are ignored by collapse functions. Use `fgroup_by()` or pass `g =` explicitly

2. **collap applies to ALL numeric columns:** Unlike dplyr's `summarise()`, must be explicit about columns

3. **Default na.rm = TRUE:** Unlike base R, collapse skips NA by default

4. **fwithin/fbetween don't collapse:** They return same rows (centered or group means)

5. **Global options affect behavior:** In packages, set arguments explicitly:

   ```r
   set_collapse(na.rm = TRUE, nthreads = 4, sort = FALSE)
   ```

6. **sort = FALSE for speed:** When order doesn't matter, can be 3x faster

## Detailed Reference

- **API.md**: Complete function reference (240+ functions)
- **advanced.md**: Panel data, dplyr integration, performance patterns
