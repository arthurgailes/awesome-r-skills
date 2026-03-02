# Fundamental Development Workflows for R Packages

Source: https://r-pkgs.org/workflow101.html

## 1. Creating a Package

### Naming Your Package
Package names must follow these formal rules:
- Contain only letters, numbers, and periods
- Start with a letter
- Not end with a period
- Cannot include hyphens or underscores

**Naming best practices:**
- Choose a unique, Google-friendly name to aid discoverability
- Verify the name isn't already used on CRAN, Bioconductor, or GitHub
- Use all lowercase to improve memorability
- Select pronounceable names that are easy to discuss
- Consider names that evoke the problem domain (lubridate for dates, rvest for web harvesting)
- Use `available::available()` function to evaluate candidate names

### Package Creation
Use `usethis::create_package()` or RStudio menu (File > New Project > New Directory > R Package).

**Avoid** `package.skeleton()`, which creates packages incompatible with modern workflows.

### Where to Create Your Package
Store source packages separately from installed packages. Keep clear separation between source (development) and installed (runtime) locations.

## 2. RStudio Projects

### Benefits
- Easy launching with proper working directory and file browser setup
- Project isolation - code in Project A doesn't affect Project B
- Navigation tools (F2 for function definitions, Ctrl+. for lookups)
- Keyboard shortcuts and clickable interfaces for common tasks

## 3. Working Directory and Filepath Discipline

**Recommendation:** Keep your package's top-level directory as your R session's working directory throughout development.

**Use path helpers:**
- `testthat::test_path()` for test file locations
- `fs::path_package()` for package-relative paths
- `rprojroot` package for resilient path construction

## 4. Test Drive with `load_all()`

`load_all()` simulates the installation process, making functions and data available for testing without formal installation.

### Benefits
- **Speed:** Iterate quickly without the overhead of full installation
- **Realistic namespace:** Develops under actual namespace conditions
- **Internal function access:** Call private functions directly
- **Dependency handling:** Use imported functions without attaching packages

### Development Cycle
1. Modify a function definition
2. Run `load_all()`
3. Test with examples or test code
4. Repeat

## 5. Checking Your Package

Run `devtools::check()` frequently. It executes `R CMD check` and reports:

**ERRORS:** Critical problems requiring fixes
**WARNINGS:** Issues that must be addressed for CRAN
**NOTES:** Minor observations; strive to eliminate all

### Best Practice
Run `check()` frequently - ideally multiple times daily during active development.
