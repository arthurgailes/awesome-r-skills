# Workflows

## Large Dataset Pipeline

Typical workflow for enterprise datasets (100k-1B features):

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
    FROM read_parquet('../data/enterprise.parquet')  # Can use relative paths
    WHERE value > 0  -- Filter early
  ",
  output = "tiles/enterprise.pmtiles",
  layer_name = "features",
  streaming = "always",  # For large datasets
  min_zoom = 4,
  max_zoom = 12,
  tile_format = "mlt"  # Smaller files
)

# 3. Serve locally for development
# npx http-server tiles

# 4. Visualize with mapgl (needs absolute path)
maplibre(style = carto_style("positron")) |>
  add_pmtiles_source(
    id = "enterprise",
    url = "file://W:/project/tiles/enterprise.pmtiles"  # Absolute required here
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

## Multi-Layer Tilesets

```r
# Combine multiple datasets with different zoom ranges
freestile(
  input = list(
    freestile_layer(states, "states", min_zoom = 0, max_zoom = 6),
    freestile_layer(counties, "counties", min_zoom = 4, max_zoom = 10),
    freestile_layer(blocks, "blocks", min_zoom = 8, max_zoom = 14)
  ),
  output = "multilayer.pmtiles"
)
```

## Local Server for Viewing

PMTiles require HTTP range requests:

```bash
# In project directory
npx http-server
```
