---
name: r-mapping
description: Use when code loads mapgl or freestiler, working with .pmtiles files, creating interactive maps in R, choosing between R mapping packages, or working with large spatial datasets for visualization
---

# R Mapping Ecosystem (Meta-Skill)

## Overview

**This is a meta-skill** that helps you choose the right R mapping workflow. The R mapping stack consists of 2 specialized packages that work together.

**Install both:** `install.packages(c("freestiler", "mapgl"))`

**API keys:** Mapbox styles require `MAPBOX_PUBLIC_TOKEN`; MapLibre works without keys (CARTO/OpenFreeMap)

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/integration-patterns.md` - How freestiler and mapgl work together

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>

## When to Use Which Package

| Package | Use When | Skill |
|---------|----------|-------|
| **freestiler** | Convert large spatial data (>10k features) to vector tiles | `/r-freestiler` |
| **mapgl** | Create interactive WebGL maps, add layers, build Shiny apps | `/r-mapgl` |

**REQUIRED:** After reading this skill, you MUST invoke the relevant sub-skill (`r-freestiler` or `r-mapgl`) before writing any code. If the task involves `.pmtiles` files, invoke `r-freestiler`. If the task involves map display, invoke `r-mapgl`. For pipelines, invoke both.

## When NOT to Use

- Simple marker maps (use leaflet)
- Static print maps (use tmap or ggplot2 + sf)
- Quick exploration of small datasets (use tmap_mode("view") or maplibre_view())
- Non-spatial data visualization (use ggplot2)

## Key Workflow Decisions

**Dataset size determines your path:**

| Features | Workflow | Reason |
|----------|----------|--------|
| <10k | sf → mapgl directly | Fast enough without tiling |
| 10k-100k | freestiler → mapgl | Smooth performance with tiles |
| >100k or >1GB | freestiler with streaming | Memory-efficient processing |

**Hosting context:**
- **Static hosting** (GitHub Pages, Netlify): freestiler PMTiles → mapgl
- **Shiny server**: Can use sf directly with mapgl, but consider tiles for large data

## Common Integration Patterns

### Small Dataset: Direct to Map

```r
library(mapgl)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"))

maplibre(style = carto_style("positron")) |>
  fit_bounds(nc) |>
  add_fill_layer(
    id = "counties",
    source = nc,
    fill_color = interpolate(
      column = "BIR74",
      values = c(500, 10000),
      stops = c("lightblue", "darkblue")
    )
  )
```

### Large Dataset: Tile → Map Pipeline

```r
library(freestiler)
library(mapgl)

# Step 1: Create tiles (run once)
freestile(
  input = large_sf,
  output = "tiles.pmtiles",
  layer_name = "features"
)

# Step 2: Serve and visualize
view_tiles("tiles.pmtiles")  # Quick preview

# Or manual control:
serve_tiles(path = dirname("tiles.pmtiles"))
maplibre() |>
  add_pmtiles_source(
    id = "src",
    url = "http://localhost:8080/tiles.pmtiles"
  ) |>
  add_fill_layer(
    source = "src",
    source_layer = "features",  # Must match layer_name
    fill_color = "steelblue"
  )
```

### Memory-Efficient Streaming (10M+ Features)

```r
library(freestiler)
library(duckdb)

# Process without loading into memory
freestile_query(
  query = "SELECT * FROM read_parquet('huge_spatial.parquet')",
  output = "massive.pmtiles",
  layer_name = "points",
  streaming = "always"  # Critical for large datasets
)
```

### Shiny App with Dynamic Filtering

```r
library(shiny)
library(mapgl)

ui <- fluidPage(
  selectInput("year", "Year", choices = 2010:2020),
  maplibreOutput("map", height = "600px")
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    maplibre(style = carto_style("positron")) |>
      add_pmtiles_source(id = "data", url = "tiles.pmtiles") |>
      add_circle_layer(
        id = "points",
        source = "data",
        source_layer = "features"
      )
  })

  observeEvent(input$year, {
    maplibre_proxy("map") |>
      set_filter(
        "points",
        list("==", list("get", "year"), input$year)
      )
  })
}
```

## Decision Tree

```
Start: Need to map spatial data
├─ <10k features?
│  └─ YES → Use mapgl directly with sf source
├─ 10k-1M features?
│  └─ YES → freestiler (default settings) → mapgl
├─ >1M features OR >500MB file?
│  └─ YES → freestiler with streaming → mapgl
└─ Need static hosting?
   └─ YES → freestiler PMTiles → mapgl (no server needed)
```

## Critical Integration Points

1. **CRS must match:** Transform to WGS84 before tiling: `st_transform(data, 4326)`
2. **Layer names must align:** `layer_name` in freestiler = `source_layer` in mapgl
3. **Server for local development:** Use `view_tiles()` for quick preview, or `serve_tiles()` + mapgl for custom control
4. **File paths:** PMTiles can use `file://` URLs with absolute paths in mapgl

## Common Mistakes

1. **Wrong workflow order:** Don't tile small datasets; don't pass huge sf objects to mapgl
2. **Missing streaming flag:** Add `streaming = "always"` for datasets >10M features
3. **Layer name mismatch:** `freestile(layer_name = "x")` requires `add_*_layer(source_layer = "x")`
4. **Server requirements:** Python's http.server doesn't support PMTiles; use Node's http-server or freestiler's built-in server
5. **CRS assumptions:** Always verify and transform to EPSG:4326

## Advanced

See `references/` for:
- **integration-patterns.md**: Production workflows, Shiny patterns, multi-layer maps, troubleshooting

For package-specific documentation, invoke the individual skills:
- **r-freestiler:** Tile generation, SQL queries, zoom strategies
- **r-mapgl:** Layer styling, Shiny integration, 3D terrain, interactive controls
