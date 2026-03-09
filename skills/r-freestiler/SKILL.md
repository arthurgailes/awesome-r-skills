---
name: r-freestiler
description: Use when creating PMTiles vector tilesets from large spatial datasets, serving vector tiles from static hosting, or preparing spatial data for mapgl visualization
---

# freestiler: Vector Tile Generator

## Overview

**freestiler converts spatial data into PMTiles vector tilesets.** It's a Rust-powered in-process tool that creates single `.pmtiles` files from sf objects, disk files, or DuckDB SQL queries. No additional installations required.

## When to Use freestiler

**Use freestiler when:**
- Creating vector tilesets for web maps (PMTiles format)
- Dataset is too large for mapgl to handle directly (>10k-100k features depending on complexity)
- Need to serve tiles from static hosting (no tile server)
- Want R-native workflow for tile generation
- Dataset too large for memory (use streaming mode)

**Don't use freestiler when:**
- Small datasets (<10k features) - pass sf objects directly to mapgl instead
- Quick exploratory visualization - use `maplibre_view(sf_object)`
- Not building web maps - use ggplot2/tmap/leaflet for other use cases
- Already have working tile pipeline (tippecanoe, etc.)

**vs tippecanoe:** Both create vector tiles. Use freestiler for R-native workflow; use tippecanoe if you need command-line integration or more tile format options.

**Key advantage:** Handles datasets too large for memory via streaming (e.g., 146M points in ~12 minutes).

## Installation

```r
# Via r-universe (recommended)
install.packages("freestiler",
  repos = c("https://walkerke.r-universe.dev",
            "https://cloud.r-project.org"))

# Via GitHub
devtools::install_github("walkerke/freestiler")
```

## Quick Start

### Basic: sf object to PMTiles

```r
library(freestiler)
library(sf)

# Tile sf object
nc <- st_read(system.file("shape/nc.shp", package = "sf"))

freestile(
  data = nc,
  tileset = "W:/path/to/nc.pmtiles",
  layer = "counties",
  min_zoom = 4,
  max_zoom = 12
)
```

### Large datasets: DuckDB streaming

```r
# Stream 146M points without loading into memory
freestile_query(
  query = "SELECT * FROM read_parquet('huge_points.parquet')",
  tileset = "W:/path/to/points.pmtiles",
  layer = "locations",
  streaming = "always",  # Critical for massive point datasets
  min_zoom = 0,
  max_zoom = 14
)
```

### Direct file input

```r
# Tile without loading into R
freestile_file(
  input = "W:/path/to/data.gpkg",
  tileset = "W:/path/to/output.pmtiles",
  layer = "features",
  min_zoom = 4,
  max_zoom = 10
)
```

### Multi-layer tilesets

```r
# Combine multiple datasets with different zoom ranges
freestile(
  data = list(
    freestile_layer(states, "states", min_zoom = 0, max_zoom = 6),
    freestile_layer(counties, "counties", min_zoom = 4, max_zoom = 10),
    freestile_layer(blocks, "blocks", min_zoom = 8, max_zoom = 14)
  ),
  tileset = "W:/path/to/multilayer.pmtiles"
)
```

## Core Functions

| Function | Use Case | Key Params |
|----------|----------|------------|
| `freestile()` | Tile sf objects | `data`, `tileset`, `layer`, `min_zoom`, `max_zoom` |
| `freestile_query()` | Tile from SQL (streaming) | `query`, `streaming = "always"` for large data |
| `freestile_file()` | Tile without loading | `input` (GeoParquet, GPKG, SHP) |
| `freestile_layer()` | Multi-layer specs | Per-layer zoom configuration |

## Integration with mapgl

**Freestiler creates PMTiles → mapgl displays them:**

```r
library(mapgl)
library(freestiler)

# 1. Create tiles
freestile(large_data, "data.pmtiles", "layer1", min_zoom = 4, max_zoom = 12)

# 2. Visualize with mapgl
maplibre(style = carto_style("positron")) |>
  add_pmtiles_source(
    id = "data_source",
    url = "file://W:/path/to/data.pmtiles"  # Absolute path required
  ) |>
  add_fill_layer(
    id = "polygons",
    source = "data_source",
    source_layer = "layer1",  # Must match layer name from freestile()
    fill_color = "steelblue",
    fill_opacity = 0.7
  )
```

## Tile Format: MLT vs MVT

**Default: MapLibre Tiles (MLT)**
- Columnar encoding
- Smaller files for polygons/lines
- Requires MapLibre GL viewer

**Alternative: Mapbox Vector Tiles (MVT)**
```r
freestile(data, "output.pmtiles", "layer", tile_format = "mvt")
```
- Broader viewer compatibility
- Larger file size
- Use when viewer compatibility matters over efficiency

## Zoom Level Strategy

**General guidance:**
- `min_zoom`: When features first become visible (lower = visible sooner = larger file)
- `max_zoom`: Maximum detail level (higher = more detail = larger file)
- `base_zoom`: Optimization hint (typically max_zoom - 1)

**Examples by geometry:**
```r
# Large polygons (states, countries)
freestile(states, "states.pmtiles", "states",
          min_zoom = 0, max_zoom = 6)

# Medium polygons (counties)
freestile(counties, "counties.pmtiles", "counties",
          min_zoom = 4, max_zoom = 10)

# Small features (buildings, blocks)
freestile(blocks, "blocks.pmtiles", "blocks",
          min_zoom = 8, max_zoom = 14)

# Points (variable density)
freestile(points, "points.pmtiles", "points",
          min_zoom = 0, max_zoom = 14)
```

## Common Gotchas

1. **Absolute paths required:** PMTiles in mapgl need full paths, not relative
   ```r
   # Good
   url = "file://W:/project/data.pmtiles"

   # Bad (won't work)
   url = "data.pmtiles"
   ```

2. **Source layer name must match:**
   ```r
   freestile(data, "out.pmtiles", layer = "mylayer")
   # Later in mapgl:
   add_fill_layer(..., source_layer = "mylayer")  # Must match exactly
   ```

3. **Local server for viewing:** PMTiles require HTTP range requests
   ```bash
   # In project directory
   npx http-server
   ```

4. **CRS must be WGS84:** Transform before tiling
   ```r
   data |> st_transform(4326) |> freestile(...)
   ```

5. **Memory with large sf:** Use `freestile_query()` or `freestile_file()` instead
   ```r
   # Don't load huge files into R first
   # Instead of: data <- st_read("huge.gpkg"); freestile(data, ...)
   # Use: freestile_file("huge.gpkg", ...)
   ```

6. **Streaming for massive points:**
   ```r
   # Critical for 10M+ points
   freestile_query(..., streaming = "always")
   ```

## SQL Preprocessing Patterns

**Filter before tiling to reduce output size:**

```r
# Filter by bounding box
freestile_query(
  query = "
    SELECT * FROM read_parquet('data.parquet')
    WHERE lon BETWEEN -100 AND -90
      AND lat BETWEEN 30 AND 40
  ",
  tileset = "filtered.pmtiles",
  layer = "subset"
)

# Join and aggregate
freestile_query(
  query = "
    SELECT
      g.geom,
      g.id,
      COUNT(p.id) as point_count
    FROM read_parquet('grid.parquet') g
    LEFT JOIN read_parquet('points.parquet') p
      ON ST_Within(p.geom, g.geom)
    GROUP BY g.geom, g.id
  ",
  tileset = "aggregated.pmtiles",
  layer = "grid"
)
```

## Performance Tips

1. **File format matters:** GeoParquet > GeoPackage > Shapefile for large data
2. **Filter early:** Use SQL to reduce data before tiling
3. **Optimize zoom ranges:** Don't tile beyond necessary detail level
4. **Multi-layer strategy:** Separate geometries by scale (states at low zoom, blocks at high zoom)
5. **Streaming flag:** Use `streaming = "always"` for point datasets >10M features

## Workflow: Large Dataset Pipeline

**Typical workflow for enterprise datasets (100k-1B features):**

```r
# 1. Store data efficiently
# Use GeoParquet or DuckDB database

# 2. Tile with appropriate strategy
freestile_query(
  query = "
    SELECT
      geometry,
      id,
      category,
      value
    FROM read_parquet('W:/data/enterprise.parquet')
    WHERE value > 0  -- Filter early
  ",
  tileset = "W:/project/tiles/enterprise.pmtiles",
  layer = "features",
  streaming = "always",  # For large datasets
  min_zoom = 4,
  max_zoom = 12,
  tile_format = "mlt"  # Smaller files
)

# 3. Serve locally for development
# npx http-server W:/project/tiles

# 4. Visualize with mapgl
maplibre(style = carto_style("positron")) |>
  add_pmtiles_source(
    id = "enterprise",
    url = "file://W:/project/tiles/enterprise.pmtiles"
  ) |>
  add_fill_layer(
    id = "features",
    source = "enterprise",
    source_layer = "features",
    fill_color = interpolate(
      column = "value",
      values = c(0, 100),
      stops = c("yellow", "red")
    )
  )
```

## When to Use Each Function

```r
# Use freestile() when:
# - Data already in R as sf object
# - <1M features
# - No preprocessing needed
nc <- st_read("nc.shp")
freestile(nc, "nc.pmtiles", "counties")

# Use freestile_file() when:
# - Large file you don't need to load
# - Simple file-to-tiles conversion
# - GeoParquet, GPKG, SHP input
freestile_file("large.gpkg", "output.pmtiles", "layer")

# Use freestile_query() when:
# - Need SQL preprocessing
# - Filtering/joining before tiling
# - Streaming massive point datasets
freestile_query(
  "SELECT * FROM read_parquet('huge.parquet') WHERE condition",
  "output.pmtiles",
  "layer",
  streaming = "always"
)

# Use freestile() with freestile_layer() when:
# - Multiple datasets at different zoom levels
# - Hierarchical display (states -> counties -> blocks)
freestile(
  list(
    freestile_layer(states, "states", 0, 6),
    freestile_layer(counties, "counties", 4, 10)
  ),
  "multi.pmtiles"
)
```

## Resources

- **Documentation:** https://walker-data.com/freestiler/
- **GitHub:** https://github.com/walkerke/freestiler/
- **PMTiles spec:** https://github.com/protomaps/PMTiles
- **Integration:** See `r-mapgl` skill for visualization patterns
