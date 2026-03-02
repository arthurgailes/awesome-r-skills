---
name: r-flextable
description: Use when creating publication-quality tables for Word, PowerPoint, HTML, or PDF output in R, or when needing conditional cell formatting, merged cells, mini charts in tables, or cross-references
---

# R flextable

## Overview

**flextable creates publication-quality tables that render consistently across Word, PowerPoint, HTML, and PDF.**

Core principle: Separate data from display. Build from a data.frame, then layer formatting declaratively using selectors.

## When to Use

**Use flextable when:**
- Output to Word/PowerPoint is required (officer integration)
- Need cell merging, conditional formatting, or mini charts
- Cross-references and auto-numbered captions matter
- Same table must render across multiple formats

**Consider alternatives when:**
- HTML-only output: gt or reactable may be simpler
- LaTeX-heavy workflow: kableExtra has deeper LaTeX support
- Interactive dashboards: DT for full interactivity

## Quick Reference

| Task | Function |
|------|----------|
| Create table | `flextable(df)` |
| Format numbers | `colformat_double()`, `colformat_int()` |
| Bold/italic/color | `bold()`, `italic()`, `color()` |
| Background color | `bg()` |
| Cell padding | `padding()` |
| Merge cells | `merge_v()`, `merge_h()`, `merge_at()` |
| Add header row | `add_header_row()` |
| Add footer | `add_footer_lines()` |
| Auto-size | `autofit()` |
| Apply theme | `theme_vanilla()`, `theme_zebra()` |
| Save to Word | `save_as_docx()` |
| Save to PowerPoint | `save_as_pptx()` |
| Save as image | `save_as_image()` |

## Core Pattern

```r
library(flextable)

# Basic workflow: create -> format -> output
ft <- flextable(head(mtcars, 5)) |>
  # Format numbers

colformat_double(digits = 1) |>
  # Conditional formatting with formula selectors
  color(i = ~ mpg > 20, j = "mpg", color = "darkgreen") |>
  bold(i = ~ mpg > 20, j = "mpg") |>
  # Add spanning header
  add_header_row(
    values = c("Performance", "Engine", "Transmission"),
    colwidths = c(2, 4, 5)
  ) |>
  # Apply theme and auto-size
  theme_vanilla() |>
  autofit()

# Output
save_as_docx(ft, path = "table.docx")
```

## Selectors (Critical Concept)

Selectors target cells for formatting. Two types:

**Row selector (`i`):** Formula referencing data columns
```r
bold(ft, i = ~ cyl == 6)           # Rows where cyl == 6
color(ft, i = ~ mpg > 20 & hp < 150, color = "blue")
```

**Column selector (`j`):** Formula with column names
```r
bg(ft, j = ~ mpg + hp, bg = "lightgray")  # mpg and hp columns
bold(ft, j = c("mpg", "cyl"))              # Same with character vector
```

**Part selector:** header, body, footer, or all
```r
bold(ft, part = "header")  # Bold entire header
bg(ft, i = 1, part = "footer", bg = "yellow")
```

## Multi-Content Cells

For rich cell content (formatted text, images, charts), use `mk_par()` with `as_paragraph()`:

```r
ft |>
  mk_par(
    j = "name",
    value = as_paragraph(
      as_b(name),              # Bold
      " (",
      as_i(species),           # Italic
      ")"
    )
  )
```

## Mini Charts

Embed visualizations directly in cells:

```r
# Prepare data with list column of ggplot objects
dat$sparkline <- lapply(dat$values, function(x) {
  ggplot(data.frame(y = x), aes(x = seq_along(y), y = y)) +
    geom_line() + theme_void()
})

ft |>
  mk_par(j = "sparkline", value = as_paragraph(
    gg_chunk(sparkline, width = 1, height = 0.3)
  ))
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Theme doesn't format new header | Apply theme AFTER `add_header_row()` |
| `autofit()` overflows margins | Use `set_table_properties(layout = "autofit")` instead |
| `height()` has no effect | Set `hrule(rule = "exact")` first |
| Formula selectors fail in header | Use integer indices for header rows |
| Images missing in Word | Use `officedown::rdocx_document()` |
| PDF ignores padding | Use `ft.tabcolsep` chunk option |
| `add_header_row` values wrong | One value per span, not per column; colwidths must sum to ncol |

## Output-Specific Notes

**Word/PowerPoint:**
- Full feature support
- Use `paginate()` for page break control
- Use officer package for programmatic document building

**PDF:**
- Requires `latex_engine: xelatex` for custom fonts
- Padding ignored (use `ft.tabcolsep`, `ft.arraystretch`)
- Borders limited to solid lines
- No text rotation

**PowerPoint:**
- No images in cells (export table as image instead)
- Auto height not supported

## Detailed References

For comprehensive coverage, see reference files:
- `references/formatting.md` - All formatting functions and options
- `references/layout.md` - Merging, sizing, headers/footers
- `references/output.md` - Rendering to all formats
- `references/crosstabs.md` - Tabulator and cross-tabulation
- `references/advanced.md` - Programming patterns, mini charts
