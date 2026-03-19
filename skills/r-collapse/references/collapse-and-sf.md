# Collapse and SF: Fast Manipulation of Simple Features Data Frames

This vignette demonstrates how the `collapse` package integrates with R's `sf` package for efficient geospatial data manipulation.

## Overview

The `collapse` v1.6.0 introduced internal support for `sf` data frames, enabling most essential functions to "internally handle the geometry column." Key supported functions include `fselect/gv`, `fsubset/ss`, `fgroup_by`, `findex_by`, `qsu`, `descr`, `varying`, `funique`, `roworder`, `rsplit`, and `fcompute`.

## Summarizing SF Data Frames

Summary statistics automatically exclude the geometry column:

- `varying()` identifies columns with at least 2 non-missing distinct values
- `qsu()` produces quick summary statistics across numeric and character columns
- `descr()` provides detailed descriptive statistics including quantiles and distributions

For the sample North Carolina shapefile dataset, these functions skip geometry and report statistics for 14 attribute fields.

## Selecting Columns and Subsetting

Column selection preserves geometry without manual intervention:

- `fselect()` uses tidy selection syntax (e.g., `AREA, NAME:FIPSNO`)
- `gv()` (get_vars) provides standard evaluation alternatives
- `fsubset()` combines row filtering with column selection
- `ss()` offers fast subsetting mimicking base `[` syntax

Performance benchmarks show `collapse` functions dramatically outpace `dplyr` equivalents—microseconds versus milliseconds for typical operations.

## Aggregation and Grouping

The `collap()` function aggregates data while specifying custom functions per data type:

```r
collap(nc, ~ SID74, custom = list(fmedian = is.numeric,
                                   fmode = is.character,
                                   st_union = "geometry"))
```

For grouped operations, `fgroup_by()` and `fsummarise()` work together, with geometry combined via `st_union()` or `flast()` for temporal panels.

## Indexing

Functions like `findex_by()` support creating period-based indices within `sf` workflows, maintaining geometric validity.

## Transformations

`fmutate()` and `fcompute()` enable column creation and modification while preserving spatial structure.

## Conversion and Units

The vignette addresses conversion between `sf` and non-spatial formats, plus integration with the `units` package for dimensional analysis.

## Performance Considerations

While `collapse` operations are inherently faster, geometry aggregation via `st_union()` remains computationally expensive. For large datasets, alternatives like `s2` backend functions (`s2_union_agg()`) may prove superior. The `bbox` attribute may require manual updates when subsetting; calling `st_make_valid()` ensures output validity but carries computational cost.

## Conclusion

Combining `collapse` with `sf` achieves substantial speed improvements for non-geometric manipulations while maintaining spatial data integrity throughout workflows.
