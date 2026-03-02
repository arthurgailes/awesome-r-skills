---
name: r-mapgl
description: Use when creating interactive WebGL maps in R with mapgl, mapboxgl, or maplibre packages, or when building Shiny apps with interactive maps
---

# mapgl: WebGL Maps in R

## Overview

**mapgl wraps Mapbox GL JS and MapLibre GL JS for R.** Use it for smooth, GPU-accelerated interactive maps with vector tiles, 3D terrain, globe projections, and Shiny integration.

## When to Use mapgl vs Alternatives

| Use mapgl when... | Use leaflet when... | Use tmap when... |
|-------------------|---------------------|------------------|
| Need smooth zooming/panning | Simple marker maps | Static print maps |
| Vector tiles / large datasets | Raster tile basemaps | Quick exploratory vis |
| 3D terrain or buildings | Plugin ecosystem matters | tmap_mode("view") sufficient |
| Globe projection | Wider browser support needed | Switching view/plot modes |
| Custom WebGL styling | Legacy code compatibility | |

**API key requirements:**
- **Mapbox:** Requires token. Set `MAPBOX_PUBLIC_TOKEN` env var or use mapboxapi package
- **MapLibre:** No key needed with CARTO, OpenFreeMap, or self-hosted tiles

## Quick Start

```r
library(mapgl)
library(sf)

# MapLibre (no API key)
maplibre(style = carto_style("positron")) |>
  fit_bounds(nc) |>
  add_fill_layer(
    id = "counties",
    source = nc,
    fill_color = "steelblue",
    fill_opacity = 0.5
  )

# Mapbox (needs token)
mapboxgl(style = mapbox_style("light")) |>
  add_circle_layer(
    id = "points",
    source = my_sf,
    circle_color = "red",
    circle_radius = 5
  )
```

## Common Layer Types

| Geometry | Function | Key params |
|----------|----------|------------|
| Polygon | `add_fill_layer()` | `fill_color`, `fill_opacity`, `fill_outline_color` |
| Line | `add_line_layer()` | `line_color`, `line_width`, `line_opacity` |
| Point | `add_circle_layer()` | `circle_color`, `circle_radius`, `circle_opacity` |
| Point | `add_symbol_layer()` | `icon_image`, `text_field`, `text_size` |
| Density | `add_heatmap_layer()` | `heatmap_color`, `heatmap_radius`, `heatmap_weight` |
| 3D | `add_fill_extrusion_layer()` | `fill_extrusion_height`, `fill_extrusion_color` |

## Data-Driven Styling

### Continuous (interpolate)

```r
add_fill_layer(
  id = "choropleth",
  source = data,
  fill_color = interpolate(
    column = "value",
    values = c(0, 100),
    stops = c("white", "darkblue"),
    na_color = "grey"
  ),
  fill_opacity = 0.7
)
```

### Categorical (match_expr)

```r
add_fill_layer(
  id = "categories",
  source = data,
  fill_color = match_expr(
    column = "type",
    values = c("A", "B", "C"),
    stops = c("red", "green", "blue"),
    default = "grey"
  )
)
```

### Classified (step functions)

```r
# Automatic Jenks breaks
add_fill_layer(
  id = "classified",
  source = data,
  fill_color = step_jenks(
    column = "population",
    n = 5,
    palette = "YlOrRd"
  )
)
# Also: step_quantile(), step_equal_interval()
```

## Shiny Integration

### Basic Pattern

```r
ui <- fluidPage(
  maplibreOutput("map", height = "600px")
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(data) |>
      add_fill_layer(id = "layer1", source = data, fill_color = "blue")
  })
}
```

### Proxy for Dynamic Updates

```r
# Update styling without redrawing map
observeEvent(input$color, {
  maplibre_proxy("map") |>
    set_paint_property("layer1", "fill-color", input$color)
})

# Update data source
observeEvent(filtered_data(), {
  maplibre_proxy("map") |>
    set_source("layer1", filtered_data())
})

# Apply filter
observeEvent(input$threshold, {
  maplibre_proxy("map") |>
    set_filter("layer1", list(">=", get_column("value"), input$threshold))
})
```

### Click Events

```r
# In server
observeEvent(input$map_feature_click, {
  clicked <- input$map_feature_click
  # clicked$properties contains feature attributes
})
```

## Controls and Interactivity

```r
maplibre() |>
  add_navigation_control(position = "top-right") |>
  add_scale_control(position = "bottom-left") |>
  add_fullscreen_control() |>
  add_geocoder_control() |>  # Address search
  add_draw_control()         # User drawing
```

## Camera Operations

```r
# Animated flight
map |> fly_to(center = c(-73.9, 40.7), zoom = 12, pitch = 45)

# Instant jump
map |> jump_to(center = c(-73.9, 40.7), zoom = 10)

# Fit to data extent
map |> fit_bounds(sf_object, animate = TRUE, padding = 50)
```

## Common Gotchas

1. **Layer order matters:** Later layers render on top. Use `before_id` to insert below existing layer

2. **Source vs layer confusion:** A source holds data; layers style it. One source can have multiple layers

3. **Column vs property:** Use `column` for sf data attributes, `property` for GeoJSON properties (usually same thing)

4. **Mapbox token in Shiny:** Set in `.Renviron`, not in code. Token visible in browser otherwise

5. **Large sf objects:** Convert to vector tiles for datasets >10k features. Use `tippecanoe` or PMTiles

6. **CRS requirement:** Data must be WGS84 (EPSG:4326). Use `st_transform()` first

7. **Shiny proxy scope:** Proxy operations only work within reactive context (observeEvent, reactive, etc.)

## Basemap Styles

```r
# Mapbox (needs token)
mapbox_style("streets")    # Default
mapbox_style("light")      # Minimal
mapbox_style("dark")       # Dark mode
mapbox_style("satellite")  # Imagery

# CARTO (free, no key)
carto_style("positron")    # Light minimal
carto_style("dark-matter") # Dark minimal
carto_style("voyager")     # Colorful

# OpenFreeMap (free, no key)
openfreemap_style("liberty")
openfreemap_style("bright")
```

## Quick View Functions

For rapid visualization without layer setup:

```r
# Auto-detects geometry type and styles appropriately
maplibre_view(sf_object)
maplibre_view(sf_object, column = "value")  # Choropleth

# Mapbox equivalent
mapboxgl_view(sf_object, column = "value")
```
