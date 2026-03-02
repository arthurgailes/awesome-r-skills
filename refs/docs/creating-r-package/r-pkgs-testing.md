# Testing Basics with testthat

Source: https://r-pkgs.org/testing-basics.html

## Why Formal Testing Matters

1. **Fewer bugs** - Double-entry system for verification
2. **Better code structure** - Functions that are easy to test tend to be better designed
3. **Clear objectives** - Tests provide concrete goals when fixing bugs
4. **Confidence for changes** - Comprehensive test coverage allows refactoring without fear

## Setting Up testthat

```r
usethis::use_testthat(3)
```

This creates the `tests/testthat/` directory, adds testthat to `DESCRIPTION`, and generates the test runner file.

## Test Organization Structure

**Files** -> **Tests** -> **Expectations**

- **Files**: Located in `tests/testthat/`, named starting with `test-`. Match file organization to `R/` directory structure
- **Tests**: Created with `test_that(description, { ... })`
- **Expectations**: Individual assertions beginning with `expect_`

## Key Expectations

### Equality Testing
- `expect_equal()` - Checks equality with numeric tolerance
- `expect_identical()` - Tests exact equivalence

### Error Testing
- `expect_error()` - Verifies that code throws an error
- `expect_warning()` and `expect_message()` - Test conditions
- `expect_no_error()` - Confirms absence of errors

Best practice: Use the `class` argument to test for specific error types.

### Snapshot Testing

`expect_snapshot()` records expected results in `tests/testthat/_snaps/`. Alerts when outputs differ from baselines.

### Shortcut Expectations

- `expect_match(string, regexp)` - Pattern matching
- `expect_length(object, n)` - Length verification
- `expect_setequal(x, y)` - Unordered equality
- `expect_s3_class()` / `expect_s4_class()` - Class inheritance
- `expect_true()` / `expect_false()` - Boolean assertions

## Development Workflow

### Three Scales of Testing

**Micro-iteration**: Use `devtools::load_all()` and run individual expectations interactively.

**Mezzo-iteration**: Run single test files with `testthat::test_file()`.

**Macro-iteration**: Execute full test suite with `devtools::test()`.

## Practical Conventions

- Match test file names to source files: `R/foofy.R` pairs with `tests/testthat/test-foofy.R`
- Use `usethis::use_r()` and `usethis::use_test()` for file creation and navigation
- Prefer multiple smaller tests over fewer large tests
