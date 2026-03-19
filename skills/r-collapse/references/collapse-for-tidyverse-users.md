# collapse for tidyverse Users

## Overview

collapse is a C/C++ based package for data transformation and statistical computing in R that aims to deliver superior performance while maintaining a lightweight, class-agnostic API. It serves as a core component of the fastverse ecosystem.

The package provides tidyverse-compatible functionality but with significantly faster execution and fewer dependencies. While it doesn't replicate all tidyverse features, it draws inspiration from multiple data manipulation libraries including data.table and polars.

## Namespace and Masking Functions

collapse uses f-prefixes to avoid conflicts with tidyverse: `fselect`, `fgroup_by`, `fsummarise`, `fmutate`, `across`, `frename`, `fslice`, and `fcount`.

Users can eliminate prefixes using `set_collapse(mask = "manip")`, which provides functions like `select`, `group_by`, `summarise`, `mutate`, and `rename` in the collapse namespace. Documentation still requires prefixes (e.g., `?fsubset`).

**Key optimization options available:**
- `nthreads`: enables multithreading
- `na.rm`: controls missing value handling
- `sort`: manages group sorting
- `stable.algo`: ensures reproducible ordering

## Fast Statistical Functions

The core strength involves fully vectorized S3-generic statistical operations working across columns, groups, weights, and transformations simultaneously.

**Example capabilities with `fmean()`:**

```r
fmean(mtcars$mpg)              # Vector
fmean(mtcars)                  # Data frame
fmean(mtcars$mpg, w=mtcars$wt) # Weighted
fmean(mtcars$mpg, g=mtcars$cyl) # Grouped
```

These functions integrate directly with data manipulation operations. The `TRA` argument enables transformations like "fill" (group replacement) or "-" (centering).

## Writing Efficient Code

### Core Principles

Efficient collapse code requires:

1. **Selective column subsetting during filtering** - Include only needed columns in subset operations rather than filtering entire frames
2. **Avoiding grouped filtering** - Don't call `fsubset()` on already-grouped data
3. **Using ad-hoc grouping** - Leverage internal grouping through statistical functions rather than always materializing groups

### Internal Grouping Strategies

Instead of `fgroup_by()`, use statistical functions with grouping arguments:

```r
mtcars |> mutate(mpg_median = fmedian(mpg, list(cyl, vs, am), TRA = "fill"))
```

For multiple columns, employ `across()` or `ftransformv()`:

```r
mtcars |> transformv(c(mpg, disp, qsec), fmedian, list(cyl, vs, am), TRA = "fill")
```

Related functions include:
- `fbetween()` - for averaging
- `fwithin()` - for centering/demeaning
- `fscale()` - for grouped scaling

### Advanced Example: RCA Index Calculation

The vignette demonstrates computing Balassa's Revealed Comparative Advantage index for trade data:

```r
settfm(exports, RCA = fsum(v, list(c, y), TRA = "/") %/=% fsum(...))
```

This shows how multiple grouped operations within single expressions enable complex calculations efficiently.

## Performance Optimization Techniques

1. **Reference-based operations** - Use `%/=%` instead of `/` to avoid intermediate copies
2. **In-place transformation** - Pass `set = TRUE` to modify data by reference
3. **Reduce grouping materialization** - Use `return.groups = FALSE` in `fgroup_by()` for mutate operations
4. **Enable multithreading** - Set `nthreads` appropriately for parallel column operations

## Key Differences from tidyverse

- **No `.by` arguments** - Grouping handled through function parameters instead
- **Strict about operations** - Discourages inefficient sequences like filtering/arranging grouped data
- **Eager vectorization** - Expressions typed directly vectorize; nested functions don't
- **Default `na.rm = TRUE`** - Contrasts with base R's handling (changeable via `set_collapse()`)

## Real-World Application

The exports example demonstrates handling unbalanced panel data with:
- Grouped computations (`fsum`, `fmax`)
- Growth rate calculations (`fgrowth` with time variables)
- Flexible subsetting combining multiple conditions
- Pivot operations aggregating results

## Conclusion

collapse offers substantial performance improvements over tidyverse for users willing to learn slightly different syntax. The package excels when combined with other fastverse packages, though collapse alone handles approximately 99% of typical tidyverse workflows with greater efficiency and smaller dependency footprints.
