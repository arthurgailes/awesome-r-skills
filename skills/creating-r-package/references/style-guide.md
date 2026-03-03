# Tidyverse Style Guide for Packages

Source: https://style.tidyverse.org/

## Error Messages

Use `cli::cli_abort()` for errors:

```r
cli::cli_abort(c(

"Problem statement ending with period.",
"x" = "Cross bullet for specific problem.",
"i" = "Info bullet for context."
))
```

**Guidelines:**
- "must" when cause is clear: `'n' must be a numeric vector, not a character.`
- "can't" when expectations unclear: `Can't find column 'b' in '.data'.`
- Keep sentences under 80 characters
- Use backticks for argument names
- Show only first five issues

## NEWS File Format

```
# pkgname 1.0.0

## Breaking changes

* `old_function()` has been removed. Use `new_function()` instead.
## New features

* `ggsave()` now uses full argument names to avoid partial match warnings (@wch, #2355).

## Minor improvements

* `geom_point()` gains a `stroke` argument (#1234).
```

**Guidelines:**
- Write for users, not developers
- Add new bullets at top of file
- Include issue numbers and GitHub usernames for external contributors
- Present tense, frame positively (what happens now)
- Function name as close to beginning as possible
- Wrap to 80 characters, end with period

## File Organization

- Public functions and docs appear first
- Private helpers appear after all public functions
- Single-function files: name file same as function
- Use `deprec-` prefix for deprecated functions

## Documentation Style

- Title: sentence case, no terminal period
- Parameters: complete sentences with capitals and periods
- Use `@inheritParams` to prevent duplication
- Internal functions: standard roxygen with `@noRd`
