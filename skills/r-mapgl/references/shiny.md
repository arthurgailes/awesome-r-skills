# Using mapgl with Shiny

Source: <https://walker-data.com/mapgl/articles/shiny.html>

## Overview

mapgl was created to integrate current Mapbox GL JS and MapLibre versions with Shiny's reactive framework.

## Basic example

```r
library(shiny)
library(bslib)
library(mapgl)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"))

ui <- page_sidebar(
  title = "mapgl with Shiny",
  sidebar = sidebar(),
  card(full_screen = TRUE, maplibreOutput("map"))
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(nc, animate = FALSE) |>
      add_fill_layer(
        id = "nc_data",
        source = nc,
        fill_color = "blue",
        fill_opacity = 0.5
      )
  })
}

shinyApp(ui, server)
```

Use `maplibreOutput()` + `renderMaplibre()`, or `mapboxglOutput()` + `renderMapboxgl()` for Mapbox.

## Map reactive inputs

Interactive events auto-expose (with `outputId = "map"`):

- `input$map_center` -- list(lng, lat)
- `input$map_zoom`
- `input$map_bbox` -- list(xmin, xmax, ymin, ymax)
- `input$map_click` -- list(lng, lat, time)
- `input$map_feature_click` -- list(id, properties, lng, lat)

```r
ui <- page_sidebar(
  title = "mapgl with Shiny",
  sidebar = sidebar(verbatimTextOutput("clicked_feature")),
  card(full_screen = TRUE, maplibreOutput("map"))
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(nc, animate = FALSE) |>
      add_fill_layer(id = "nc_data", source = nc,
                     fill_color = "blue", fill_opacity = 0.5)
  })
  output$clicked_feature <- renderPrint({
    req(input$map_feature_click)
    input$map_feature_click
  })
}
shinyApp(ui, server)
```

## Proxy pattern: modify without re-render

Use `maplibre_proxy()` / `mapboxgl_proxy()` to apply updates to an existing map without re-creating it.

Proxy-compatible: `set_style()`, `set_layout_property()`, `set_paint_property()`, `set_filter()`, `set_tooltip()`, `set_popup()`, `clear_layer()`, `add_*_layer()`, `add_markers()`, `clear_markers()`, `fly_to()`, `fit_bounds()`, etc.

```r
library(colourpicker)

ui <- page_sidebar(
  title = "mapgl with Shiny",
  sidebar = sidebar(
    colourInput("color", "Select a color", value = "blue"),
    sliderInput("slider", "Show BIR74 values above:",
                value = 248, min = 248, max = 21588)
  ),
  card(full_screen = TRUE, maplibreOutput("map"))
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(nc, animate = FALSE) |>
      add_fill_layer(id = "nc_data", source = nc,
                     fill_color = "blue", fill_opacity = 0.5)
  })

  observeEvent(input$color, {
    maplibre_proxy("map") |>
      set_paint_property("nc_data", "fill-color", input$color)
  })

  observeEvent(input$slider, {
    maplibre_proxy("map") |>
      set_filter("nc_data",
                 list(">=", get_column("BIR74"), input$slider))
  })
}
shinyApp(ui, server)
```

## Compare widget in Shiny

Compare maps require specialized functions:

- MapLibre: `maplibreCompareOutput()`, `renderMaplibreCompare()`, `maplibre_compare_proxy(mapId, map_side = "before"|"after")`.
- Mapbox: `mapboxglCompareOutput()`, `renderMapboxglCompare()`, `mapboxgl_compare_proxy(mapId, map_side = "before"|"after")`.

`map_side = "before"` is the left (or top) map, `"after"` is the right (or bottom).
