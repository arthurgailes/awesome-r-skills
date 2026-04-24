# Getting started with mapgl

Source: <https://walker-data.com/mapgl/articles/getting-started.html>

## Using Mapbox GL JS

The primary entry point for Mapbox GL JS v3 in R is `mapboxgl()`. Calling it without arguments produces an interactive globe using Mapbox's Standard style:

```r
library(mapgl)

mapboxgl()
```

To work with Mapbox maps you need a Mapbox access token. Users of the `mapboxapi` package who have configured their token will have it auto-detected. Otherwise, obtain a token from your Mapbox account and use `usethis::edit_r_environ()` to set `MAPBOX_PUBLIC_TOKEN="your_token_here"`. Mapbox GL JS is commercial but has a generous free tier.

Built-in styles are accessible via `mapbox_style()`. Map projections can also be modified (e.g. `projection = "winkelTripel"`):

```r
mapboxgl(
  style = mapbox_style("satellite"),
  projection = "winkelTripel"
)
```

For localized views use `center`, `zoom`, `pitch`, and `bearing`. These work with animated transitions. Fly to Dallas, where the Standard style shows custom buildings:

```r
mapboxgl(center = c(-97.6, 25.4)) |>
  fly_to(
    center = c(-96.810481, 32.790869),
    zoom = 18.4,
    pitch = 75,
    bearing = 136.8
  )
```

## Using MapLibre GL JS

MapLibre GL JS (a permissive fork of Mapbox GL JS 1.0) is also available. Initialize with `maplibre()`. The default tiles are CARTO Voyager and require no API key:

```r
library(mapgl)

maplibre()
```

MapTiler tiles are available via `maptiler_style()` but need `MAPTILER_API_KEY` in `.Renviron`:

```r
maplibre(
  style = maptiler_style("bright"),
  center = c(-43.23412, -22.91370),
  zoom = 14
) |>
  add_fullscreen_control(position = "top-left") |>
  add_navigation_control()
```

Controls and styles work with both `maplibre()` and `mapboxgl()` -- a consistent API for either backend.

## Quick data visualization with view functions

`mapboxgl_view()` / `maplibre_view()` auto-detect data types and create visualizations with sensible defaults. They work with sf and terra objects; specifying `column` applies an appropriate scale.

```r
library(sf)
nc <- st_read(system.file("shape/nc.shp", package = "sf"))

maplibre_view(nc, column = "AREA")
```

Use `add_view()` to add a `*_view`-style styled layer onto an existing map when you want more control than a one-shot view.

## Comparing map views

`compare()` creates synced swipe maps for two styles, works with Mapbox and MapLibre:

```r
m1 <- mapboxgl()
m2 <- mapboxgl(mapbox_style("satellite-streets"))
compare(m1, m2)
```
