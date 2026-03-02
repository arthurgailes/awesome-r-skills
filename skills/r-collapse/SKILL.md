---
name: r-collapse
description: Use when performing fast grouped/weighted statistical operations, panel data analysis, or when dplyr/data.table performance is insufficient
---

# collapse: Fast Data Transformation in R

## Overview

**collapse is a C/C++-based package for high-performance grouped and weighted statistical computing.** It's 50-100x faster than dplyr for grouped operations and matches data.table speed while working with any data frame type.

## When to Use collapse vs Alternatives

| Use collapse when... | Use dplyr when... | Use data.table when... |
|---------------------|-------------------|------------------------|
| Grouped stats on large data | Readability matters most | Reference semantics (`:=` chains) |
| Weighted computations | Arbitrary grouped functions | Keyed joins, rolling joins |
| Panel data (between/within) | Small datasets | Non-equi joins |
| Time series lags/diffs | Plugin ecosystem | In-place modification needed |
| Speed with tibbles/xts | | Already in data.table workflow |

**Key insight:** collapse works on most data frame types (tibble, data.table, xts) without conversion. sf objects have limited support - basic operations work but geometry handling is shallow; use sf-native functions for spatial operations.

## Quick Start

```r
library(collapse)

# Fast grouped mean (50-100x faster than dplyr)
data |> fgroup_by(category) |> fmean()

# Weighted aggregation
data |> fgroup_by(region) |> fmean(w = weight_col)

# Multiple stats with collap()
collap(data, ~ category, list(fmean, fsd, fmedian))
```

## Core Function Categories

| Category | Key Functions | Use For |
|----------|--------------|---------|
| **Fast stats** | `fmean`, `fsum`, `fsd`, `fvar`, `fmedian`, `fmode` | Grouped/weighted aggregation |
| **Grouping** | `fgroup_by`, `GRP` | Create grouping for pipelines |
| **Aggregation** | `collap`, `fsummarise` | Multi-function aggregation |
| **Transform** | `ftransform`, `fmutate` | Column operations |
| **Selection** | `fselect`, `fsubset`, `get_vars` | Fast subsetting (~100x faster) |
| **Time series** | `flag`, `fdiff`, `fgrowth` | Lags, differences, growth rates |
| **Panel data** | `qsu`, `fbetween`, `fwithin` | Between/within decomposition |

## The TRA Argument (Transformations)

The `TRA` argument applies transformations in a single C pass - far faster than separate mutate steps:

```r
# Demean by group (subtract group mean)
data |> fgroup_by(id) |> fmean(TRA = "-")

# Scale by group SD
data |> fgroup_by(id) |> fsd(TRA = "/")

# Fill with group mean
data |> fgroup_by(id) |> fmean(TRA = "fill")

# Center (demean then add overall mean)
data |> fgroup_by(id) |> fmean(TRA = "-+")
```

| TRA | Operation | Common Use |
|-----|-----------|------------|
| `"-"` | Subtract | Demeaning (fixed effects) |
| `"/"` | Divide | Scaling |
| `"fill"` | Replace | Imputation |
| `"-+"` | Center | Standardization |
| `"+"` | Add | Adjustments |

## Aggregation with collap()

```r
# Simple grouping (applies fmean to numeric, fmode to categorical)
collap(data, ~ category)

# Multiple functions
collap(data, ~ category + year, list(fmean, fmedian))

# Weighted
collap(data, ~ region, w = ~ population)

# Custom column-function mapping
collap(data, ~ country,
       custom = list(fmean = 5:8, fsum = 9:10, fmode = 3:4))

# Long output format
collap(data, ~ category, list(fmean, fsd), return = "long")

# Unweighted stats when weights are present (append _uw)
collap(data, ~ group, fmean, w = ~ weight)     # weighted mean
collap(data, ~ group, fmean_uw, w = ~ weight)  # unweighted despite w
```

## Panel Data Analysis

### Quick Summary with qsu()

```r
# Between/within decomposition - essential for panel data
qsu(panel_data, pid = ~ entity, by = ~ year)

#>            N/T     Mean       SD      Min       Max
#> Overall   9470  12048.78  19077.64   132.08  196061.42
#> Between    206  12962.61  20189.90   253.19  141200.38
#> Within   45.97  12048.78   6723.68 -33504.87  76767.53
```

- **Between**: Variation across entities (cross-sectional)
- **Within**: Variation within entities over time (time-series)

### Panel Transformations

```r
# Within transformation (entity-demeaning for fixed effects)
data |> fgroup_by(entity) |> fwithin()

# Between transformation (entity means)
data |> fgroup_by(entity) |> fbetween()

# Lags and leads (respecting panel structure)
data |> fgroup_by(entity) |> flag(1:3, t = time)    # 3 lags

# Differences and growth
data |> fgroup_by(entity) |> fdiff(1, t = time)     # First diff
data |> fgroup_by(entity) |> fgrowth(1, t = time)   # % growth
```

## dplyr Integration

collapse functions work in dplyr pipes but use different grouping:

```r
library(collapse)
library(dplyr)

# WRONG: dplyr grouping doesn't pass to collapse functions
data |> group_by(cat) |> fmean()  # Groups ignored!

# RIGHT: Use fgroup_by for collapse functions
data |> fgroup_by(cat) |> fmean()

# RIGHT: Or use collapse's grouped data methods
data |> fgroup_by(cat) |> fsummarise(avg = fmean(value))

# To return to dplyr workflow, remove collapse grouping
data |> fgroup_by(cat) |> fmean() |> fungroup()
```

## Common Gotchas

1. **Grouping incompatibility:** `group_by()` groups are ignored by collapse functions. Always use `fgroup_by()` or pass `g =` argument explicitly

2. **Default na.rm = TRUE:** Unlike base R, collapse skips NA by default. Set `na.rm = FALSE` if you need NA propagation

3. **Global options affect behavior:** User options for `na.rm`, `nthreads`, `sort` affect all collapse code. In packages, set arguments explicitly or use:
   ```r
   set_collapse(na.rm = TRUE, nthreads = 4, sort = FALSE)  # Set defaults
   ```

4. **Time series classes stripped on aggregation:** Aggregating `ts` objects drops the class (intentionally - aggregated ts would be meaningless)

5. **data.table reference semantics lost:** collapse doesn't overallocate for speed. Wrap results with `qDT()` if you need `:=` afterward

6. **sort = FALSE for speed:** When order doesn't matter, `sort = FALSE` can be 3x faster:
   ```r
   data |> fgroup_by(cat, sort = FALSE) |> fmean()
   ```

7. **fmode on unsorted singleton groups:** Historical bug (fixed) - always use latest version

## Performance Tips

```r
# Pre-compute grouping for repeated operations
g <- GRP(data, ~ category, sort = FALSE)
fmean(data$value, g = g)
fsd(data$value, g = g)
fmedian(data$value, g = g)

# Use fselect for fast column selection (~100x faster)
data |> fselect(col1, col2, col3)

# Parallel aggregation for many columns
collap(data, ~ category, parallel = TRUE, mc.cores = 4)

# Quick data conversion (faster than as.data.frame)
qDF(matrix_data)  # To data.frame
qDT(df_data)      # To data.table
qM(df_data)       # To matrix
```

## Quick Reference

```r
# Aggregation
fmean(x, g = group)           # Grouped mean
collap(df, ~ by, FUN)         # Full aggregation
fsummarise(gdf, new = fn(x))  # Summarise syntax

# Transformation
ftransform(df, new = expr)    # Add/modify columns
fmutate(gdf, new = expr)      # Grouped mutate

# Selection
fselect(df, cols)             # Select columns
fsubset(df, condition)        # Filter rows
get_vars(df, regex)           # Regex selection

# Time series
flag(x, n, g, t)              # Lag/lead
fdiff(x, n, g, t)             # Differences
fgrowth(x, n, g, t)           # Growth rates

# Panel
qsu(x, pid, by)               # Panel summary
fwithin(x, g)                 # Within transform
fbetween(x, g)                # Between transform
```
