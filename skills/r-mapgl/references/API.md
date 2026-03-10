# mapgl API Reference

Complete function reference for the mapgl package.

## Creating Maps

| Function | Purpose |
|----------|---------|
| `mapboxgl()` | Initialize a Mapbox GL Map |
| `maplibre()` | Initialize a Maplibre GL Map |
| `mapboxgl_view()` | Quick visualization of geometries with Mapbox GL |
| `maplibre_view()` | Quick visualization of geometries with MapLibre GL |

**Example:**
```r
library(mapgl)

# Basic map
map <- maplibre(center = c(-74.5, 40), zoom = 9)

# Quick view of sf object
maplibre_view(nc)
```

## Adding Layers

| Function | Purpose |
|----------|---------|
| `add_layer()` | Add a layer to a map from a source |
| `add_fill_layer()` | Add a fill layer to a map |
| `add_line_layer()` | Add a line layer to a map |
| `add_circle_layer()` | Add a circle layer to a Mapbox GL map |
| `add_heatmap_layer()` | Add a heatmap layer to a Mapbox GL map |
| `add_fill_extrusion_layer()` | Add a fill-extrusion layer to a Mapbox GL map |
| `add_raster_layer()` | Add a raster layer to a Mapbox GL map |
| `add_symbol_layer()` | Add a symbol layer to a map |
| `add_view()` | Add a visualization layer to an existing map |

**Example:**
```r
map |>
  add_source("data", data = sf_object) |>
  add_fill_layer(
    source = "data",
    fill_color = "blue",
    fill_opacity = 0.6
  )
```

## Data Sources

| Function | Purpose |
|----------|---------|
| `add_source()` | Add a GeoJSON or sf source to a Mapbox GL or Maplibre GL map |
| `add_vector_source()` | Add a vector tile source to a Mapbox GL or Maplibre GL map |
| `add_raster_source()` | Add a raster tile source to a Mapbox GL or Maplibre GL map |
| `add_raster_dem_source()` | Add a raster DEM source to a Mapbox GL or Maplibre GL map |
| `add_image_source()` | Add an image source to a Mapbox GL or Maplibre GL map |
| `add_video_source()` | Add a video source to a Mapbox GL or Maplibre GL map |
| `add_h3j_source()` | Add a hexagon source from the H3 geospatial indexing system |
| `add_pmtiles_source()` | Add a PMTiles source to a Mapbox GL or Maplibre GL map |

**PMTiles example:**
```r
map |>
  add_pmtiles_source("tiles", url = "path/to/tiles.pmtiles") |>
  add_fill_layer(source = "tiles", source_layer = "layer_name")
```

## Map Controls

| Function | Purpose |
|----------|---------|
| `add_navigation_control()` | Add a navigation control to a map |
| `add_fullscreen_control()` | Add a fullscreen control to a map |
| `add_scale_control()` | Add a scale control to a map |
| `add_layers_control()` | Add a layers control to the map |
| `add_draw_control()` | Add a draw control to a map |
| `add_geocoder_control()` | Add a geocoder control to a map |
| `add_reset_control()` | Add a reset control to a map |
| `add_geolocate_control()` | Add a geolocate control to a map |
| `add_globe_control()` | Add a globe control to a map |
| `add_screenshot_control()` | Add a screenshot control to a map |
| `add_control()` | Add a custom control to a map |
| `clear_controls()` | Clear controls from a Mapbox GL or Maplibre GL map in a Shiny app |

**Example:**
```r
map |>
  add_navigation_control() |>
  add_fullscreen_control() |>
  add_scale_control()
```

## Legends

| Function | Purpose |
|----------|---------|
| `add_legend()` | Add legends to Mapbox GL and MapLibre GL maps |
| `add_categorical_legend()` | Add categorical legends to Mapbox GL and MapLibre GL maps |
| `add_continuous_legend()` | Add continuous legends to Mapbox GL and MapLibre GL maps |
| `legend_style()` | Create custom styling for map legends |
| `clear_legend()` | Clear legends from a map |

**Example:**
```r
map |>
  add_continuous_legend(
    values = c(0, 100),
    colors = c("blue", "red"),
    title = "Population"
  )
```

## Markers

| Function | Purpose |
|----------|---------|
| `add_markers()` | Add markers to a Mapbox GL or Maplibre GL map |
| `clear_markers()` | Clear markers from a map in a Shiny session |

**Example:**
```r
map |>
  add_markers(
    lng = c(-74.5, -74.6),
    lat = c(40, 40.1),
    popup = c("Location A", "Location B")
  )
```

## Styling Helpers

| Function | Purpose |
|----------|---------|
| `mapbox_style()` | Get Mapbox Style URL |
| `maptiler_style()` | Get MapTiler Style URL |
| `carto_style()` | Get CARTO Style URL |
| `openfreemap_style()` | Get OpenFreeMap Style URL |
| `esri_style()` | Get Esri ArcGIS Basemap Style URL |
| `esri_open_style()` | Get Esri Open Basemap Style URL |
| `interpolate()` | Create an interpolation expression |
| `match_expr()` | Create a match expression |
| `step_expr()` | Create a step expression |
| `get_column()` | Get column or property for use in mapping |
| `concat()` | Create a concatenation expression |
| `number_format()` | Create a number formatting expression |
| `cluster_options()` | Prepare cluster options for circle layers |
| `palette_to_lut()` | Convert R color palette to mapgl LUT |

**Example:**
```r
# Color by column value
fill_color = interpolate(
  get_column("population"),
  values = c(0, 1000, 5000),
  palette = "viridis"
)
```

## Data Classification

| Function | Purpose |
|----------|---------|
| `step_equal_interval()` | Step expressions with automatic classification |
| `step_quantile()` | Step expressions with automatic classification |
| `step_jenks()` | Step expressions with automatic classification |
| `interpolate_palette()` | Create interpolation expression with automatic palette and breaks |
| `get_legend_labels()` | Extract information from classification objects |
| `get_legend_colors()` | Extract information from classification objects |
| `get_breaks()` | Extract information from classification objects |

**Example:**
```r
# Automatic classification
fill_color = step_jenks(
  get_column("value"),
  n_breaks = 5,
  palette = "Blues"
)
```

## Camera and View

| Function | Purpose |
|----------|---------|
| `fit_bounds()` | Fit the map to a bounding box |
| `fly_to()` | Fly to a given view |
| `ease_to()` | Ease to a given view |
| `jump_to()` | Jump to a given view |
| `set_view()` | Set the map center and zoom level |

**Example:**
```r
# In Shiny with proxy
maplibre_proxy("map") |>
  fly_to(center = c(-74.5, 40), zoom = 12)
```

## Map Configuration

| Function | Purpose |
|----------|---------|
| `set_style()` | Update the style of a map |
| `set_projection()` | Set Projection for a Mapbox/Maplibre Map |
| `set_terrain()` | Set terrain properties on a map |
| `set_fog()` | Set fog on a Mapbox GL map |
| `set_rain()` | Set rain effect on a Mapbox GL map |
| `set_snow()` | Set snow effect on a Mapbox GL map |
| `set_config_property()` | Set a configuration property for a Mapbox GL map |

**Example:**
```r
map |>
  set_projection("globe") |>
  set_terrain(source = "dem", exaggeration = 1.5)
```

## Layer Management

| Function | Purpose |
|----------|---------|
| `set_filter()` | Set a filter on a map layer |
| `set_paint_property()` | Set a paint property on a map layer |
| `set_layout_property()` | Set a layout property on a map layer |
| `set_tooltip()` | Set tooltip on a map layer |
| `set_popup()` | Set popup on a map layer |
| `set_source()` | Set source of a map layer |
| `clear_layer()` | Clear layers from a map using a proxy |
| `move_layer()` | Move a layer to a different z-position |

**Example:**
```r
map |>
  set_tooltip("layer-id", "{{property_name}}") |>
  set_filter("layer-id", list("==", list("get", "type"), "residential"))
```

## Shiny Integration

| Function | Purpose |
|----------|---------|
| `mapboxglOutput()` | Create a Mapbox GL output element for Shiny |
| `maplibreOutput()` | Create a Maplibre GL output element for Shiny |
| `renderMapboxgl()` | Render a Mapbox GL output element in Shiny |
| `renderMaplibre()` | Render a Maplibre GL output element in Shiny |
| `mapboxgl_proxy()` | Create a proxy object for a Mapbox GL map in Shiny |
| `maplibre_proxy()` | Create a proxy object for a Maplibre GL map in Shiny |
| `mapboxglCompareOutput()` | Create a Mapbox GL Compare output element for Shiny |
| `maplibreCompareOutput()` | Create a Maplibre GL Compare output element for Shiny |
| `renderMapboxglCompare()` | Render a Mapbox GL Compare output element in Shiny |
| `renderMaplibreCompare()` | Render a Maplibre GL Compare output element in Shiny |
| `mapboxgl_compare_proxy()` | Create a proxy object for a Mapbox GL Compare widget in Shiny |
| `maplibre_compare_proxy()` | Create a proxy object for a Maplibre GL Compare widget in Shiny |
| `enable_shiny_hover()` | Enable hover events for Shiny applications |

**Example:**
```r
# UI
maplibreOutput("map")

# Server
output$map <- renderMaplibre({
  maplibre() |>
    add_navigation_control()
})

# Update with proxy
maplibre_proxy("map") |>
  add_source("data", data = reactive_data())
```

## Turf.js Spatial Operations

| Function | Purpose |
|----------|---------|
| `turf_buffer()` | Turf.js Geospatial Operations for mapgl |
| `turf_union()` | Union geometries |
| `turf_intersect()` | Find intersection of two geometries |
| `turf_difference()` | Find difference between two geometries |
| `turf_filter()` | Spatial filter features by predicate |
| `turf_convex_hull()` | Create convex hull |
| `turf_concave_hull()` | Create concave hull |
| `turf_voronoi()` | Create Voronoi diagram |
| `turf_centroid()` | Calculate centroid of geometries |
| `turf_center_of_mass()` | Calculate center of mass |
| `turf_distance()` | Calculate distance between two features |
| `turf_area()` | Calculate area of geometries |

**Example:**
```r
# Buffer features on the map
buffered <- turf_buffer(features, distance = 1, units = "miles")
```

## Advanced Features

| Function | Purpose |
|----------|---------|
| `compare()` | Create a Compare widget |
| `add_globe_minimap()` | Add a Globe Minimap to a map |
| `add_image()` | Add an image to the map |
| `get_drawn_features()` | Get drawn features from the map |
| `add_features_to_draw()` | Add features to an existing draw control |
| `clear_drawn_features()` | Clear all drawn features from a map |
| `query_rendered_features()` | Query rendered features on a map in a Shiny session |
| `get_queried_features()` | Get queried features from a map as an sf object |

**Example:**
```r
# Drawing in Shiny
map |>
  add_draw_control()

# Get drawn features
drawn <- get_drawn_features("map")
```

## Story Maps

| Function | Purpose |
|----------|---------|
| `story_map()` | Create a scrollytelling story map |
| `story_maplibre()` | Create a scrollytelling story map with MapLibre |
| `story_leaflet()` | Create a scrollytelling story map with Leaflet |
| `story_section()` | Create a story section for story maps |
| `on_section()` | Observe events on story map section transitions |

**Example:**
```r
story_maplibre() |>
  story_section(
    id = "intro",
    content = "Welcome to the story",
    center = c(-74.5, 40),
    zoom = 9
  )
```

## Documentation

**Package site:** https://walker-data.com/mapgl/
**GitHub:** https://github.com/walkerke/mapgl
