# collapse Advanced Reference

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

## Additional Gotchas

- **Time series classes stripped on aggregation:** Aggregating `ts` objects drops the class (intentionally)
- **data.table reference semantics lost:** collapse doesn't overallocate. Wrap results with `qDT()` if you need `:=` afterward
- **fmode on unsorted singleton groups:** Historical bug (fixed) - use latest version
