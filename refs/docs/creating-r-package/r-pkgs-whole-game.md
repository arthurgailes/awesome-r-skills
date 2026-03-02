# The Whole Game: R Package Development Overview

Source: https://r-pkgs.org/whole-game.html

## Core Development Workflow

The chapter establishes a cyclical development pattern centered on four primary functions:

**Setup Functions (called once per package):**
- `create_package()` initializes the package directory structure
- `use_git()` enables version control
- `use_mit_license()` configures licensing
- `use_testthat()` establishes unit testing infrastructure
- `use_github()` connects to remote repositories
- `use_readme_rmd()` creates documentation

**Regular-use Functions (called frequently):**
- `use_r()` creates R script files for functions
- `use_test()` generates test files
- `use_package()` declares external dependencies

**Iterative Functions (used multiple times daily):**
- `load_all()` simulates package installation for testing
- `document()` generates help files from roxygen comments
- `test()` executes unit tests
- `check()` runs comprehensive package validation

## Package Architecture

A basic R package structure includes:

- **DESCRIPTION**: Metadata file containing package name, version, author, title, and dependencies
- **NAMESPACE**: Declares exported functions and imported dependencies
- **R/ directory**: Contains function definitions organized in .R files
- **.Rbuildignore**: Lists files to exclude from package distribution
- **.Rproj file**: RStudio project configuration
- **tests/testthat/**: Unit test files following naming convention test-*.R

## Key Principles

**Incremental Validation**: Running `check()` frequently catches problems early, preventing issues from compounding as the package grows.

**Package vs. Script Mindset**: Packages require different practices than R scripts—dependencies are declared formally, examples go in tests or documentation rather than loose scripts, and functions exist in their own namespace.

**Simulation Over Installation**: `load_all()` provides rapid feedback during development without the overhead of actual package building and installation cycles.

**Roxygen2 Advantages**: Maintaining documentation alongside function definitions reduces the likelihood of documentation becoming outdated relative to implementation.

## Workflow Diagram

The chapter presents package development as interconnected loops:
- Edit code -> load_all() -> test drive interactively
- Edit tests -> test() -> verify coverage
- Edit documentation -> document() -> preview
- All activities -> check() -> validate package integrity
- Final validation -> commit to Git -> push to GitHub

This loop structure encourages frequent validation and supports collaborative development through version control.
