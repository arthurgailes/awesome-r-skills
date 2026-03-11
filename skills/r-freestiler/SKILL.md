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

| Function            | Use Case                  | Key Params                                                             |
| ------------------- | ------------------------- | ---------------------------------------------------------------------- |
| `freestile()`       | Tile sf objects           | `input`, `output`, `layer_name`, `min_zoom`, `max_zoom`, `tile_format` |
| `freestile_query()` | Tile from SQL (streaming) | `query`, `output`, `layer_name`, `streaming = "always"`                |
| `freestile_file()`  | Tile without loading      | `input`, `output`, `layer_name`, `engine`                              |
| `freestile_layer()` | Multi-layer specs         | Per-layer zoom configuration                                           |
| `view_tiles()`      | Quick visualization       | `input`, `layer`, `layer_type`, `color`                                |
| `serve_tiles()`     | Start local server        | `path`, `port`                                                         |
| `stop_server()`     | Stop local server         | None                                                                   |

## Quick Start

```r
library(freestiler)
library(sf)

# Basic: sf object to PMTiles
nc <- st_read(system.file("shape/nc.shp", package = "sf"))
freestile(input = nc, output = "nc.pmtiles", layer_name = "counties",
          min_zoom = 4, max_zoom = 12)

# Quick visualization (easiest way to view)
view_tiles("nc.pmtiles")  # Auto-starts server + opens map

# Customize visualization
view_tiles("roads.pmtiles", layer_type = "line", color = "red", opacity = 0.8)

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

## Visualization Options

### Option 1: view_tiles() (Easiest)

```r
# Create and instantly view tiles
freestile(input = nc, output = "nc.pmtiles", layer_name = "counties")
view_tiles("nc.pmtiles")  # Auto-launches server + opens map

# Customize
view_tiles("data.pmtiles", layer_type = "fill", color = "navy", opacity = 0.6)
```

### Option 2: Manual Server + mapgl

```r
# Start server for directory of tiles
serve_tiles("W:/project/tiles/")

# Use in mapgl with http:// URL
maplibre() |>
  add_pmtiles_source(id = "src", url = "http://localhost:8080/data.pmtiles") |>
  add_fill_layer(source = "src", source_layer = "layer1")

# Stop when done
stop_server()
```

### Option 3: Direct file:// (No Server)

```r
# For local files without server (requires absolute path)
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

2. **Prefer view_tiles() for quick visualization:**

   ```r
   # Easiest - handles server automatically
   freestile(input = nc, output = "nc.pmtiles", layer_name = "counties")
   view_tiles("nc.pmtiles")  # Correct - just works

   # Manual mapgl - file:// needs absolute path
   add_pmtiles_source(url = "file://W:/project/nc.pmtiles")  # Works
   add_pmtiles_source(url = "nc.pmtiles")  # Won't work

   # Manual mapgl - http:// needs serve_tiles() first
   serve_tiles("nc.pmtiles")
   add_pmtiles_source(url = "http://localhost:8080/nc.pmtiles")  # Works
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

7. **Tile format defaults to MLT:** MapLibre Tiles (MLT) is now default, producing smaller files

   ```r
   # Default: MLT format (smaller files)
   freestile(input = data, output = "out.pmtiles", layer_name = "layer")

   # Explicit MVT for compatibility (recommended for Python viewers)
   freestile(input = data, output = "out.pmtiles", layer_name = "layer",
             tile_format = "mvt")
   ```

8. **Serving larger tilesets (>1GB):** Built-in `serve_tiles()` works for files up to ~1GB. For larger files, use external server:

   ```bash
   npx http-server /path/to/tiles -p 8082 --cors -c-1
   ```

   Then use `http://localhost:8082/file.pmtiles` in `add_pmtiles_source()`. B

   **Important:** Python's `http.server` module does NOT support byte-range requests and won't work for PMTiles.

## Advanced

See `references/` for:

- **API.md**: Complete function reference
- Workflows, zoom strategy, SQL patterns, performance tips

**Resources:** [Docs](https://walker-data.com/freestiler/) | [GitHub](https://github.com/walkerke/freestiler/) | See `r-mapgl` skill
