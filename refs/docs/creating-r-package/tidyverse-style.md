# Tidyverse Style Guide - Package Conventions

Source: https://style.tidyverse.org/

## File Naming (package-files.html)

1. **Single-function files**: Give the file the same name as the function
2. **Multiple-function files**: Give it a concise, but evocative name
3. **Deprecated functions**: Use `deprec-` prefix

### File Organization

- Public functions and their documentation appear first
- Private helper functions appear after all documented public functions
- When multiple public functions share documentation, they immediately follow the shared documentation block

## Documentation Style (documentation.html)

### Title and Description
- Single-line title using sentence case without terminal period
- Description follows on subsequent lines

### Parameter Documentation
- Complete sentences beginning with capitals and ending with periods
- Use `@inheritParams` to prevent duplication

### Code and Package Notation
- Use backticks for: function arguments (`na.rm`), values (`TRUE`, `NULL`), literal code (`mean(x)`), class names
- Function references may use backticks or cross-links

### Internal Functions
- Standard roxygen documentation with `@noRd` tag

## Test Conventions (tests.html)

- Test file organization should match `R/` files
- If function lives in `R/foofy.R`, tests live in `tests/testthat/test-foofy.R`
- Use `usethis::use_test()` to generate test files

## Error Messages (errors.html)

Use `cli::cli_abort()` for error messages.

### Structure
**Problem Statement**: Sentence-case, ending with period
- Use "must" when cause is clear: `'n' must be a numeric vector, not a character.`
- Use "can't" when expectations unclear: `Can't find column 'b' in '.data'.`

**Error Details**: Bulleted lists
- Cross bullets for problems
- Info bullets for context

### Guidelines
- Keep sentences under 80 characters
- Use backticks for argument names
- Show only first five issues
- Don't imply fault without evidence

## NEWS File (news.html)

### Format
```
* `ggsave()` now uses full argument names to avoid partial match warnings (@wch, #2355).
```

### Guidelines
- Write for users, not developers
- Add new bullets at top of file
- Include issue numbers and GitHub usernames for external contributors
- Use present tense, frame positively (what happens now)
- Function name as close to beginning as possible
- Wrap lines to 80 characters, end with period

### Organization for Releases
- Level 1 heading: package name and version
- Level 2 headings: Breaking changes, New features, Minor improvements
- Within sections, order alphabetically by first function mentioned
