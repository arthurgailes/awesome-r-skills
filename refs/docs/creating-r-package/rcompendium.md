# R Package Development with rcompendium

Source: https://cran.r-project.org/web/packages/rcompendium/vignettes/developing_a_package.html

## Initial Setup

Create a new empty RStudio project, then execute `rcompendium::new_package()` to generate the package structure automatically.

## Package Structure Generated

- **R/**: Contains function definitions (e.g., `fun-demo.R`)
- **man/**: Auto-generated documentation files
- **tests/**: Unit tests using testthat framework
- **vignettes/**: Tutorial documentation
- **DESCRIPTION**: Project metadata requiring user updates
- **.github/workflows/**: Automated GitHub Actions for testing and deployment
- **README.Rmd**: GitHub repository homepage (edit this, not the `.md` version)
- **inst/**: Houses citation information and package stickers

## Key Metadata Files

### DESCRIPTION File
Stores essential package information including title, version, authors, and dependencies. Users must customize Title and Description fields. Default license is `"GPL (>= 2)"`.

### README Configuration
Modify `README.Rmd` rather than the generated markdown file.

## Recommended Development Workflow

1. Write new functions in the `R/` directory
2. Add roxygen documentation comments
3. Run `devtools::document()` to update help files
4. Execute `rcompendium::add_dependencies()` to manage requirements
5. Create unit tests with testthat
6. Write vignette documentation
7. Validate with `devtools::check()`
