# R Package Structure and State

Source: https://r-pkgs.org/structure.html

## Five Package States

An R package exists in five distinct states during its lifecycle:

1. **Source** - A directory of files with specific structure including DESCRIPTION, R/, and other components
2. **Bundled** - A compressed `.tar.gz` file combining source files into a single transportable archive
3. **Binary** - Platform-specific compiled package (`.tgz` for macOS, `.zip` for Windows)
4. **Installed** - A binary package decompressed into a package library
5. **In-memory** - A package loaded via `library()` and available for immediate use

## Source Package Structure

A source package contains:
- `DESCRIPTION` file with metadata
- `R/` directory with `.R` files
- `man/` directory with documentation
- `data/` directory for datasets
- `vignettes/` for extended documentation
- `src/` for compiled code
- `inst/` for additional files
- `tests/` for testing code

## Key Files and Directories

**`.Rbuildignore`** controls which files from source get included in distributed forms. Each line is a Perl-compatible regular expression matched against the path to each file. Common entries exclude development files like RStudio project files, README.Rmd, and CI configurations.

**Binary packages** differ significantly from source:
- `.R` files are replaced with three parsed function files
- A `Meta/` directory contains cached metadata
- Help content moves to `help/` and `html/`
- Compiled code appears in `libs/`
- Data is converted to efficient formats
- `inst/` contents move to the top level

## Package Libraries

A library is a directory containing installed packages. The distinction matters: "we use the `library()` function to load a package," not to load a library. Multiple libraries can be active, typically including a user library and system-level library. Libraries are version-specific to R releases.
