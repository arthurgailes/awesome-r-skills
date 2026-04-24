# Client-side geospatial analysis with turf.js

Source: <https://walker-data.com/mapgl/articles/turf.html>

## Why client-side?

mapgl integrates turf.js v7.3.0 so spatial operations happen in the browser -- no server round-trips. Particularly useful in Shiny: reduces server load and keeps interactions snappy.

Each turf function accepts one of three input forms: a `layer_id` (existing layer/source on the map), a `data = <sf object>`, or raw coordinates. Results are written into a new map source via `source_id`.

## Buffering

```r
library(mapgl); library(sf); library(tigris)
options(tigris_use_cache = TRUE)

tcu <- st_sf(
  name = "TCU",
  geometry = st_sfc(st_point(c(-97.364, 32.708)), crs = 4326)
)

maplibre(style = carto_style("positron"),
         center = c(-97.364, 32.708), zoom = 11) |>
  add_circle_layer(
    id = "tcu", source = tcu,
    circle_color = "purple", circle_radius = 8,
    circle_stroke_color = "white", circle_stroke_width = 2
  ) |>
  turf_buffer(
    layer_id = "tcu", radius = 2, units = "miles",
    source_id = "tcu_buffer"
  ) |>
  add_fill_layer(
    id = "buffer_display", source = "tcu_buffer",
    fill_color = "purple", fill_opacity = 0.2,
    fill_outline_color = "purple"
  )
```

## Spatial filtering with predicates

`turf_filter()` supports `predicate = "intersects"`, `"within"`, `"contains"`, `"crosses"`, `"disjoint"`.

```r
tarrant_tracts <- tracts("TX", "Tarrant", cb = TRUE)

maplibre(style = carto_style("positron")) |>
  fit_bounds(tarrant_tracts) |>
  add_fill_layer(
    id = "all_tracts", source = tarrant_tracts,
    fill_color = "lightgray", fill_opacity = 0.5,
    fill_outline_color = "white"
  ) |>
  turf_buffer(
    data = tcu, radius = 2, units = "miles",
    source_id = "tcu_buffer_filter"
  ) |>
  turf_filter(
    layer_id = "all_tracts",
    filter_layer_id = "tcu_buffer_filter",
    predicate = "intersects",
    source_id = "intersecting_tracts"
  ) |>
  add_fill_layer(
    id = "intersects_result", source = "intersecting_tracts",
    fill_color = "red", fill_opacity = 0.8
  ) |>
  add_circle_layer(
    id = "tcu_location", source = tcu,
    circle_color = "purple", circle_radius = 10,
    circle_stroke_color = "white", circle_stroke_width = 3
  ) |>
  add_fill_layer(
    id = "buffer_display", source = "tcu_buffer_filter",
    fill_color = "purple", fill_opacity = 0.2
  )
```

## Shiny: real-time filter on drawn geometry

```r
library(shiny); library(mapgl); library(sf); library(tigris)
tarrant_tracts <- tracts(state = "TX", county = "Tarrant", cb = TRUE)

ui <- fluidPage(
  maplibreOutput("map", height = "100vh"),
  absolutePanel(
    top = 10, left = 10,
    selectInput("predicate", "Filter Type:",
                choices = c("Intersects" = "intersects",
                            "Within" = "within",
                            "Contains" = "contains",
                            "Disjoint" = "disjoint"),
                selected = "intersects"),
    verbatimTextOutput("results")
  )
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      fit_bounds(tarrant_tracts) |>
      add_fill_layer(
        id = "tracts", source = tarrant_tracts,
        fill_color = "lightblue", fill_opacity = 0.5,
        fill_outline_color = "white"
      ) |>
      add_draw_control(position = "top-right")
  })

  observeEvent(input$map_drawn_features, {
    if (!is.null(input$map_drawn_features)) {
      Sys.sleep(0.2)  # allow draw source to settle
      maplibre_proxy("map") |>
        turf_filter(
          layer_id = "tracts",
          filter_layer_id = "gl-draw-polygon-fill.cold",
          predicate = input$predicate,
          source_id = "filtered_tracts",
          input_id = "filter_results"
        ) |>
        add_fill_layer(
          id = "filtered", source = "filtered_tracts",
          fill_color = "red", fill_opacity = 0.8
        )
    }
  })

  output$results <- renderText({
    if (!is.null(input$map_turf_filter_results)) {
      paste("Found", length(input$map_turf_filter_results$result$features),
            "Census tracts")
    }
  })
}

shinyApp(ui, server)
```

## Geometric operations

Centroids, centers of mass, convex hulls, Voronoi:

```r
fort_worth_tracts <- tarrant_tracts[1:10, ]

maplibre(style = carto_style("positron")) |>
  fit_bounds(fort_worth_tracts) |>
  add_fill_layer(
    id = "tracts", source = fort_worth_tracts,
    fill_color = "lightgray", fill_opacity = 0.3,
    fill_outline_color = "white"
  ) |>
  turf_centroid(layer_id = "tracts", source_id = "centroids") |>
  turf_center_of_mass(layer_id = "tracts", source_id = "mass_centers") |>
  turf_convex_hull(layer_id = "centroids", source_id = "hull") |>
  turf_voronoi(layer_id = "centroids", source_id = "voronoi") |>
  add_fill_layer(id = "hull_display", source = "hull",
                 fill_color = "blue", fill_opacity = 0.2) |>
  add_line_layer(id = "voronoi_lines", source = "voronoi",
                 line_color = "purple", line_width = 1) |>
  add_circle_layer(id = "centroids_display", source = "centroids",
                   circle_color = "red", circle_radius = 6) |>
  add_circle_layer(id = "mass_centers_display", source = "mass_centers",
                   circle_color = "orange", circle_radius = 4)
```

## Overlay analysis

```r
downtown_fw <- st_sf(geometry = st_sfc(st_point(c(-97.3313, 32.7548)), crs = 4326))
cultural_district <- st_sf(geometry = st_sfc(st_point(c(-97.3632, 32.7494)), crs = 4326))

maplibre(style = carto_style("positron"),
         center = c(-97.3313, 32.7548), zoom = 12) |>
  turf_buffer(data = downtown_fw, radius = 1.5, units = "miles",
              source_id = "downtown_buffer") |>
  turf_buffer(data = cultural_district, radius = 1.5, units = "miles",
              source_id = "cultural_buffer") |>
  add_fill_layer(id = "downtown", source = "downtown_buffer",
                 fill_color = "red", fill_opacity = 0.3) |>
  add_fill_layer(id = "cultural", source = "cultural_buffer",
                 fill_color = "blue", fill_opacity = 0.3) |>
  turf_intersect(
    layer_id = "downtown_buffer", layer_id_2 = "cultural_buffer",
    source_id = "intersection_result"
  ) |>
  add_fill_layer(id = "intersection", source = "intersection_result",
                 fill_color = "green", fill_opacity = 0.8)
```

## Available turf functions

| Function | Purpose |
|---|---|
| `turf_buffer()` | Radial buffer; `units`: `"kilometers"`, `"miles"`, `"meters"`, `"degrees"`, `"radians"` |
| `turf_filter()` | Predicate filter; `"intersects"`, `"within"`, `"contains"`, `"crosses"`, `"disjoint"` |
| `turf_union()` | Merge polygons |
| `turf_intersect()` | Overlapping geometry |
| `turf_difference()` | Subtract one from another |
| `turf_convex_hull()` | Convex boundary |
| `turf_concave_hull()` | Concave/fitted boundary |
| `turf_voronoi()` | Voronoi polygons |
| `turf_centroid()` | Geometric mean of vertices |
| `turf_center_of_mass()` | Area-weighted centroid |
| `turf_distance()` | Distance (Shiny only) |
| `turf_area()` | Area (Shiny only) |
