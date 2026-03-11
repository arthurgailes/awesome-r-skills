# mapgl Styling Reference

**Updated for mapgl v0.4.5** (Mapbox GL JS v3.19.1, MapLibre GL JS v5.19.0)

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

## Shiny Proxy Operations

```r
# Update styling without redrawing map
maplibre_proxy("map") |>
  set_paint_property("layer1", "fill-color", input$color)

# Update data source
maplibre_proxy("map") |>
  set_source("layer1", filtered_data())

# Apply filter (must use list notation)
maplibre_proxy("map") |>
  set_filter("layer1", list(">=", get_column("value"), input$threshold))

# Toggle layer visibility
maplibre_proxy("map") |>
  set_layout_property("layer1", "visibility", "none")
```

### Reactive Inputs (automatic)

- `input$MAPID_center` - map center coordinates
- `input$MAPID_zoom` - zoom level
- `input$MAPID_bbox` - bounding box
- `input$MAPID_click` - click coordinates
- `input$MAPID_feature_click` - clicked feature properties

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

## Basemap Styles

```r
# Mapbox (needs MAPBOX_PUBLIC_TOKEN)
mapbox_style("streets")    # Default
mapbox_style("light")      # Minimal
mapbox_style("dark")       # Dark mode
mapbox_style("satellite")  # Imagery

# CARTO (free, no key)
carto_style("positron")    # Light minimal
carto_style("dark-matter") # Dark minimal
carto_style("voyager")     # Colorful

# OpenFreeMap (free, no key) - v0.4.1+
openfreemap_style("liberty")
openfreemap_style("bright")

# Esri (requires ArcGIS API key) - v0.4.5+
esri_style("streets")      # ArcGIS basemaps
esri_open_style("topo")    # Open basemaps (no key)

# MapTiler (needs key)
maptiler_style("streets")
```

## Interactive Legends (v0.4.4+)

**Enable direct data filtering from legends:**

```r
# Continuous legend with filter slider
maplibre() |>
  add_fill_layer(id = "data", source = sf_obj, fill_color = ...) |>
  add_continuous_legend(
    layer_id = "data",
    values = c(0, 100),
    colors = c("white", "darkblue"),
    interactive = TRUE,      # Enable filtering
    draggable = TRUE,        # Allow repositioning
    title = "Population"
  )

# Categorical legend with toggle
maplibre() |>
  add_categorical_legend(
    values = c("Type A", "Type B"),
    colors = c("red", "blue"),
    interactive = TRUE       # Click to hide/show
  )

# Access filter state in Shiny
observeEvent(input$map_legend_filter, {
  filtered_range <- input$map_legend_filter  # e.g., c(25, 75)
})
```

**Features:**
- Categorical: Visual indicators show active/hidden layers
- Continuous: Drag dual handles for range filtering
- Smart number formatting (K/M notation)
- Works with GeoJSON, vector tiles, and PMTiles sources

## Comparison Maps

For side-by-side comparison, use separate functions:

```r
ui <- fluidPage(
  maplibreCompareOutput("compare_map")
)

server <- function(input, output, session) {
  output$compare_map <- renderMaplibreCompare({
    maplibre_compare(
      maplibre(style = carto_style("positron")),
      maplibre(style = carto_style("dark-matter"))
    )
  })
}
```

**Note:** Globe projection now supported in compare view (v0.4.4)
