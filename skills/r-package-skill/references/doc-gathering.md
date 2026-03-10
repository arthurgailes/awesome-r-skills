# Documentation Gathering Guide

Detailed guide for gathering R package documentation.

## Documentation Sources (Priority Order)

Try sources in this order (prefer local/authoritative over web):

### 1. Local R Session (Best)

Use local R installation if easily accessible, but move on immediately if something goes wrong.

If mcptools MCP is configured, use btw tools:

```r
btw_tool_docs_help_page(package_name, topic)     # Function help
btw_tool_docs_available_vignettes(package_name)  # List vignettes
btw_tool_docs_vignette(package_name, vignette)   # Read vignette
btw_tool_docs_package_news(package_name)         # Recent changes
```

### 2. CRAN

Package reference manual and vignettes at:

- `https://cran.r-project.org/web/packages/{pkg}/index.html`
- `https://cran.r-project.org/web/packages/{pkg}/{pkg}.pdf` (reference manual)

### 3. Package Website

Many packages have pkgdown sites:

- `https://{author}.github.io/{pkg}/`
- `https://{pkg}.r-lib.org/`
- Check CRAN page for URL field

### 4. Online Best Practices

Search for credible examples and patterns:

- GitHub repos using the package (filter by stars)
- R-bloggers, rOpenSci blog posts
- Stack Overflow highly-voted answers
- Package author's talks/tutorials
- R Journal articles

**Credibility signals:** author's own examples, rOpenSci review, Posit/tidyverse team usage, R Journal publication, high GitHub stars.

## Extracting Function Reference

**REQUIRED:** Always save complete function reference to `skills/r-{package}/references/API.md`

**NOTE:** If the context7 MCP server is available, use it to fetch function reference documentation directly. The context7 MCP provides comprehensive package documentation access.

```r
# Using btw tools (if mcptools MCP is configured)
help_topics <- btw_tool_docs_package_help_topics(package_name)
# Extract each function's help page
# Combine into references/API.md

# OR download CRAN manual PDF, convert to markdown
# https://cran.r-project.org/web/packages/{pkg}/{pkg}.pdf

# OR use context7 MCP (if available)
# Access through MCP server for comprehensive function reference
```

**This is NOT optional.** Every package skill must have `references/API.md`.

## Working Directory Structure

```
refs/docs/{package}/       # Gitignored working area
  vignettes/               # Extracted vignettes (working copies)
  examples/                # Credible code examples
  notes.md                 # Your synthesis
```

## Processing Flow

1. **Gather** → `refs/docs/{package}/` (gitignored working area)
2. **Extract manual** → `skills/r-{package}/references/API.md` (REQUIRED)
3. **Polish vignettes** → `skills/r-{package}/references/vignette-name.md` (as needed)
4. **Write SKILL.md** → `skills/r-{package}/SKILL.md` (<500 words)
