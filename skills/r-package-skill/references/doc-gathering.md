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

**REQUIRED:** Always save complete function reference to `{base_path}/references/API.md`

**Format:** Replicate the CRAN reference manual - all functions with signatures, arguments, descriptions, examples.

**NOTE:** `{base_path}` is determined in STEP 0 of the workflow. See SKILL.md "Where to Install" section.

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

## Processing Flow

1. **Detect path** → Auto-detect `{base_path}` (see SKILL.md STEP 0)
2. **Gather docs** → Fetch from sources (CRAN, pkgdown, local R)
3. **Extract manual** → `{base_path}/references/API.md` (REQUIRED)
4. **Polish vignettes** → `{base_path}/references/vignette-name.md` (as needed)
5. **Write SKILL.md** → `{base_path}/SKILL.md` (<500 words)

**Temporary files during doc gathering:** Use appropriate temp directory if needed during doc gathering. Clean up after extraction.

**NOTE:** This is about temp files during skill CREATION. For temp files during skill USAGE (executing R code), see "R Execution Patterns" in SKILL.md.
