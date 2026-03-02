# Function Documentation with roxygen2

Source: https://r-pkgs.org/man.html

## Core Workflow

1. Add roxygen comments starting with `#'` above functions
2. Run `devtools::document()` to generate `.Rd` files
3. Preview documentation with `?function`
4. Iterate until satisfied

## Essential Tags

**Title & Description**
- Title: sentence case, no period, followed by blank line
- Description: one paragraph summarizing key features
- Details: optional additional information

**Arguments**
- `@param name description`: Documents function parameters
- `@param x,y description`: Multiple related parameters documented together
- `@inheritParams function`: Reuses parameter docs from another function

**Return Value**
- `@returns`: Describes the output's structure, type, and dimensions

**Examples**
- `@examples`: Executable R code demonstrating function usage
- `@examplesIf condition`: Runs examples conditionally

**Other Tags**
- `@export`: Marks function as exported
- `@seealso`: Cross-references related functions
- `@noRd`: Suppresses `.Rd` file generation for internal functions

## Markdown Features

1. **Backticks for inline code**: `` `function()` ``
2. **Square brackets for auto-linked functions**: `[otherfunction()]` or `[pkg::function()]`
3. **Lists**: Using `*` for bullet points

## Best Practices for Examples

Examples must:
- Run without errors
- Execute quickly (under 10 minutes total)
- Leave the system unchanged (reset options, delete temp files)
- Use only packages in `Imports` or `Suggests`

## Documentation Reuse

**Multiple functions in one topic**: Use `@rdname existing_function`

**Inheriting documentation**:
- `@inheritParams source_function`
- `@inherit source_function` (inherits all components)

## Package-Level Documentation

Create with `usethis::use_package_doc()`, which generates `R/{pkgname}-package.R`:

```r
#' @keywords internal
"_PACKAGE"
```

## CRAN Requirements

- All exported functions must have documentation
- All functions must have at least one example
- Examples cannot be entirely wrapped in `\dontrun{}`
- Return values should be documented
