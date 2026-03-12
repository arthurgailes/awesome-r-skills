# R Validators

Domain-specific validators for R package skill testing.

## Available Validators

| Validator | Use For | Returns |
|-----------|---------|---------|
| plot-validator.R | ggplot2, mapgl visualizations | {valid, layers, has_title} |
| spatial-validator.R | sf, spatial operations | {valid, crs, geometry_type} |
| html-validator.R | flextable, Shiny HTML | {valid, has_body, has_table} |
| numerical-validator.R | collapse, regressions | {valid, is_finite, range} |

## Usage

```bash
# Validate a plot
Rscript lib/r-validators/plot-validator.R path/to/code.R

# Returns JSON
# {"valid": true, "message": "Valid ggplot"}
```

## Called By

Grader agents call validators when checking domain-specific assertions.

See `agents/grader.md` for integration details.
