# Development Patterns

## Documentation Pattern

```r
#' Title in sentence case without period
#'
#' Description paragraph explaining what the function does.
#'
#' @param x Description starting with capital, ending with period.
#' @param y Another parameter description.
#'
#' @returns Description of return value.
#'
#' @export
#' @examples
#' my_function(1, 2)
my_function <- function(x, y) {
  # implementation
}
```

## Testing Pattern

```r
# tests/testthat/test-feature.R
test_that("feature works correctly", {
  result <- my_function(1, 2)
  expect_equal(result, 3)
})

test_that("feature handles edge cases", {
  expect_error(my_function(NULL, 2), class = "my_error_class")
})
```

## DESCRIPTION File Template

```dcf
Package: pkgname
Title: What The Package Does (Title Case, No Period)
Version: 0.0.0.9000
Authors@R:
    person("First", "Last", email = "email@example.com",
           role = c("aut", "cre"))
Description: One paragraph describing the package. Must be a complete
    sentence ending with a period. Wrapped to 80 characters.
License: MIT + file LICENSE
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.0
Imports:
    dplyr (>= 1.0.0)
Suggests:
    testthat (>= 3.0.0)
```

**Version convention:** `0.0.0.9000` for development, `0.1.0` for first release.

## .Rbuildignore Patterns

Exclude dev files from package build:

```
^\.github$
^README\.Rmd$
^LICENSE\.md$
^\.Rproj\.user$
^.*\.Rproj$
^_pkgdown\.yml$
^docs$
```

Use `usethis::use_build_ignore("file")` to add entries safely.

## Development Workflow

```
Edit R/ code
    |
    v
load_all() -----> Test interactively
    |
    v
Edit tests
    |
    v
test() ---------> Fix failures
    |
    v
document() -----> Check ?function
    |
    v
check() --------> Fix errors/warnings/notes
    |
    v
Commit to git
```

Run `check()` early and often - don't let problems accumulate.

## CRAN Submission

```r
usethis::use_cran_comments()  # Track submission notes
devtools::check(remote = TRUE, manual = TRUE)  # Full check
devtools::release()           # Guided submission
```

Eliminate all NOTEs, WARNINGS, ERRORS before submitting.
