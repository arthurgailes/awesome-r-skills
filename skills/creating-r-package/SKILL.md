---
name: creating-r-package
description: Use when creating a new R package from scratch, setting up package structure, or starting package development workflow
---

# Creating R Packages

## Overview

**Use usethis/devtools workflow, not base R tools.** Modern R package development: frequent iteration with `load_all()`, `document()`, `test()`, `check()`.

**Avoid `package.skeleton()`** - incompatible with modern workflows.

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
usethis::use_github_action("check-standard")

# Development cycle (frequent)
devtools::load_all()     # Ctrl+Shift+L - simulate install
devtools::document()     # Ctrl+Shift+D - update docs
devtools::test()         # Ctrl+Shift+T - run tests
devtools::check()        # Ctrl+Shift+E - validate
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

**Tips:** All lowercase, unique, pronounceable. Check with `available::available("pkgname")`.

## File Organization in R/

| Pattern | When to Use |
|---------|-------------|
| One function per file | Substantial functions with heavy docs |
| Main + helpers | Primary function with internal helpers |
| Related family | Functions serving common purpose |
| `utils.R` | Small helpers used across package |

**Critical:** Public functions first, then private helpers. Code outside functions runs at build time.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Code outside functions in R/ | Wrap in function - runs at build time |
| Using `library()` in package | Use `@importFrom` or `pkg::function()` |
| `source()` in package | Never - use proper imports |
| Modifying global state | Use `withr::local_*()` |
| Top-level `system.file()` | Wrap in function for runtime eval |
| `foo <- pkg::fun` aliasing | Use `foo <- function(...) pkg::fun(...)` |
| Non-ASCII in .R files | Use `"\uXXXX"` escapes for CRAN |

## When NOT to Use

- Documenting *existing* R packages as skills → use `r-package-skill` instead
- Single-script projects without reusable functions
- Internal analysis code not meant for sharing

## Advanced

See `references/` for:
- **patterns.md**: Documentation pattern, testing pattern, DESCRIPTION template, .Rbuildignore, workflow diagram, CRAN submission
- **style-guide.md**: Error messages with `cli::cli_abort()`, NEWS format, documentation style
- **testing.md**: Expectations reference, snapshot testing, fixtures, skip conditions

**Primary source:** https://r-pkgs.org/
