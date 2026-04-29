---
name: r-duckspatial
description: Use when code loads or uses duckspatial (library(duckspatial), duckspatial::), performing spatial joins or areal interpolation on large vector datasets in R, or needing faster spatial operations than sf
---

# duckspatial: Memory-Efficient Spatial Analysis

## Overview

**duckspatial** bridges R's sf ecosystem with DuckDB's spatial extension for memory-efficient analysis of large spatial datasets. Data stays in DuckDB until explicitly collected, enabling operations on datasets larger than RAM.

**Core principle:** Lazy evaluation keeps data outside R memory. Operations execute in DuckDB's query engine with optimization before results return.

## References

Read `references/API.md` before writing code.

- `references/API.md` - Complete function reference and spatial operations

## When to Use

- Dataset too large for sf to load into memory
- Spatial joins with millions of features
- Areal-weighted interpolation across large geographies
- Repeated spatial operations benefit from DuckDB's query optimization
- Working with spatial files larger than 1GB

## When NOT to Use

- Small datasets (<100K features) - sf is simpler
- Complex spatial topology operations not in DuckDB spatial extension
- Need GEOS-specific functionality (sf provides more geometry operations)
- Interactive spatial visualization - materialize with `collect()` first

## Quick Reference

| Operation                 | Function                                | Key Parameters             |
| ------------------------- | --------------------------------------- | -------------------------- |
| **Load file**             | `ddbs_open_dataset(path)`               | Returns lazy duckspatial_df|
| **Convert from sf**       | `as_duckspatial_df(sf_obj)`             | Registers sf as lazy table |
| **Materialize**           | `ddbs_collect()` or `st_as_sf()`        | Brings data into R memory  |
| **Spatial join**          | `ddbs_join(x, y, join, predicate)`      | join: left/inner/right/full|
| **Spatial filter**        | `ddbs_filter(x, y, predicate)`          | Subset by spatial relation |
| **Crop to extent**        | `ddbs_crop(x, y)`                       | Clip geometries to y extent|
| **Areal interpolation**   | `ddbs_interpolate_aw(x, y, values)`     | Weight by overlap area     |
| **Buffer**                | `ddbs_buffer(x, distance)`              | Distance in CRS units      |
| **Union/dissolve**        | `ddbs_union(x)`                         | Merge into single geometry |
| **Transform CRS**         | `ddbs_transform(x, crs)`                | EPSG code or proj4string   |
| **Validate**              | `ddbs_make_valid(x)`                    | Fix invalid geometries     |

**See `references/API.md` for complete function reference.**

## Core Pattern

```r
library(duckspatial)

# Load large dataset as lazy table (not in R memory)
buildings <- ddbs_open_dataset("buildings.gpkg")

# Or convert existing sf object
neighborhoods <- as_duckspatial_df(sf_neighborhoods)

# Chain operations - all happen in DuckDB
result <- buildings |>
  ddbs_make_valid() |>                    # Fix geometries
  ddbs_transform(crs = 32633) |>          # Reproject to UTM
  ddbs_join(neighborhoods,
            join = "left",
            predicate = "within") |>       # Spatial join
  ddbs_collect()                           # NOW bring into R memory

# Result is sf object, ready for plotting/further analysis
plot(result["neighborhood_name"])
```

## Common Workflows

### Spatial Join (Point-in-Polygon)

```r
# Points to polygons - find which polygon each point falls in
points <- ddbs_open_dataset("locations.geojson")
zones <- as_duckspatial_df(zone_boundaries)

joined <- ddbs_join(points, zones,
                    join = "left",
                    predicate = "within") |>
  ddbs_collect()
```

### Areal-Weighted Interpolation

```r
# Transfer population from census tracts to neighborhoods
census <- ddbs_open_dataset("census_tracts.gpkg")
neighborhoods <- as_duckspatial_df(neighborhoods_sf)

interpolated <- ddbs_interpolate_aw(
  census,
  neighborhoods,
  values = "population"  # Extensive variable (sums)
) |>
  ddbs_collect()
```

### Large File Processing

```r
# Process multi-GB shapefile without loading entirely
parcels <- ddbs_open_dataset("parcels_nationwide.shp")

city_parcels <- parcels |>
  ddbs_filter(study_area, predicate = "intersects") |>
  ddbs_make_valid() |>
  ddbs_simplify(tolerance = 0.5) |>
  ddbs_collect()
```

## Integration with sf and dplyr

```r
# duckspatial_df supports dplyr verbs
filtered <- buildings |>
  filter(height > 50) |>           # dplyr filter (attribute)
  mutate(area = ddbs_area(.)) |>   # Add geometry measurement
  ddbs_filter(downtown,            # Spatial filter
              predicate = "within")

# Support standard sf methods
crs_info <- st_crs(buildings)
bbox <- st_bbox(buildings)
geom_col <- st_geometry(buildings)
```

## Common Mistakes

| Mistake                        | Fix                                              |
| ------------------------------ | ------------------------------------------------ |
| Forgetting `ddbs_collect()`    | Data stays in DuckDB - call `collect()` to get sf|
| Not validating before union    | Always `ddbs_make_valid()` before `ddbs_union()` |
| Wrong CRS for measurements     | Transform to projected CRS before distance/area  |
| Mixing sf and duckspatial ops  | Convert with `as_duckspatial_df()` or `collect()`|
| Large dataset in `collect()`   | Filter/aggregate in DuckDB first, then collect   |

## Performance Characteristics

**When duckspatial is faster:**
- Spatial joins with >100K features per layer
- Operations on files >500MB
- Repeated queries (DuckDB caches and optimizes)
- Chained spatial operations (single optimized query plan)

**When sf is faster:**
- Small datasets (<100K features)
- Operations requiring immediate results
- Complex GEOS operations not in DuckDB spatial extension

**Memory pattern:**
```r
# BAD: Loads entire file into R memory
data <- st_read("huge_file.gpkg") |>
  st_filter(bbox)

# GOOD: Filters in DuckDB, only loads result
data <- ddbs_open_dataset("huge_file.gpkg") |>
  ddbs_intersects_extent(bbox) |>
  ddbs_collect()
```

## Gotchas

1. **First call overhead:** Initial `ddbs_open_dataset()` takes seconds for connection setup
2. **Lazy evaluation:** Operations don't execute until `collect()` - errors appear late
3. **Geometry validity:** Invalid geometries cause cryptic DuckDB errors - validate early
4. **CRS handling:** DuckDB spatial extension uses EPSG codes - proj4 strings may not work
5. **Non-persistent:** In-memory DuckDB discards data after session unless using file-backed connection

## Spatial Predicates Reference

| Predicate      | Meaning                                    | Use Case                    |
| -------------- | ------------------------------------------ | --------------------------- |
| `intersects`   | Geometries share any space                 | Most permissive, default    |
| `within`       | x completely inside y                      | Points in polygons          |
| `contains`     | x completely contains y                    | Find polygons containing pt |
| `covers`       | x covers y (boundary can touch)            | Relaxed containment         |
| `touches`      | Share boundary but not interior            | Adjacent polygons           |
| `overlaps`     | Share space but neither contains other     | Partial overlap             |
| `crosses`      | Geometries cross (lines)                   | Line intersections          |
| `equals`       | Spatially identical                        | Exact match                 |
| `disjoint`     | No spatial interaction                     | Exclusion filtering         |

## Real-World Impact

**Before (sf):** 45 minutes to spatial join 2M buildings to 500 neighborhoods, 32GB RAM
**After (duckspatial):** 3 minutes, 4GB RAM

**Pattern:** Operations scale sub-linearly with data size due to DuckDB's columnar storage and parallel execution.
