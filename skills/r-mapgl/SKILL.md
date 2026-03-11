---
name: r-mapgl
description: Use when creating interactive WebGL maps in R with mapgl, mapboxgl, or maplibre packages, or when building Shiny apps with interactive maps
---

# mapgl: WebGL Maps in R

## Overview

**mapgl wraps Mapbox GL JS and MapLibre GL JS for R.** Use it for smooth, GPU-accelerated interactive maps with vector tiles, 3D terrain, and Shiny integration.

## When to Use mapgl vs Alternatives

| Use mapgl when... | Use leaflet when... | Use tmap when... |
|-------------------|---------------------|------------------|
| Smooth zooming/panning | Simple marker maps | Static print maps |
| Vector tiles / large data | Raster tile basemaps | Quick exploratory vis |
| 3D terrain or buildings | Plugin ecosystem needed | tmap_mode("view") sufficient |
| Custom WebGL styling | Wider browser support | |

**API keys:**
- **Mapbox:** Requires `MAPBOX_PUBLIC_TOKEN` env var
- **MapLibre:** No key needed with CARTO or OpenFreeMap styles

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
  add_circle_layer(id = "points", source = my_sf, circle_color = "red")
```

## Layer Types

| Geometry | Function | Key params |
|----------|----------|------------|
| Polygon | `add_fill_layer()` | `fill_color`, `fill_opacity` |
| Line | `add_line_layer()` | `line_color`, `line_width` |
| Point | `add_circle_layer()` | `circle_color`, `circle_radius` |
| Label | `add_symbol_layer()` | `text_field`, `icon_image` |
| Density | `add_heatmap_layer()` | `heatmap_color`, `heatmap_radius` |
| 3D | `add_fill_extrusion_layer()` | `fill_extrusion_height` |

## Interactive Legends (v0.4.4+)

**Filter data directly from legends:**
- **Categorical**: Click to toggle layer visibility with visual indicators
- **Continuous**: Drag dual handles to filter data ranges in real-time
- **Draggable**: Use `draggable = TRUE` to reposition legends (mouse + touch)
- **Shiny integration**: Access filter state via `input$MAPID_legend_filter`

```r
# Interactive continuous legend
maplibre() |>
  add_continuous_legend(
    values = c(0, 100),
    colors = c("blue", "red"),
    interactive = TRUE,
    draggable = TRUE
  )
```

## Shiny Integration

```r
ui <- fluidPage(maplibreOutput("map", height = "600px"))

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(data) |>
      add_fill_layer(id = "layer1", source = data, fill_color = "blue")
  })

  # Update without redraw using proxy
  observeEvent(input$color, {
    maplibre_proxy("map") |>
      set_paint_property("layer1", "fill-color", input$color)
  })

  # Click events
  observeEvent(input$map_feature_click, {
    clicked <- input$map_feature_click  # $properties has attributes
  })
}
```

## Drawing & Measurement (v0.4.1+)

**Enhanced drawing modes with live measurements:**
```r
map |>
  add_draw_control(
    modes = c("point", "line", "polygon", "rectangle", "circle"),
    show_measurements = TRUE,
    measurement_units = "both"  # "metric", "imperial", or "both"
  )
```
- **Rectangle**: Two corner points
- **Circle**: Center to edge (radius)
- **Live preview**: Shows distance, area, perimeter as you draw

## New Controls

**Screenshot export** (v0.4.4):
```r
map |> add_screenshot_control(resolution = 300)  # PNG download with DPI control
```

**Grouped layers** (v0.4.1):
```r
map |> add_layers_control(groups = list("Base" = c("layer1", "layer2")))
```

## Common Gotchas

1. **Layer order matters:** Later layers render on top. Use `before_id` to insert below
2. **Source vs layer:** One source can have multiple layers styling it
3. **CRS requirement:** Data must be WGS84 (EPSG:4326). Use `st_transform()` first
4. **Large datasets:** Convert to vector tiles (PMTiles/MLT) for >10k features. See `r-freestiler` skill
5. **Filter expressions:** Must be built as lists: `list(">=", get_column("value"), 10)`
6. **Proxy scope:** Only works within reactive context (observeEvent, reactive)

## Quick View

For rapid visualization without layer setup:

```r
maplibre_view(sf_object)                    # Auto-detects geometry
maplibre_view(sf_object, column = "value")  # Choropleth
```

## Detailed Reference

- **API.md**: Complete function reference (120+ functions)
- **styling.md**: Data-driven styling, basemap styles, controls, camera operations
