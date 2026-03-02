# flextable Formatting Reference

## Table Parts

A flextable has three parts:
- **header**: Column names by default, expandable with `add_header_row()`
- **body**: Data from the data.frame
- **footer**: Empty by default, add with `add_footer_lines()`

Use `part = "header"`, `part = "body"`, `part = "footer"`, or `part = "all"` in formatting functions.

## Text Formatting Functions

All accept `i` (row), `j` (column), and `part` selectors.

### bold()
```r
bold(ft, i = 1, j = "col1", part = "body")
bold(ft, i = ~ value > 10)  # Formula selector
bold(ft, bold = FALSE)       # Remove bold
```

### italic()
```r
italic(ft, j = ~ col1 + col2)
italic(ft, part = "header")
```

### color()
```r
color(ft, color = "red")
color(ft, i = ~ value < 0, color = "red")
color(ft, color = scales::col_numeric("Blues", domain = c(0, 100)))  # Gradient
```

### fontsize()
```r
fontsize(ft, size = 12)
fontsize(ft, part = "header", size = 14)
```

### font()
```r
font(ft, fontname = "Arial")
font(ft, part = "header", fontname = "Arial Black")
```

### highlight()
```r
highlight(ft, color = "yellow")
highlight(ft, i = ~ important == TRUE, color = "#FFFF00")
```

## Cell Formatting Functions

### bg() - Background Color
```r
bg(ft, bg = "#F0F0F0")
bg(ft, i = ~ row_num %% 2 == 0, bg = "lightgray")  # Alternating rows
bg(ft, bg = scales::col_numeric("Reds", domain = NULL))  # Heatmap
```

### padding()
```r
padding(ft, padding = 6)  # All sides
padding(ft, padding.top = 2, padding.bottom = 2)
padding(ft, padding.left = 10, padding.right = 10)
```

**Note:** Padding is ignored in PDF output. Use chunk options `ft.tabcolsep` and `ft.arraystretch` instead.

### align()
Horizontal alignment: "left", "center", "right", "justify"
```r
align(ft, align = "center")
align(ft, j = ~ numeric_cols, align = "right")
align(ft, part = "header", align = "center")
```

### valign()
Vertical alignment: "top", "center", "bottom"
```r
valign(ft, valign = "center")
valign(ft, part = "body", valign = "top")
```

### rotate()
Rotate text (degrees: 0, 90, 180, 270)
```r
rotate(ft, j = 1, rotation = "tbrl", part = "header")  # Top-to-bottom
rotate(ft, j = 1, rotation = "btlr", part = "header")  # Bottom-to-top
```

**Note:** For Word/PowerPoint, also set `hrule(rule = "exact")`.

### line_spacing()
```r
line_spacing(ft, space = 1.5)
line_spacing(ft, part = "body", space = 1.2)
```

## Number Formatting Functions

### colformat_double()
```r
colformat_double(ft, digits = 2)
colformat_double(ft, j = "price", digits = 2, prefix = "$")
colformat_double(ft, big.mark = ",", decimal.mark = ".")
colformat_double(ft, na_str = "N/A")
colformat_double(ft, suffix = "%")
```

### colformat_int()
```r
colformat_int(ft, big.mark = ",")
colformat_int(ft, j = c("count", "total"))
```

### colformat_num()
Uses R console formatting (no scientific notation by default):
```r
colformat_num(ft, big.mark = " ", decimal.mark = ",")
```

### colformat_char()
```r
colformat_char(ft, j = "category", prefix = "Category: ")
colformat_char(ft, na_str = "-")
```

### colformat_date() / colformat_datetime()
```r
colformat_date(ft, fmt_date = "%Y-%m-%d")
colformat_date(ft, fmt_date = "%B %d, %Y")  # "January 15, 2024"
colformat_datetime(ft, fmt_datetime = "%Y-%m-%d %H:%M")
```

### colformat_lgl()
```r
colformat_lgl(ft, true = "Yes", false = "No", na_str = "Unknown")
```

### colformat_image()
Convert file paths to rendered images:
```r
colformat_image(ft, j = "image_path", width = 0.5, height = 0.5)
```

## Borders

### Border Objects
```r
library(officer)
std <- fp_border(color = "black", width = 1)
thick <- fp_border(color = "black", width = 2)
none <- fp_border(width = 0)
```

### Outer Borders
```r
border_outer(ft, border = thick)
hline_top(ft, border = thick)
hline_bottom(ft, border = thick)
vline_left(ft, border = std)
vline_right(ft, border = std)
```

### Inner Borders
```r
border_inner_h(ft, border = std)   # Horizontal inner
border_inner_v(ft, border = std)   # Vertical inner
border_inner(ft, border = std)     # Both
```

### Selective Borders
```r
hline(ft, i = 3, border = thick)   # Line below row 3
vline(ft, j = 2, border = thick)   # Line after column 2
hline(ft, i = ~ group != lag(group), border = thick)  # Between groups
```

### Surround Specific Cells
```r
surround(ft, i = 1:3, j = 2:4, border = thick)
surround(ft, i = ~ highlight == TRUE, border.top = thick, border.bottom = thick)
```

### Remove Borders
```r
border_remove(ft)
```

### Fix Merged Cell Borders
After merging cells, borders may render incorrectly:
```r
ft |> merge_v() |> fix_border_issues()
```

## Theme Functions

Apply coordinated formatting. **Apply AFTER adding header/footer rows.**

### theme_booktabs() (default)
Clean academic style with top/bottom rules.

### theme_vanilla()
Booktabs with row separators.

### theme_zebra()
```r
theme_zebra(ft, odd_header = "lightblue", odd_body = "lightgray")
```

### theme_box()
Full grid borders (useful for debugging).

### theme_alafoli()
Light gray minimalist.

### theme_vader() / theme_tron() / theme_tron_legacy()
Dark themes.

### theme_apa()
APA style formatting.

### Custom Theme
```r
my_theme <- function(ft) {
  ft |>
    fontsize(size = 10) |>
    font(fontname = "Arial") |>
    padding(padding = 4) |>
    border_outer(border = fp_border(width = 2)) |>
    hline_top(part = "header", border = fp_border(width = 2)) |>
    hline_bottom(part = "header", border = fp_border(width = 1)) |>
    hline_bottom(part = "body", border = fp_border(width = 2))
}

ft |> my_theme()

# Set as default for all tables:
set_flextable_defaults(theme_fun = my_theme)
```

## Default Settings

### Set Defaults
```r
set_flextable_defaults(
  font.size = 10,
  font.family = "Arial",
  font.color = "black",
  padding = 4,
  border.color = "gray",
  theme_fun = theme_vanilla,
  digits = 2,
  decimal.mark = ".",
  big.mark = ",",
  na_str = ""
)
```

### Reset Defaults
```r
init_flextable_defaults()
```

### View Current Defaults
```r
get_flextable_defaults()
```

## The style() Function

Apply multiple properties at once using officer objects:

```r
library(officer)

ft |> style(
  i = ~ value > 100,
  j = "value",
  pr_t = fp_text_default(bold = TRUE, color = "red"),
  pr_p = fp_par(text.align = "right"),
  pr_c = fp_cell(background.color = "#FFFFCC")
)
```

Property objects:
- `fp_text_default()`: bold, italic, color, font.size, font.family, shading.color
- `fp_par()`: text.align, padding, line_spacing
- `fp_cell()`: background.color, vertical.align, margin
- `fp_border()`: color, width, style ("solid", "dashed", "dotted")

## Selectors Deep Dive

### Row Selectors (i)

```r
# Integer index
bold(ft, i = 1)              # First row
bold(ft, i = c(1, 3, 5))     # Rows 1, 3, 5
bold(ft, i = 2:5)            # Rows 2 through 5

# Formula (evaluates against body data)
bold(ft, i = ~ mpg > 20)
bold(ft, i = ~ cyl == 6 & gear == 4)
bold(ft, i = ~ grepl("Toyota", car_name))

# NULL = all rows
bold(ft)                      # All rows

# Negative = exclude
bold(ft, i = -1)              # All except first row
```

### Column Selectors (j)

```r
# Character vector
bg(ft, j = c("mpg", "cyl"), bg = "yellow")

# Integer index
bg(ft, j = 1:3, bg = "yellow")

# Formula
bg(ft, j = ~ mpg + cyl + disp, bg = "yellow")
bg(ft, j = ~ . - carb, bg = "yellow")  # All except carb

# NULL = all columns
bg(ft, bg = "yellow")         # All columns
```

### Part + Selectors

```r
# Header formatting (formulas don't work)
bold(ft, i = 1, part = "header")      # First header row
bg(ft, part = "header", bg = "navy")

# Footer formatting
color(ft, part = "footer", color = "gray")

# All parts (header + body)
align(ft, part = "all", align = "center")
```

### before() Function

Select rows preceding a condition:
```r
# Add line before "Total" row
hline(ft, i = ~ before(label, "Total"), border = fp_border(width = 2))
```
