# Testing Reference

Source: https://r-pkgs.org/testing-basics.html

## Expectations Quick Reference

| Expectation | Use For |
|-------------|---------|
| `expect_equal(x, y)` | Equality with numeric tolerance |
| `expect_identical(x, y)` | Exact equivalence |
| `expect_error(code, class = "error_class")` | Specific error type |
| `expect_warning(code)` | Warning condition |
| `expect_message(code)` | Message condition |
| `expect_no_error(code)` | Absence of errors |
| `expect_match(string, regexp)` | Pattern matching |
| `expect_length(object, n)` | Length verification |
| `expect_setequal(x, y)` | Unordered equality |
| `expect_s3_class(x, "class")` | S3 class inheritance |
| `expect_true(x)` / `expect_false(x)` | Boolean |

## Snapshot Testing

Record expected output for complex results:

```r
test_that("output is stable", {
expect_snapshot(my_complex_function())
})
```

Snapshots stored in `tests/testthat/_snaps/`. Run `snapshot_accept()` to update after intentional changes.

**Good for:** Error messages, printed output, plots, complex data structures.

## Test Workflow Scales

| Scale | Command | When |
|-------|---------|------|
| Micro | Run expectations in console | Developing single test |
| Mezzo | `testthat::test_file("tests/testthat/test-foo.R")` | Single file |
| Macro | `devtools::test()` | Full suite |

## Test Fixtures

For shared test data, use `tests/testthat/fixtures/`:

```r
# tests/testthat/helper.R (loaded automatically)
test_data <- readRDS(test_path("fixtures", "sample_data.rds"))
```

## Skip Conditions

```r
skip_on_cran()           # Skip on CRAN (slow/flaky tests)
skip_on_ci()             # Skip on CI
skip_if_not_installed("pkg")  # Skip if dependency missing
skip_if_offline()        # Skip if no internet
```
