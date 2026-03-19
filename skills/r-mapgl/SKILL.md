---
name: r-mapgl
description: Use when creating interactive WebGL maps in R with mapgl, mapboxgl, or maplibre packages, or when building Shiny apps with interactive maps
---

# mapgl: WebGL Maps in R

## Overview

**mapgl wraps Mapbox GL JS and MapLibre GL JS for R.** Use it for smooth, GPU-accelerated interactive maps with vector tiles, 3D terrain, and Shiny integration.

## When to Use

**Choose mapgl for:**
- Smooth zooming/panning with large datasets (>10k features)
- Vector tiles and 3D terrain/buildings
- Custom WebGL styling and real-time interactivity
- Shiny apps with dynamic map updates

**API keys:** Mapbox requires `MAPBOX_PUBLIC_TOKEN`; MapLibre works without keys (CARTO/OpenFreeMap styles)

## When NOT to Use

- Simple marker maps (use leaflet)
- Static print maps (use tmap)
- Need wider browser support (WebGL not available)
- Quick exploratory visualization (tmap_mode("view") sufficient)

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

## Quick Reference

| Geometry | Function | Key params |
|----------|----------|------------|
| Polygon | `add_fill_layer()` | `fill_color`, `fill_opacity` |
| Line | `add_line_layer()` | `line_color`, `line_width` |
| Point | `add_circle_layer()` | `circle_color`, `circle_radius` |
| Label | `add_symbol_layer()` | `text_field`, `icon_image` |
| Density | `add_heatmap_layer()` | `heatmap_color`, `heatmap_radius` |
| 3D | `add_fill_extrusion_layer()` | `fill_extrusion_height` |

## Interactive Legends (v0.4.4+)

Filter data directly from legends. Categorical: click to toggle visibility. Continuous: drag handles to filter ranges. Use `draggable = TRUE` to reposition. Access state via `input$MAPID_legend_filter` in Shiny.

```r
maplibre() |> add_continuous_legend(values = c(0, 100), colors = c("blue", "red"),
                                     interactive = TRUE, draggable = TRUE)
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

## Drawing & Controls

**Draw with measurements** (v0.4.1+): `add_draw_control(modes = c("point", "line", "polygon", "rectangle", "circle"), show_measurements = TRUE)`

**Other controls**: `add_screenshot_control(resolution = 300)` for PNG export, `add_layers_control(groups = list(...))` for grouped layer toggles

## Common Mistakes

1. **Wrong CRS:** Data must be WGS84 (EPSG:4326). Use `st_transform()` first
2. **Large datasets without tiles:** Convert to PMTiles/MLT for >10k features (see `r-freestiler`)
3. **Filter expressions as strings:** Must be lists: `list(">=", get_column("value"), 10)`
4. **Proxy outside reactive:** `maplibre_proxy()` only works in observeEvent/reactive contexts
5. **Layer order:** Later layers render on top; use `before_id` to insert below existing layers

## Quick View & Testing

**Rapid viz:** `maplibre_view(sf_object, column = "value")` for instant choropleth

**Test with validator:** Use `lib/r-validators/plot-validator.R` to verify map output in tests

## Reference Files

- **API.md**: Complete function reference (120+ functions)
- **styling.md**: Data-driven styling, basemap styles, controls, camera operations
