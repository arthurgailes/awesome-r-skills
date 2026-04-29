# collapse API Reference

Complete function reference for the collapse package.

## Fast Statistical Functions

Core grouped/weighted statistics:

| Function | Purpose |
|----------|---------|
| `fmean()` | Fast (grouped, weighted) mean |
| `fmedian()` | Fast (grouped, weighted) median |
| `fmode()` | Fast (grouped, weighted) mode |
| `fsum()` | Fast (grouped, weighted) sum |
| `fprod()` | Fast (grouped, weighted) product |
| `fsd()`, `fvar()` | Fast standard deviation/variance |
| `fmin()`, `fmax()` | Fast minimum/maximum |
| `fnth()` | Fast nth element/quantile |
| `fquantile()` | Fast quantile computation |
| `frange()` | Fast range (min/max pair) |
| `ffirst()`, `flast()` | Fast first/last value |
| `fnobs()` | Fast number of observations |
| `fndistinct()` | Fast number of distinct values |

All support:
- Grouped operations via `g` parameter
- Weighted operations via `w` parameter
- Transformation via `TRA` parameter ("replace", "-", "/", etc.)
- Column-wise or row-wise computation

## Fast Grouping and Ordering

| Function | Purpose |
|----------|---------|
| `GRP()` | Create grouping object for fast operations |
| `fgroup_by()` | dplyr-style grouping |
| `radixorder()` | Fast radix-based ordering |
| `fmatch()` | Fast matching (like `match()`) |
| `funique()` | Fast unique values |
| `fduplicated()` | Fast duplicate detection |
| `qF()` | Quick factor generation |

## Fast Data Manipulation

| Function | Purpose |
|----------|---------|
| `fselect()` | Fast column selection |
| `fsubset()` | Fast row subsetting |
| `fsummarise()` / `fsummarize()` | Fast dplyr-style summarise |
| `fmutate()` | Fast dplyr-style mutate |
| `fslice()` / `fslicev()` | Fast dplyr-style slice |
| `ftransform()` | Fast transformation |
| `frename()` | Fast renaming |
| `fcompute()` | Compute expressions |
| `get_vars()`, `add_vars()` | Variable operations |
| `roworder()` / `roworderv()` | Reorder rows |
| `colorder()` / `colorderv()` | Reorder columns |
| `rowbind()` | Fast row binding (rbind alternative) |
| `join()` | Data frame joins |
| `pivot()` | Reshaping (long/wide) |

## Data Aggregation

| Function | Purpose |
|----------|---------|
| `collap()` | Multi-type, multi-function aggregation |
| `BY()` | Apply functions by groups |

**collap() features:**
- Multiple aggregation functions per variable
- Weighted aggregation
- Parallel processing
- Preserves attributes

## Data Transformations

| Function | Purpose |
|----------|---------|
| `fwithin()` | Within-transformation (demeaning) |
| `fbetween()` | Between-transformation (group means) |
| `fscale()` | Scaling and centering |
| `STD()` | Standardize |
| `W()`, `B()` | Within/between shortcuts |
| `HDB()`, `HDW()` | Higher-dimensional operations |

## Panel Data Indexing

| Function | Purpose |
|----------|---------|
| `findex_by()` | Create indexed panel data frame |
| `findex()` | Retrieve index from panel data frame |
| `reindex()` | Re-attach index to data frame |
| `is_irregular()` | Check if panel is irregularly spaced |
| `to_plm()` | Convert to plm (panel linear model) format |

## Time Series and Panel Data

| Function | Purpose |
|----------|---------|
| `flag()` | Lag/lead values |
| `fdiff()` | Differences |
| `fgrowth()` | Growth rates |
| `fcumsum()` | Fast cumulative sum |
| `psmat()` | Panel series matrix |
| `psacf()`, `pspacf()` | Panel autocorrelation |
| `psccf()` | Panel cross-correlation |

## Linear Models

| Function | Purpose |
|----------|---------|
| `flm()` | Fast ordinary least squares (OLS) regression |
| `fFtest()` | Fast F-test for model comparison |

## Value Replacement and Recoding

| Function | Purpose |
|----------|---------|
| `recode_num()` | Recode numeric values |
| `recode_char()` | Recode character values |
| `replace_na()` | Replace NA values |
| `replace_inf()` | Replace Inf/-Inf values |
| `replace_outliers()` | Replace outlier values |
| `pad()` | Pad panel data to balanced |

## Summary Statistics

| Function | Purpose |
|----------|---------|
| `qsu()` | Quick summary statistics (grouped, weighted) |
| `qtab()` | Quick cross-tabulation |
| `descr()` | Descriptive statistics |
| `pwcor()`, `pwcov()` | Pairwise correlation/covariance |
| `pwnobs()` | Pairwise number of observations |

## Quick Conversion

| Function | Purpose |
|----------|---------|
| `qDF()` | Quick data frame |
| `qDT()` | Quick data.table |
| `qM()` | Quick matrix |
| `mrtl()`, `mctl()` | Matrix to list conversions |

## List Processing

| Function | Purpose |
|----------|---------|
| `rsplit()` | Recursive split |
| `rapply2d()` | Recursive apply to 2D |
| `unlist2d()` | Unlist to 2D structure |
| `is_unlistable()` | Check if list is unlistable |

## Data Structure Information

| Function | Purpose |
|----------|---------|
| `fdim()` | Fast dimensions |
| `fnrow()`, `fncol()` | Fast row/column count |
| `fNobs()` | Fast number of non-missing |
| `fNdistinct()` | Fast number of distinct |
| `vlengths()` | Variable lengths |
| `vclasses()` | Variable classes |

## TRA Argument

The `TRA` parameter enables in-place transformations in statistical functions:

| Value | Transformation |
|-------|----------------|
| `"replace_fill"` | Replace with statistic, fill missing |
| `"replace"` | Replace with statistic |
| `"-"` | Subtract statistic (demean) |
| `"+"` | Add statistic |
| `"*"` | Multiply by statistic |
| `"/"` | Divide by statistic |
| `"%%"` | Modulo |
| `"-+"` | Subtract and add back |
| `"++"` | Add twice |

**Example:**
```r
# Demean by group
fmean(mtcars$mpg, mtcars$cyl, TRA = "-")

# Equivalent to:
mtcars$mpg - fmean(mtcars$mpg, mtcars$cyl)
```

## Documentation

**Package site:** https://fastverse.org/collapse/
**CRAN:** https://cran.r-project.org/web/packages/collapse/
