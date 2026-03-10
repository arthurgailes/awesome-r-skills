# Selectors and Advanced Formatting

## Selectors (Critical Concept)

Selectors target cells for formatting. Three types:

### Row Selector (`i`)

Formula referencing data columns:

```r
bold(ft, i = ~ cyl == 6)           # Rows where cyl == 6
color(ft, i = ~ mpg > 20 & hp < 150, color = "blue")
```

### Column Selector (`j`)

Formula with column names:

```r
bg(ft, j = ~ mpg + hp, bg = "lightgray")  # mpg and hp columns
bold(ft, j = c("mpg", "cyl"))              # Same with character vector
```

### Part Selector

Target header, body, footer, or all:

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

## Output-Specific Notes

### Word/PowerPoint
- Full feature support
- Use `paginate()` for page break control
- Use officer package for programmatic document building

### PDF
- Requires `latex_engine: xelatex` for custom fonts
- Padding ignored (use `ft.tabcolsep`, `ft.arraystretch`)
- Borders limited to solid lines
- No text rotation

### PowerPoint
- No images in cells (export table as image instead)
- Auto height not supported
