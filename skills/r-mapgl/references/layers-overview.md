# Layers Overview

Source: <https://walker-data.com/mapgl/articles/layers-overview.html>

## Sources and layers

In Mapbox GL JS and MapLibre, datasets are added as **sources** and drawn as **layers**. mapgl exposes these APIs to R users while accommodating the typical sf workflow. `sf` objects and `terra` rasters are natively supported.

An `sf` object can be a source either via `add_source()` or via the `source` parameter in a layer function. `add_fill_layer()` calls Mapbox GL JS's `addLayer()` internally with a `fill` type and enumerates its paint/layout options as R arguments.

Use `bounds = ...` when initializing the map (or `fit_bounds()` later) to fix the view to a layer's extent.

```r
library(mapgl)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"))

mapboxgl(bounds = nc) |>
  add_fill_layer(
    id = "nc_data",
    source = nc,
    fill_color = "blue",
    fill_opacity = 0.5
  )
```

## Line layers

```r
library(tigris)
options(tigris_use_cache = TRUE)
loving_roads <- roads("TX", "Loving")

maplibre(style = maptiler_style("backdrop"), bounds = loving_roads) |>
  add_line_layer(
    id = "roads",
    source = loving_roads,
    line_color = "navy",
    line_opacity = 0.7
  )
```

## Circle layers

Circle layers typically represent point data. Clustering is enabled via `cluster_options`.

```r
library(dplyr); library(sf)
set.seed(1234)
bbox <- st_bbox(c(xmin = -77.119759, ymin = 38.791645,
                  xmax = -76.909393, ymax = 38.995548), crs = st_crs(4326))
random_points <- st_as_sf(
  data.frame(id = 1:30,
             lon = runif(30, bbox["xmin"], bbox["xmax"]),
             lat = runif(30, bbox["ymin"], bbox["ymax"])),
  coords = c("lon", "lat"), crs = 4326
)
categories <- c("music", "bar", "theatre", "bicycle")
random_points <- random_points |>
  mutate(category = sample(categories, n(), replace = TRUE))

mapboxgl(style = mapbox_style("dark"), bounds = random_points) |>
  add_circle_layer(
    id = "poi-layer",
    source = random_points,
    circle_color = match_expr(
      "category",
      values = c("music", "bar", "theatre", "bicycle"),
      stops = c("#1f78b4", "#33a02c", "#e31a1c", "#ff7f00")
    ),
    circle_radius = 8,
    circle_stroke_color = "#ffffff",
    circle_stroke_width = 2,
    circle_opacity = 0.8,
    tooltip = "category",
    hover_options = list(circle_radius = 12, circle_color = "#ffff99")
  ) |>
  add_categorical_legend(
    legend_title = "Points of Interest",
    values = c("Music", "Bar", "Theatre", "Bicycle"),
    colors = c("#1f78b4", "#33a02c", "#e31a1c", "#ff7f00"),
    patch_shape = "circle"
  )
```

## Symbol layers

Symbol layers customize icon and label appearance; not all args work with every icon set. `icon_image` names a sprite from the map's style.

```r
mapboxgl(style = mapbox_style("light"), bounds = random_points) |>
  add_symbol_layer(
    id = "points-of-interest",
    source = random_points,
    icon_image = get_column("category"),
    icon_allow_overlap = TRUE,
    tooltip = "category"
  )
```

## Heatmap layers

Take POINT geometry and visualize density. The example below reads a remote GeoJSON as a source.

```r
mapboxgl(style = mapbox_style("dark"), center = c(-120, 50), zoom = 2) |>
  add_heatmap_layer(
    id = "earthquakes-heat",
    source = list(
      type = "geojson",
      data = "https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"
    ),
    heatmap_weight = interpolate(
      column = "mag",
      values = c(0, 6),
      stops = c(0, 1)
    ),
    heatmap_intensity = interpolate(
      property = "zoom",
      values = c(0, 9),
      stops = c(1, 3)
    ),
    heatmap_color = interpolate(
      property = "heatmap-density",
      values = seq(0, 1, 0.2),
      stops = c("rgba(33,102,172,0)", "rgb(103,169,207)",
                "rgb(209,229,240)", "rgb(253,219,199)",
                "rgb(239,138,98)", "rgb(178,24,43)")
    ),
    heatmap_opacity = 0.7
  )
```

## Fill-extrusion layers

```r
maplibre(
  style = maptiler_style("basic"),
  center = c(-74.0066, 40.7135),
  zoom = 15.5,
  pitch = 45,
  bearing = -17.6,
  projection = "mercator"  # recommended; globe has extrusion artifacts
) |>
  add_vector_source(
    id = "openmaptiles",
    url = paste0("https://api.maptiler.com/tiles/v3/tiles.json?key=",
                 Sys.getenv("MAPTILER_API_KEY"))
  ) |>
  add_fill_extrusion_layer(
    id = "3d-buildings",
    source = "openmaptiles",
    source_layer = "building",
    fill_extrusion_color = interpolate(
      column = "render_height",
      values = c(0, 200, 400),
      stops = c("lightgray", "royalblue", "lightblue")
    ),
    fill_extrusion_height = list(
      "interpolate", list("linear"), list("zoom"),
      15, 0,
      16, list("get", "render_height")
    )
  )
```

## Raster layers

Rasters from `terra` pass into `add_image_source(data = ...)`, then visualize with `add_raster_layer()`. Remote rasters use `add_image_source(url = ...)` or `add_raster_source(url|tiles = ...)`.

```r
mapboxgl(style = mapbox_style("dark"), zoom = 5, center = c(-75.789, 41.874)) |>
  add_image_source(
    id = "radar",
    url = "https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif",
    coordinates = list(
      c(-80.425, 46.437),
      c(-71.516, 46.437),
      c(-71.516, 37.936),
      c(-80.425, 37.936)
    )
  ) |>
  add_raster_layer(
    id = "radar-layer",
    source = "radar",
    raster_fade_duration = 0
  )
```

## Markers

Markers highlight locations but are not layers. Add via `add_markers()`; accepts a length-2 numeric (one marker), list of length-2 vectors (multiple), or sf POINT.

```r
mapboxgl(style = mapbox_style("streets"),
         center = c(-74.006, 40.7128), zoom = 10) |>
  add_markers(
    c(-74.006, 40.7128),
    color = "blue",
    rotation = 45,
    popup = "A marker"
  )
```
