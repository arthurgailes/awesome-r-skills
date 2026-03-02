# Writing Packages in RStudio IDE

Source: https://docs.posit.co/ide/user/ide/guide/pkg-devel/writing-packages.html

## Package Creation Methods

1. Call `usethis::create_package()` directly in R
2. Navigate to File > New Project > New Directory > R Package in RStudio

## Prerequisites

- **Development tools**: GNU software tools including C/C++ compiler
- **LaTeX**: For building manuals and vignettes

Install supporting R packages:
```r
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
```

## Working with Existing Packages

To enable RStudio's tools for existing packages:
1. Create an RStudio Project linked to the package directory
2. Ensure the `DESCRIPTION` file is in the root or `pkg/` subdirectory
3. Or configure through Tools > Project Options > Build Tools

## Building Packages

### Clean and Install Workflow

1. Unloads existing package versions and shared libraries
2. Builds and installs using `R CMD INSTALL`
3. Restarts the R session for clean environment
4. Reloads the package via `library()`

### Build Pane Features

- **Test**: Run package tests
- **Check**: Execute `R CMD Check` for code/documentation validation
- **Load All**: Runs `devtools::load_all()`
- **Build Source/Binary Package**: Create distributable formats
- **Configure Build Tools**: Access project build settings
