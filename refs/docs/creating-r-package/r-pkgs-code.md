# R Code Organization in Packages

Source: https://r-pkgs.org/code.html

## File Organization Principles

All R code must reside in `.R` files within the `R/` directory.

### File Naming Strategies

**Single Function Files**: Use when a function is substantial or heavily documented.

**Main Function Plus Helpers**: Group a primary user-facing function with its supporting internal functions.

**Related Function Families**: Collect functions serving a common purpose with shared documentation and helpers.

**Utility Collections**: Place small helper functions used across multiple package functions in `R/utils.R`.

## Code Execution Timing

**CRITICAL: "Package code is run when the package is built."**

When binaries are created (often by CRAN), all `R/` code executes once. Results cache for later retrieval when users attach packages via `library()`.

**"Any R code outside of a function is suspicious and should be carefully reviewed."**

### Problematic Pattern Examples

**System File Paths**: Don't call `system.file()` at the top level - paths become invalid when binaries transfer across machines. Wrap in functions.

**Display Objects**: Don't compute displays during builds on headless servers. Transform to zero-argument functions.

**Function Aliasing**: Don't use `foo <- pkgB::blah` - creates snapshot at build time. Use `foo <- function(...) pkgB::blah(...)` instead.

## Functions to Avoid in Package Code

- `library()` or `require()`: Use DESCRIPTION for dependencies
- `source()`: Never load code from files within packages
- `options()`: Use only with proper restoration
- `par()`: Restore graphics parameters on exit
- `setwd()`: Change working directories only temporarily
- `Sys.setenv()`: Manage environment variables carefully
- `set.seed()`: Never modify random number state without restoration

## State Management with withr

The withr package provides tools for temporary state changes:

- `with_options()` and `local_options()`: Manage R options
- `with_envvar()` and `local_envvar()`: Handle environment variables
- `with_dir()` and `local_dir()`: Change directories temporarily
- `with_par()` and `local_par()`: Modify graphics parameters

## Side Effects and Initialization

Use `.onLoad()` (executed when packages load) or `.onAttach()` (when attached via `library()`). Generally prefer `.onLoad()`.

Store these functions in `R/zzz.R` by convention.

## Character Encoding for CRAN

CRAN packages must use ASCII characters in `.R` files. For necessary non-ASCII characters, use Unicode escapes: `"\uXXXX"` format.
