---
name: creating-r-package
description: Use when creating a new R package from scratch, setting up package structure, or starting package development workflow
---

# Creating R Packages

## Overview

**Use usethis/devtools workflow, not base R tools.** The modern R package development workflow centers on frequent iteration with `load_all()`, `document()`, `test()`, and `check()`.

**Avoid `package.skeleton()`** - it creates packages incompatible with modern workflows.

## Quick Start

```r
# Create package
usethis::create_package("path/to/pkgname")

# Setup essentials (run once)
usethis::use_git()
usethis::use_mit_license()
usethis::use_testthat(3)
usethis::use_readme_rmd()
usethis::use_package_doc()
usethis::use_github_action("check-standard")  # CI

# As needed
usethis::use_data(mydata)           # Include datasets
usethis::use_vignette("intro")      # Long-form docs

# Development cycle (run frequently)
devtools::load_all()     # Ctrl+Shift+L - simulate install
devtools::document()     # Ctrl+Shift+D - update docs
devtools::test()         # Ctrl+Shift+T - run tests
devtools::check()        # Ctrl+Shift+E - validate package
```

## Quick Reference

| Task | Function |
|------|----------|
| Create package | `usethis::create_package()` |
| Add dependency | `usethis::use_package("pkg")` |
| Add test file | `usethis::use_test("feature")` |
| Add function file | `usethis::use_r("function")` |
| Simulate install | `devtools::load_all()` |
| Update docs | `devtools::document()` |
| Run tests | `devtools::test()` |
| Full validation | `devtools::check()` |

## Package Naming

**Rules:** Letters, numbers, periods only. Start with letter. No hyphens/underscores.

**Tips:** All lowercase, unique, pronounceable. Use `available::available("pkgname")` to check.

## File Organization in R/

| Pattern | When to Use |
|---------|-------------|
| One function per file | Substantial functions with heavy docs |
| Main + helpers | Primary function with internal helpers |
| Related family | Functions serving common purpose |
| `utils.R` | Small helpers used across package |

**Critical:** Public functions first, then private helpers. Code outside functions runs at build time, not runtime.

## DESCRIPTION Essentials

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

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Code outside functions in R/ | Wrap in function - runs at build time otherwise |
| Using `library()` in package code | Use `@importFrom` or `pkg::function()` |
| `source()` in package | Never - use proper imports |
| Modifying global state | Use `withr::local_*()` for temporary changes |
| Top-level `system.file()` | Wrap in function for runtime evaluation |
| `foo <- pkg::fun` aliasing | Use `foo <- function(...) pkg::fun(...)` |
| Non-ASCII in .R files | Use `"\uXXXX"` escapes for CRAN |

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

## References

For detailed patterns, see `references/`:
- `style-guide.md` - Error messages with `cli::cli_abort()`, NEWS format, documentation style
- `testing.md` - Expectations reference, snapshot testing, fixtures, skip conditions

**Related skill:** `r-package-skill` is for documenting *existing* R packages as skills, not creating new packages.

Primary source: https://r-pkgs.org/
