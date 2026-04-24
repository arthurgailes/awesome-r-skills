# Fundamentals of map design with mapgl

Source: <https://walker-data.com/mapgl/articles/map-design.html>

mapgl exposes the full map-design capabilities of Mapbox GL JS and MapLibre GL JS. Map-making can take a little more code than packages like tmap, in exchange for complete control over styling.

## Setup

```r
library(tidycensus)
library(mapgl)

fl_age <- get_acs(
  geography = "tract",
  variables = "B01002_001",
  state = "FL",
  year = 2023,
  geometry = TRUE
)

fl_map <- mapboxgl(mapbox_style("light"), bounds = fl_age)
fl_map
```

## Continuous styling

Styling in Mapbox GL JS / MapLibre uses **expressions**. mapgl provides R helpers that compose these expressions idiomatically.

**Automatic continuous scale** -- `interpolate_palette()` picks break points and builds a smooth scale. Classification methods: `"equal"`, `"quantile"`, `"jenks"`. Pair with `get_legend_labels()` / `get_legend_colors()`.

```r
continuous_scale <- interpolate_palette(
  data = fl_age,
  column = "estimate",
  method = "equal",
  n = 5,
  palette = viridisLite::plasma
)

fl_map |>
  add_fill_layer(
    id = "fl_tracts",
    source = fl_age,
    fill_color = continuous_scale$expression,
    fill_opacity = 0.5
  ) |>
  add_legend(
    "Median age in Florida",
    values = get_legend_labels(continuous_scale, digits = 0),
    colors = get_legend_colors(continuous_scale),
    type = "continuous"
  )
```

**Manual continuous scale** -- `interpolate()` gives direct control over `values` and `stops`:

```r
fl_map |>
  add_fill_layer(
    id = "fl_tracts",
    source = fl_age,
    fill_color = interpolate(
      column = "estimate",
      values = c(20, 80),
      stops = c("lightblue", "darkblue"),
      na_color = "lightgrey"
    ),
    fill_opacity = 0.5
  ) |>
  add_legend(
    "Median age in Florida",
    values = c(20, 80),
    colors = c("lightblue", "darkblue")
  )
```

## Categorical / classed styling

**Automatic classification** -- `step_equal_interval()`, `step_quantile()`, `step_jenks()` compute breaks and build step expressions. Pass `n` and `colors`/`palette`. Pair with `get_legend_labels()` / `get_legend_colors()`.

```r
q_class <- step_quantile(
  data = fl_age,
  column = "estimate",
  n = 5,
  colors = RColorBrewer::brewer.pal(5, "PRGn")
)

fl_map |>
  add_fill_layer(
    id = "fl_tracts",
    source = fl_age,
    fill_color = q_class$expression,
    fill_opacity = 0.5
  ) |>
  add_legend(
    "Median age in Florida",
    values = get_legend_labels(q_class, digits = 0, suffix = " years"),
    colors = get_legend_colors(q_class),
    type = "categorical"
  )
```

**Manual step expression** -- `step_expr()` requires a `base` (before first threshold) then matched `values` and `stops`:

```r
brewer_pal <- RColorBrewer::brewer.pal(5, "RdYlBu")

fl_map |>
  add_fill_layer(
    id = "fl_tracts",
    source = fl_age,
    fill_color = step_expr(
      column = "estimate",
      base = brewer_pal[1],
      stops = brewer_pal[2:5],
      values = seq(25, 70, 15),
      na_color = "white"
    ),
    fill_opacity = 0.5
  ) |>
  add_legend(
    "Median age in Florida",
    values = c("Under 25", "25-40", "40-55", "55-70", "Above 70"),
    colors = brewer_pal,
    type = "categorical"
  )
```

**Categorical by value** (not numeric thresholds) -- `match_expr()`:

```r
add_fill_layer(
  id = "zoning", source = zones,
  fill_color = match_expr(
    column = "zone_type",
    values = c("residential", "commercial", "industrial"),
    stops  = c("#1f78b4", "#33a02c", "#e31a1c"),
    default = "#cccccc"
  )
)
```

## Popups, tooltips, and hover highlighting

`popup` / `tooltip` take a column name whose value is rendered on click / hover. Both accept HTML, so the usual pattern is to build an HTML column up front. `hover_options` is a named list of layer paint/layout args to override while a feature is hovered.

```r
fl_age$popup <- glue::glue(
  "<strong>GEOID: </strong>{fl_age$GEOID}<br><strong>Median age: </strong>{fl_age$estimate}"
)

fl_map |>
  add_fill_layer(
    id = "fl_tracts",
    source = fl_age,
    fill_color = interpolate(
      column = "estimate",
      values = c(20, 80),
      stops = c("lightblue", "darkblue"),
      na_color = "lightgrey"
    ),
    fill_opacity = 0.5,
    popup = "popup",
    tooltip = "estimate",
    hover_options = list(
      fill_color = "yellow",
      fill_opacity = 1
    )
  ) |>
  add_legend(
    "Median age in Florida",
    values = c(20, 80),
    colors = c("lightblue", "darkblue")
  )
```

## Picking the right tool

| Need | Function |
|---|---|
| Smooth numeric gradient, manual stops | `interpolate()` |
| Smooth numeric gradient, automatic breaks | `interpolate_palette()` |
| Classed numeric choropleth, manual thresholds | `step_expr()` |
| Classed numeric choropleth, automatic breaks | `step_equal_interval()` / `step_quantile()` / `step_jenks()` |
| Category-to-color mapping | `match_expr()` |
| Data column inside a nested expression | `get_column("name")` |
| Legend labels/colors/breaks from an auto classification | `get_legend_labels()`, `get_legend_colors()`, `get_breaks()` |
