# flextable Output Reference

## Quick Export Functions

### save_as_docx()
```r
save_as_docx(ft, path = "table.docx")

# Multiple tables
save_as_docx(
  "First Table" = ft1,
  "Second Table" = ft2,
  path = "tables.docx"
)
```

### save_as_pptx()
```r
save_as_pptx(ft, path = "table.pptx")

# Multiple tables (each on separate slide)
save_as_pptx(
  "Slide 1" = ft1,
  "Slide 2" = ft2,
  path = "presentation.pptx"
)
```

### save_as_html()
```r
save_as_html(ft, path = "table.html")
```

### save_as_rtf()
```r
save_as_rtf(ft, path = "table.rtf")
```

### save_as_image()
```r
save_as_image(ft, path = "table.png")
save_as_image(ft, path = "table.svg")
save_as_image(ft, path = "table.pdf")

# With specific resolution
save_as_image(ft, path = "table.png", webshot = "webshot2", res = 300)
```

**Requirements:** webshot2 package and Chrome browser.

## RStudio Preview

```r
# Default (Viewer pane)
ft

# Preview in specific format
print(ft, preview = "docx")
print(ft, preview = "pptx")
print(ft, preview = "pdf")
print(ft, preview = "rtf")
```

## R Markdown Integration

### Basic Usage
Tables render automatically in R Markdown. No special setup required for text-only tables.

### YAML Header Requirements

**For custom fonts in PDF:**
```yaml
output:
  pdf_document:
    latex_engine: xelatex
```

**For images/hyperlinks in Word:**
```yaml
output:
  officedown::rdocx_document: default
```

### Knitr Chunk Options

**Caption options:**
| Option | Description | Default |
|--------|-------------|---------|
| `tab.id` | Bookmark/reference ID | NULL |
| `tab.cap` | Caption text | NULL |
| `tab.topcaption` | Caption above table | TRUE |
| `tab.lp` | Label prefix | "tab:" |

**Word caption options:**
| Option | Description | Default |
|--------|-------------|---------|
| `tab.cap.style` | Word style name | NULL |
| `tab.cap.pre` | Numbering prefix | "Table" |
| `tab.cap.sep` | Numbering separator | ":" |
| `tab.cap.fp_text` | `fp_text_lite()` for suffix | NULL |

**Word table options:**
| Option | Description | Default |
|--------|-------------|---------|
| `tab.layout` | "autofit" or "fixed" | "autofit" |
| `tab.width` | Table width (0-1) | 1 |

**PDF-specific options:**
| Option | Description | Default |
|--------|-------------|---------|
| `ft.tabcolsep` | Column separation | 4 (pt) |
| `ft.arraystretch` | Row stretch factor | 1.5 |
| `ft.latex.float` | Float position | "none" |

### Example Chunk
````markdown
```{r}
#| label: tbl-summary
#| tab.cap: Summary Statistics
#| tab.id: summary-stats
#| tab.layout: autofit

flextable(summary_data) |>
  theme_vanilla() |>
  autofit()
```
````

### Looping Over Tables

Use `knitr::knit_child()` with `results='asis'`:

```r
#| results: asis

for (grp in unique(data$group)) {
  cat(knitr::knit_child(
    text = c(
      "## {{grp}}",
      "",
      "```{r}",
      "#| echo: false",
      "data |> filter(group == '{{grp}}') |> flextable()",
      "```"
    ),
    envir = environment(),
    quiet = TRUE
  ))
}
```

Or with purrr:
```r
#| results: asis

purrr::walk(unique(data$group), function(grp) {
  cat("\n\n## ", grp, "\n\n")
  ft <- data |> filter(group == grp) |> flextable()
  flextable_to_rmd(ft)
})
```

## Quarto Integration

### Basic Usage
flextable works automatically in Quarto for HTML, PDF, and Word.

### flextable-qmd Extension

For advanced features (cross-references, markdown in cells):

**Install:**
```r
flextable::use_flextable_qmd()
```

**YAML:**
```yaml
filters:
  - flextable-qmd
```

**Usage:**
```r
ft |> mk_par(
  j = "notes",
  value = as_paragraph(as_qmd("**Bold** and *italic*"))
)
```

### Word docx-filter

Remove wrapper tables Quarto adds:
```yaml
format:
  docx:
    filters:
      - docx-filter
```

### Cross-References in Quarto

```r
#| label: tbl-cars
#| tbl-cap: Motor Trend Car Data

flextable(head(mtcars))
```

Reference with `@tbl-cars`.

## Officer Package Integration

### Word Documents

```r
library(officer)

doc <- read_docx() |>
  body_add_par("Introduction", style = "heading 1") |>
  body_add_par("Here is the data:") |>
  body_add_flextable(ft) |>
  body_add_par("") |>  # Empty paragraph for spacing
  body_add_par("Conclusion", style = "heading 1")

print(doc, target = "report.docx")
```

**With template:**
```r
doc <- read_docx("template.docx") |>
  body_add_flextable(ft)
```

**At bookmark:**
```r
doc <- read_docx("template.docx") |>
  cursor_bookmark("table_location") |>
  body_add_flextable(ft)
```

### PowerPoint Presentations

```r
library(officer)

ppt <- read_pptx() |>
  add_slide(layout = "Title and Content") |>
  ph_with(ft, location = ph_location_type("body"))

print(ppt, target = "presentation.pptx")
```

**Centered positioning:**
```r
# Get dimensions
ft_dim <- flextable_dim(ft)
slide_dim <- slide_size(ppt)

# Calculate center position
left <- (slide_dim$width - ft_dim$widths) / 2
top <- (slide_dim$height - ft_dim$heights) / 2

ppt |>
  add_slide() |>
  ph_with(ft, location = ph_location(left = left, top = top))
```

**Multiple tables on one slide:**
```r
ppt |>
  add_slide(layout = "Two Content") |>
  ph_with(ft1, location = ph_location_left()) |>
  ph_with(ft2, location = ph_location_right())
```

### RTF Documents

```r
library(officer)

rtf <- rtf_doc() |>
  rtf_add(ft)

print(rtf, target = "document.rtf")
```

## Shiny Applications

```r
library(shiny)
library(flextable)

ui <- fluidPage(
  titlePanel("Interactive Table"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Rows:", min = 1, max = 32, value = 10)
    ),
    mainPanel(
      uiOutput("table_output")
    )
  )
)

server <- function(input, output) {
  output$table_output <- renderUI({
    ft <- mtcars |>
      head(input$n) |>
      flextable() |>
      theme_vanilla() |>
      autofit()

    htmltools_value(ft)
  })
}

shinyApp(ui, server)
```

**Key function:** `htmltools_value()` converts flextable to HTML for Shiny.

## Automatic Data Frame Printing

Convert all data.frames to flextables automatically:

```r
# In setup chunk
use_df_printer()
```

**Options (set via `knitr::opts_chunk$set()`):**
| Option | Description | Default |
|--------|-------------|---------|
| `ft_max_row` | Max rows to display | 10 |
| `ft_split_colnames` | Split column names | FALSE |
| `ft_short_strings` | Shorten text | FALSE |
| `ft_short_size` | Max string length | 35 |
| `ft_show_coltype` | Show column types | TRUE |
| `ft_color_coltype` | Type label color | "#999999" |

## Output Format Limitations

### PDF Limitations
- Padding ignored (use `ft.tabcolsep`, `ft.arraystretch`)
- Borders: solid lines only (no dashed/dotted)
- Row height cannot be controlled
- No text rotation
- Rows cannot split across pages
- Requires `xelatex` for custom fonts

### PowerPoint Limitations
- No images in cells (workaround: save table as image)
- No automatic height calculation
- No padding support

### HTML Limitations
- Tab stops (`\t`) render as single space
- Some border styles may vary by browser

### Word Limitations
- Images/hyperlinks require `officedown::rdocx_document()`
- Standard `rmarkdown::word_document()` for text-only tables

## GitHub Markdown

flextable supports `github_document` output (v0.9.3+). Tables render as embedded images.

```yaml
output:
  github_document: default
```

## Landscape Pages (Word)

### With officer
```r
library(officer)

landscape_section <- block_section(
  prop_section(
    page_size = page_size(orient = "landscape"),
    page_margins = page_mar(),
    type = "nextPage"
  )
)

doc <- read_docx() |>
  body_add_par("Portrait content") |>
  body_add_break(pos = "after") |>
  body_end_block_section(landscape_section) |>
  body_add_flextable(wide_table) |>
  body_end_block_section(block_section(prop_section()))  # Back to portrait

print(doc, target = "report.docx")
```

### With Quarto
```markdown
::: {.landscape}
```{r}
wide_table
```
:::
```

## Patchwork Integration

Combine flextables with ggplot2 using patchwork:

```r
library(patchwork)

p <- ggplot(mtcars, aes(mpg, hp)) + geom_point()
ft <- flextable(head(mtcars[, 1:4]))

wrap_flextable(ft) | p
wrap_flextable(ft) / p

# Align rows with plot
wrap_flextable(ft, flex_body = TRUE, just = "right") + p
```

See `references/advanced.md` for full patchwork details.
