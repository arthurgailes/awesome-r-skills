---
name: r-freestiler
description: Use when creating PMTiles vector tilesets from large spatial datasets, serving vector tiles from static hosting, or preparing spatial data for mapgl visualization
---

# freestiler: Vector Tile Generator

## Overview

**freestiler converts spatial data into PMTiles vector tilesets.** Rust-powered tool for creating `.pmtiles` from sf objects, files, or DuckDB SQL.

## When to Use

**Use when:**
- Dataset >10k features (too large for direct mapgl)
- Need static hosting
- Dataset exceeds memory

**Don't use:**
- <10k features - pass sf to mapgl directly
- Quick exploration - use `maplibre_view()`
- Existing tile pipeline works

## Quick Reference

| Function | Use Case | Key Params |
|----------|----------|------------|
| `freestile()` | Tile sf objects | `input`, `output`, `layer_name`, `min_zoom`, `max_zoom` |
| `freestile_query()` | Tile from SQL (streaming) | `query`, `output`, `layer_name`, `streaming = "always"` |
| `freestile_file()` | Tile without loading | `input`, `output`, `layer_name` |
| `freestile_layer()` | Multi-layer specs | Per-layer zoom configuration |

## Quick Start

```r
library(freestiler)
library(sf)

# Basic: sf object to PMTiles
nc <- st_read(system.file("shape/nc.shp", package = "sf"))
freestile(input = nc, output = "nc.pmtiles", layer_name = "counties",
          min_zoom = 4, max_zoom = 12)

# Large datasets: streaming
freestile_query(
  query = "SELECT * FROM read_parquet('huge.parquet')",
  output = "points.pmtiles",
  layer_name = "locations",
  streaming = "always",  # Critical for 10M+ points
  min_zoom = 0, max_zoom = 14
)

# Direct file (no loading)
freestile_file(input = "data.gpkg", output = "output.pmtiles",
               layer_name = "features")
```

## mapgl Integration

```r
# Create tiles
freestile(input = data, output = "data.pmtiles", layer_name = "layer1")

# Visualize (absolute path required)
maplibre() |>
  add_pmtiles_source(id = "src", url = "file://W:/project/data.pmtiles") |>
  add_fill_layer(source = "src", source_layer = "layer1")
```

## Common Gotchas

1. **Parameter names:** Use `input`, `output`, `layer_name` (NOT `data`, `tileset`, `layer`)
   ```r
   # Correct
   freestile(input = nc, output = "nc.pmtiles", layer_name = "counties")

   # Wrong - these parameter names don't exist
   freestile(data = nc, tileset = "nc.pmtiles", layer = "counties")
   ```

2. **freestile() accepts relative paths, mapgl needs absolute:**
   ```r
   # Creating tiles - relative works
   freestile(input = nc, output = "nc.pmtiles", layer_name = "counties")

   # Viewing - MUST use absolute with file://
   add_pmtiles_source(url = "file://W:/project/nc.pmtiles")  # Correct
   add_pmtiles_source(url = "nc.pmtiles")  # Won't work
   ```

3. **Source layer name must match:**
   ```r
   freestile(input = data, output = "out.pmtiles", layer_name = "mylayer")
   add_fill_layer(..., source_layer = "mylayer")  # Must match exactly
   ```

4. **CRS must be WGS84:** Transform before tiling
   ```r
   data |> st_transform(4326) |> freestile(input = _, output = ...)
   ```

5. **Memory with large sf:** Use `freestile_query()` or `freestile_file()` instead
   ```r
   # Don't: data <- st_read("huge.gpkg"); freestile(input = data, ...)
   # Do: freestile_file(input = "huge.gpkg", ...)
   ```

6. **Streaming for massive points:** Critical for 10M+ features
   ```r
   freestile_query(..., streaming = "always")
   ```

## Advanced

See `references/` for:
- **API.md**: Complete function reference
- Workflows, zoom strategy, SQL patterns, performance tips

**Resources:** [Docs](https://walker-data.com/freestiler/) | [GitHub](https://github.com/walkerke/freestiler/) | See `r-mapgl` skill
