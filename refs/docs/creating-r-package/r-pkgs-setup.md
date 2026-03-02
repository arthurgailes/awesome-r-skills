# System Setup for R Package Development

Source: https://r-pkgs.org/setup.html

## Initial Package Installation

```r
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
```

## devtools and usethis Usage

**devtools** is a meta-package that wraps functionality from multiple underlying packages including remotes, pkgbuild, pkgload, rcmdcheck, and others.

For interactive development work, attach devtools directly:
```r
library(devtools)
```

However, when writing package code that depends on specific functions, import from the original package home rather than devtools. For instance, use `sessioninfo::session_info()` instead of `devtools::session_info()`.

## Personal Startup Configuration

To avoid repeatedly loading devtools, add this to your `.Rprofile`:

```r
if (interactive()) {
  suppressMessages(require(devtools))
}
```

Use `require()` rather than `library()` here so that `.Rprofile` execution continues if devtools fails to load.

## Build Toolchain Requirements

To compile packages with C/C++ code:

**Windows:** Download Rtools from https://cran.r-project.org/bin/windows/Rtools/

**macOS:** Register as an Apple developer (free), then execute:
```bash
xcode-select --install
```

**Linux:** Install development tools via package manager:
- Ubuntu/Debian: `sudo apt install r-base-dev`
- Fedora/RedHat: `sudo dnf install R`

## Verification

```r
devtools::dev_sitrep()
```

This generates a development situation report showing R version, RStudio version, devtools status, and package dependencies.
