# Zoom Level Strategy

## General Guidance

- `min_zoom`: When features first become visible (lower = visible sooner = larger file)
- `max_zoom`: Maximum detail level (higher = more detail = larger file)
- `base_zoom`: Optimization hint (typically max_zoom - 1)

## Examples by Geometry Type

```r
# Large polygons (states, countries)
freestile(input = states, output = "states.pmtiles", layer_name = "states",
          min_zoom = 0, max_zoom = 6)

# Medium polygons (counties)
freestile(input = counties, output = "counties.pmtiles", layer_name = "counties",
          min_zoom = 4, max_zoom = 10)

# Small features (buildings, blocks)
freestile(input = blocks, output = "blocks.pmtiles", layer_name = "blocks",
          min_zoom = 8, max_zoom = 14)

# Points (variable density)
freestile(input = points, output = "points.pmtiles", layer_name = "points",
          min_zoom = 0, max_zoom = 14)
```

## Tile Format: MLT vs MVT

**Default: MapLibre Tiles (MLT)**
- Columnar encoding
- Smaller files for polygons/lines
- Requires MapLibre GL viewer

**Alternative: Mapbox Vector Tiles (MVT)**
```r
freestile(input = data, output = "output.pmtiles", layer_name = "layer",
          tile_format = "mvt")
```
- Broader viewer compatibility
- Larger file size
- Use when viewer compatibility matters over efficiency
