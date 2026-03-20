# Integration Patterns

Cross-package patterns for combining freestiler and mapgl in production workflows.

## Quick Exploration → Production Pipeline

Start with rapid viz, then optimize for deployment:

```r
library(mapgl)
library(freestiler)
library(sf)

# 1. Exploration: Direct visualization
nc <- st_read("data.gpkg") |> st_transform(4326)
maplibre_view(nc, column = "population")

# 2. Production: Tile for performance
freestile(nc, "nc.pmtiles", layer_name = "counties")
view_tiles("nc.pmtiles")

# 3. Deploy: Custom styling
maplibre(style = carto_style("voyager")) |>
  add_pmtiles_source(id = "data", url = "https://example.com/nc.pmtiles") |>
  add_fill_layer(
    source = "data",
    source_layer = "counties",
    fill_color = interpolate(
      column = "population",
      values = c(10000, 100000),
      stops = c("#fee5d9", "#a50f15")
    )
  )
```

## Large Dataset Workflow (CSV/Parquet → Tiles → Map)

Process spatial data too large for memory:

```r
library(freestiler)
library(duckdb)

# Step 1: Convert to spatial with DuckDB (no loading to R)
freestile_query(
  query = "
    SELECT
      ST_Point(lon, lat) AS geom,
      category,
      value,
      timestamp
    FROM read_parquet('data/*.parquet')
    WHERE timestamp >= '2024-01-01'
  ",
  output = "points.pmtiles",
  layer_name = "locations",
  streaming = "always"  # Critical for 10M+ rows
)

# Step 2: Quick validation
view_tiles("points.pmtiles")

# Step 3: Production map with filters
library(mapgl)
maplibre() |>
  add_pmtiles_source(id = "src", url = "points.pmtiles") |>
  add_circle_layer(
    source = "src",
    source_layer = "locations",
    circle_color = match(
      column = "category",
      values = c("A", "B", "C"),
      stops = c("red", "blue", "green")
    ),
    circle_radius = 8
  )
```

## Multi-Layer Maps with Mixed Sources

Combine tiles and direct sf sources:

```r
library(mapgl)
library(sf)

# Base layer: Large boundary polygons (tiled)
# Point layer: Current selections (sf, updated frequently)

boundaries <- st_read("boundaries.gpkg")
freestile(boundaries, "boundaries.pmtiles", layer_name = "regions")

# Active points (small, changes often)
active_points <- st_read("current.gpkg") |> st_transform(4326)

maplibre(style = carto_style("dark")) |>
  # Layer 1: Static tiles
  add_pmtiles_source(id = "boundaries", url = "boundaries.pmtiles") |>
  add_line_layer(
    source = "boundaries",
    source_layer = "regions",
    line_color = "#888",
    line_width = 2
  ) |>
  # Layer 2: Dynamic sf
  add_circle_layer(
    id = "active",
    source = active_points,
    circle_color = "yellow",
    circle_radius = 10
  )
```

## Shiny: Reactive Filtering Without Re-rendering

Update filters without regenerating the map:

```r
library(shiny)
library(mapgl)

ui <- fluidPage(
  selectInput("category", "Filter", choices = c("All", "A", "B", "C")),
  sliderInput("min_value", "Minimum Value", min = 0, max = 100, value = 0),
  maplibreOutput("map", height = "600px")
)

server <- function(input, output, session) {
  # Render once
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      add_pmtiles_source(id = "data", url = "tiles.pmtiles") |>
      add_circle_layer(
        id = "points",
        source = "data",
        source_layer = "locations",
        circle_color = "steelblue",
        circle_radius = 6
      )
  })

  # Update filters dynamically (fast)
  observe({
    filter_expr <- if (input$category == "All") {
      list(">=", list("get", "value"), input$min_value)
    } else {
      list(
        "all",
        list("==", list("get", "category"), input$category),
        list(">=", list("get", "value"), input$min_value)
      )
    }

    maplibre_proxy("map") |>
      set_filter("points", filter_expr)
  })
}
```

## Shiny: Click to Update External Data

Handle map clicks to drive other UI elements:

```r
server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre() |>
      add_pmtiles_source(id = "src", url = "regions.pmtiles") |>
      add_fill_layer(
        id = "regions",
        source = "src",
        source_layer = "areas",
        fill_color = "lightblue"
      )
  })

  # React to clicks
  observeEvent(input$map_feature_click, {
    clicked <- input$map_feature_click
    region_id <- clicked$properties$id

    # Update map styling
    maplibre_proxy("map") |>
      set_paint_property(
        "regions",
        "fill-color",
        case_when(
          condition = list("==", list("get", "id"), region_id),
          values = c("yellow", "lightblue")  # Highlight selected
        )
      )

    # Trigger other UI updates
    output$details <- renderText({
      paste("Selected:", clicked$properties$name)
    })
  })
}
```

## 3D Terrain + Tiled Data

Combine elevation with custom data layers:

```r
library(mapgl)

maplibre(
  style = carto_style("voyager"),
  center = c(-122.4, 37.8),
  zoom = 12,
  pitch = 60
) |>
  add_raster_dem_source(
    id = "terrain",
    url = "https://demotiles.maplibre.org/terrain-tiles/tiles.json"
  ) |>
  set_terrain(source = "terrain", exaggeration = 1.5) |>
  add_pmtiles_source(id = "buildings", url = "buildings.pmtiles") |>
  add_fill_extrusion_layer(
    source = "buildings",
    source_layer = "structures",
    fill_extrusion_height = list("get", "height"),
    fill_extrusion_color = "steelblue"
  )
```

## Performance: Optimize Tile Size

Balance file size vs zoom performance:

```r
library(freestiler)

# Strategy 1: Limit zoom for detailed features
freestile(
  detailed_polygons,
  "detailed.pmtiles",
  layer_name = "parcels",
  min_zoom = 10,  # Don't show until zoomed in
  max_zoom = 16
)

# Strategy 2: Simplify geometry at low zooms
freestile_query(
  query = "
    SELECT
      CASE
        WHEN zoom_level <= 8 THEN ST_Simplify(geom, 0.01)
        ELSE geom
      END AS geom,
      *
    FROM read_parquet('precise.parquet')
  ",
  output = "adaptive.pmtiles",
  layer_name = "features"
)
```

## Testing: Validate Map Output

Use plot validator for automated testing:

```r
library(testthat)
library(mapgl)

test_that("map renders with all layers", {
  map <- maplibre() |>
    add_pmtiles_source(id = "data", url = "test.pmtiles") |>
    add_circle_layer(source = "data", source_layer = "points")

  # Requires lib/r-validators/plot-validator.R
  expect_snapshot_plot(map, "test_map")
})
```

## Deployment: Static Hosting

Serve PMTiles without a server:

```r
# 1. Generate tiles
freestile(data, "dist/tiles.pmtiles", layer_name = "features")

# 2. Create HTML with embedded map
html <- htmltools::tagList(
  maplibre() |>
    add_pmtiles_source(
      id = "src",
      url = "./tiles.pmtiles"  # Relative path works with file://
    ) |>
    add_fill_layer(source = "src", source_layer = "features")
)

htmltools::save_html(html, "dist/index.html")

# 3. Deploy dist/ folder to GitHub Pages, Netlify, etc.
# PMTiles supports HTTP range requests - no server processing needed
```

## Troubleshooting: Common Integration Issues

### Layer Not Visible

```r
# ✗ Wrong: Layer name mismatch
freestile(data, "out.pmtiles", layer_name = "counties")
maplibre() |>
  add_pmtiles_source(id = "src", url = "out.pmtiles") |>
  add_fill_layer(source = "src", source_layer = "regions")  # Wrong name!

# ✓ Correct: Names must match
maplibre() |>
  add_pmtiles_source(id = "src", url = "out.pmtiles") |>
  add_fill_layer(source = "src", source_layer = "counties")
```

### Wrong CRS

```r
# ✗ Wrong: Not transformed
data <- st_read("data.gpkg")  # Might be State Plane, UTM, etc.
freestile(data, "out.pmtiles", layer_name = "features")  # Will fail or distort

# ✓ Correct: Always WGS84
data <- st_read("data.gpkg") |> st_transform(4326)
freestile(data, "out.pmtiles", layer_name = "features")
```

### Memory Issues with Large sf Objects

```r
# ✗ Wrong: Loading huge file into R
large_data <- st_read("10gb_file.gpkg")
freestile(large_data, "out.pmtiles", layer_name = "data")

# ✓ Correct: Stream directly from file
freestile_file("10gb_file.gpkg", "out.pmtiles", layer_name = "data")

# ✓ Or use SQL streaming
freestile_query(
  query = "SELECT * FROM ST_Read('10gb_file.gpkg')",
  output = "out.pmtiles",
  layer_name = "data",
  streaming = "always"
)
```
