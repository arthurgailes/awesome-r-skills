# The DESCRIPTION File in R Packages

Source: https://r-pkgs.org/description.html

## Overview

The `DESCRIPTION` file is the defining characteristic of an R package. It uses Debian Control Format (DCF): each line contains field name and value separated by colon. Multi-line values require indentation with four spaces.

## Essential Fields

### Title and Description
- **Title**: Single-line summary in title case, under 65 characters, no period
- **Description**: Detailed paragraph (max 80 chars/line) explaining package functionality

### Authors@R
Uses `person()` function. Key roles:
- `cre`: Creator/current maintainer (requires email)
- `aut`: Authors who made significant contributions
- `ctb`: Contributors with smaller contributions
- `cph`: Copyright holders (often companies)
- `fnd`: Financial supporters

```r
Authors@R: person("First", "Last", email = "first@example.com",
  role = c("aut", "cre"))
```

### URL and BugReports
- **URL**: Links to package website and source repository (comma-separated)
- **BugReports**: Location for submitting bug reports

### License
Mandatory field specifying package license in machine-readable standard form.

## Dependency Fields

### Imports and Suggests
- **Imports**: Packages required at runtime; automatically installed
- **Suggests**: Packages for development or optional functionality

List packages alphabetically, one per line. Specify minimum versions: `package (>= version.number)`

### Depends and LinkingTo
- **Depends**: Mostly replaced by `Imports`; used for R version requirements: `Depends: R (>= 4.0.0)`
- **LinkingTo**: Required for packages using C/C++ code from other packages

## Additional Fields

- **Version**: Communicates lifecycle status and evolution
- **LazyData**: When `true`, datasets load automatically without `data()` calls
- **Encoding**: Character encoding (typically `UTF-8`)
- **VignetteBuilder**: Specifies vignette engines (typically `knitr`)
- **SystemRequirements**: External dependencies like C++17 or GNU make

## Custom Fields

Use `Config/` prefix for custom fields to avoid conflicts with official field names.
