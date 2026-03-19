# Mapping with mapgl - Complete Vignette

## Overview

This guide demonstrates how to visualize and style freestiler tilesets using the mapgl package. The example builds a national choropleth map of median household income across 242,000 Census block groups rendered as vector tiles.

## Creating the Tileset

Start by retrieving block group geometries and income data using tidycensus:

```r
library(tidycensus)
library(freestiler)
options(tigris_use_cache = TRUE)

# Pulls data state-by-state, so will take a few minutes if
# geometries are not pre-cached
bgs <- get_acs(
  geography = "block group",
  variables = "B19013_001",  # median household income
  state = c(state.abb, "DC"),
  year = 2024,
  geometry = TRUE
)

freestile(
  bgs,
  "us_income.pmtiles",
  layer_name = "income",
  min_zoom = 4,
  max_zoom = 12
)
```

This process generates approximately 250 MB of tiled data and confirms completion with output confirming the file size and viewing command.

## Quick Preview

For rapid exploration, the `view_tiles()` function provides immediate visualization:

```r
view_tiles("us_income.pmtiles")
```

This function automatically detects layer names, geometry types, and map bounds from the PMTiles metadata, launches a local server, and displays an interactive map. It accommodates polygon, line, and point geometries without additional configuration.

## Custom Map Construction

To achieve greater control over styling, use `serve_tiles()` to initialize the server, then construct your map with mapgl:

```r
library(mapgl)

serve_tiles("us_income.pmtiles")
```

Build the styled map:

```r
maplibre(
  style = openfreemap_style("positron"),
  bounds = c(-125, 24, -66, 50),
) |>
  add_pmtiles_source(
    id = "income-src",
    url = "http://localhost:8080/us_income.pmtiles",
    promote_id = "GEOID"
  ) |>
  add_fill_layer(
    id = "income-fill",
    source = "income-src",
    source_layer = "income",
    fill_color = interpolate(
      column = "estimate",
      values = c(20000, 50000, 100000, 200000),
      stops = c("#d73027", "#fee08b", "#91cf60", "#1a9850"),
      na_color = "#cccccc"
    ),
    fill_opacity = 0.7,
    hover_options = list(
      fill_opacity = 1
    ),
    tooltip = concat(
      "Median income: $",
      number_format(get_column("estimate"), locale = "en")
    )
  )
```

### Key Components

**`add_pmtiles_source()`** — Registers the PMTiles file as a vector tile source. The `promote_id` parameter specifies which property serves as the feature identifier, enabling hover and click interactions.

**`source_layer`** — Must correspond to the `layer_name` parameter used during tileset creation.

**`interpolate()`** — Generates data-driven color ramps evaluated per-feature on the GPU, maintaining performance across large feature counts.

**`hover_options`** — Implements mouseover highlighting (requires `promote_id` configuration).

**`tooltip`** — Uses `concat()` and `number_format()` to construct formatted hover text from feature properties.

## Line and Point Layers

For line data, use `add_line_layer()`:

```r
maplibre() |>
  add_pmtiles_source(
    id = "roads-src",
    url = "http://localhost:8080/roads.pmtiles"
  ) |>
  add_line_layer(
    id = "roads",
    source = "roads-src",
    source_layer = "roads",
    line_color = "#4a90d9",
    line_width = 1.5
  )
```

For point data, use `add_circle_layer()`:

```r
maplibre() |>
  add_pmtiles_source(
    id = "pts-src",
    url = "http://localhost:8080/airports.pmtiles"
  ) |>
  add_circle_layer(
    id = "airports",
    source = "pts-src",
    source_layer = "airports",
    circle_color = "orange",
    circle_radius = 5,
    circle_stroke_color = "white",
    circle_stroke_width = 1
  )
```

## Multi-Layer Tilesets

When tilesets contain multiple layers (defined as a named list in `freestile()`), add each layer independently while referencing the same source:

```r
maplibre() |>
  add_pmtiles_source(
    id = "nc-src",
    url = "http://localhost:8080/nc_layers.pmtiles"
  ) |>
  add_fill_layer(
    id = "counties",
    source = "nc-src",
    source_layer = "counties",
    fill_color = "navy",
    fill_opacity = 0.3
  ) |>
  add_circle_layer(
    id = "centroids",
    source = "nc-src",
    source_layer = "centroids",
    circle_color = "red",
    circle_radius = 4
  )
```

## Tile Format Options

By default, freestiler uses MapLibre Tiles (MLT) for reduced file sizes. Both `view_tiles()` and mapgl support MLT natively with current MapLibre GL JS versions. For broader compatibility with external tools, specify the MVT format:

```r
freestile(bgs, "us_income_mvt.pmtiles",
  layer_name = "income",
  tile_format = "mvt"
)
```

## Serving Large Tilesets

The included `serve_tiles()` function works effectively for files up to approximately 1 GB. For larger datasets, deploy an external server with superior concurrency capabilities. Using Node's http-server (if installed):

```bash
npx http-server /path/to/tiles -p 8082 --cors -c-1
```

Update your source URL to reference the external server:

```r
add_pmtiles_source(
  id = "income-src",
  url = "http://localhost:8082/us_income.pmtiles",
  promote_id = "GEOID"
)
```

Note: External servers deliver improved performance across all dataset sizes. Terminate with Ctrl+C when finished.

## Cleanup

Halt the built-in server when done:

```r
stop_server()
```
