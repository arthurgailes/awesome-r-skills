# duckspatial API Reference

Complete function reference for the duckspatial package.

## Setup and Connection

### ddbs_create_conn()
Creates a DuckDB connection with spatial extension loaded.

**Returns:** DuckDB connection object

**Usage:**
```r
conn <- ddbs_create_conn()
```

### ddbs_stop_conn(conn)
Closes an active DuckDB connection.

**Parameters:**
- `conn`: DuckDB connection object

### ddbs_install()
Verifies and installs the DuckDB Spatial extension if not present.

### ddbs_load(conn)
Activates the Spatial extension on a connection.

**Parameters:**
- `conn`: DuckDB connection object

### ddbs_options()
Retrieves or modifies global duckspatial settings.

**Returns:** List of current options

### ddbs_set_resources(conn, ...) / ddbs_get_resources(conn)
Manages connection resource allocation (memory, threads).

**Parameters:**
- `conn`: DuckDB connection object
- `...`: Resource parameters (memory_limit, threads, etc.)

### ddbs_sitrep()
Displays duckspatial configuration information and diagnostics.

## Data Import/Export

### ddbs_open_dataset(path, ...)
Loads spatial dataset as lazy table without materializing into memory.

**Parameters:**
- `path`: File path to spatial data (GeoPackage, Shapefile, GeoJSON, etc.)
- `...`: Additional GDAL options

**Returns:** duckspatial_df object (lazy)

**Usage:**
```r
data <- ddbs_open_dataset("path/to/file.geojson")
```

### ddbs_read_table(conn, table_name)
Retrieves vectorial table from DuckDB into R environment as sf object.

**Parameters:**
- `conn`: DuckDB connection
- `table_name`: Name of table to read

**Returns:** sf object

### ddbs_write_dataset(x, path, ...)
Exports spatial dataset to disk storage.

**Parameters:**
- `x`: duckspatial_df or sf object
- `path`: Output file path
- `...`: GDAL driver options

### ddbs_write_table(x, conn, table_name, ...)
Persists sf object to DuckDB database table.

**Parameters:**
- `x`: sf object
- `conn`: DuckDB connection
- `table_name`: Name for new table
- `...`: Additional options

### ddbs_register_table(x, conn, table_name)
Registers sf object as Arrow Table in DuckDB for zero-copy access.

**Parameters:**
- `x`: sf object
- `conn`: DuckDB connection
- `table_name`: Name for registered table

## Lazy Spatial Data Frames

### as_duckspatial_df(x, ...)
Converts sf object to lazy duckspatial_df format.

**Parameters:**
- `x`: sf object
- `...`: Additional parameters

**Returns:** duckspatial_df object

**Usage:**
```r
lazy_data <- as_duckspatial_df(sf_object)
```

### is_duckspatial_df(x)
Tests if object is a duckspatial_df.

**Parameters:**
- `x`: Object to test

**Returns:** Logical

### ddbs_collect(x) / collect(x)
Materializes lazy results into R memory as sf object.

**Parameters:**
- `x`: duckspatial_df object

**Returns:** sf object

**Usage:**
```r
result <- lazy_data |>
  ddbs_make_valid() |>
  ddbs_collect()
```

### ddbs_compute(x, ...)
Forces lazy evaluation and caches result in DuckDB.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df object (computed)

### ddbs_geom_col(x)
Identifies the geometry column name.

**Parameters:**
- `x`: duckspatial_df object

**Returns:** Character string

## Spatial Predicates

All spatial predicate functions test relationships between geometries.

### ddbs_predicate(x, y, predicate, ...)
Generic spatial relationship testing.

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `predicate`: Relationship type ("intersects", "contains", "within", etc.)
- `...`: Additional parameters

**Returns:** Logical vector or duckspatial_df

### Predicate Functions
All follow pattern: `ddbs_<predicate>(x, y, ...)`

- `ddbs_intersects()` - Geometries share any space
- `ddbs_covers()` - x completely covers y (boundary can touch)
- `ddbs_touches()` - Geometries share boundary but not interior
- `ddbs_within()` - x is completely inside y
- `ddbs_contains()` - x completely contains y
- `ddbs_overlaps()` - Geometries overlap but neither contains the other
- `ddbs_crosses()` - Geometries cross (for lines)
- `ddbs_equals()` - Geometries are spatially equal
- `ddbs_disjoint()` - Geometries do not interact

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `...`: Additional parameters

**Returns:** Logical vector or filtered duckspatial_df

### ddbs_is_within_distance(x, y, distance, ...)
Tests if geometries are within specified distance.

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `distance`: Numeric distance threshold
- `...`: Additional parameters

**Returns:** Logical vector or filtered duckspatial_df

### ddbs_intersects_extent(x, extent, ...)
Tests if geometries intersect with bounding box.

**Parameters:**
- `x`: duckspatial_df object
- `extent`: Bounding box (xmin, ymin, xmax, ymax)
- `...`: Additional parameters

**Returns:** Filtered duckspatial_df

## Spatial Joins and Filters

### ddbs_join(x, y, join = "inner", predicate = "intersects", ...)
Combines geometries based on spatial relationships.

**Parameters:**
- `x`: duckspatial_df object (left)
- `y`: duckspatial_df or sf object (right)
- `join`: Join type ("inner", "left", "right", "full")
- `predicate`: Spatial relationship ("intersects", "within", "contains", etc.)
- `...`: Additional parameters

**Returns:** duckspatial_df with combined attributes

**Usage:**
```r
result <- ddbs_join(points, polygons,
                    join = "left",
                    predicate = "within")
```

### ddbs_filter(x, y, predicate = "intersects", ...)
Subsets x to features that match spatial criteria with y.

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `predicate`: Spatial relationship
- `...`: Additional parameters

**Returns:** Filtered duckspatial_df

### ddbs_intersection(x, y, ...)
Computes geometric intersection of x and y.

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `...`: Additional parameters

**Returns:** duckspatial_df with intersection geometries

### ddbs_difference(x, y, ...)
Computes geometric difference (x minus y).

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `...`: Additional parameters

**Returns:** duckspatial_df with difference geometries

### ddbs_sym_difference(x, y, ...)
Computes symmetric difference (parts unique to each).

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `...`: Additional parameters

**Returns:** duckspatial_df with symmetric difference geometries

### ddbs_interpolate_aw(x, y, values, ...)
Performs areal-weighted interpolation from x to y geometries.

**Parameters:**
- `x`: duckspatial_df source polygons
- `y`: duckspatial_df target polygons
- `values`: Column name(s) to interpolate
- `...`: Additional parameters (extensive vs intensive variables)

**Returns:** duckspatial_df with interpolated values

**Usage:**
```r
result <- ddbs_interpolate_aw(census_tracts, neighborhoods,
                              values = "population")
```

## Geometry Construction

### ddbs_as_spatial(x, coords, crs = 4326, ...)
Creates point geometries from coordinate columns.

**Parameters:**
- `x`: Data frame or duckspatial_df
- `coords`: Character vector of coordinate column names (e.g., c("lon", "lat"))
- `crs`: Coordinate reference system (default: WGS84)
- `...`: Additional parameters

**Returns:** duckspatial_df with point geometries

**Usage:**
```r
points <- data |>
  ddbs_as_spatial(coords = c("longitude", "latitude"))
```

### ddbs_generate_points(x, n, ...)
Produces n random points within each feature's bounding box.

**Parameters:**
- `x`: duckspatial_df object
- `n`: Number of points per feature
- `...`: Additional parameters

**Returns:** duckspatial_df with point geometries

### ddbs_quadkey(x, level, ...)
Converts point geometries to QuadKey tile identifiers (Bing Maps tiles).

**Parameters:**
- `x`: duckspatial_df with point geometries
- `level`: Zoom level (0-23)
- `...`: Additional parameters

**Returns:** duckspatial_df with quadkey column

## Geometry Processing

### ddbs_boundary(x, ...)
Extracts geometry boundary (perimeter).

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with boundary geometries

### ddbs_buffer(x, distance, ...)
Creates buffer zones around geometries.

**Parameters:**
- `x`: duckspatial_df object
- `distance`: Buffer distance in CRS units
- `...`: Additional parameters (num_segments, etc.)

**Returns:** duckspatial_df with buffered geometries

**Usage:**
```r
buffered <- points |> ddbs_buffer(distance = 1000)  # 1km buffer
```

### ddbs_build_area(x, ...)
Assembles polygons from multiple linestrings.

**Parameters:**
- `x`: duckspatial_df with linestring geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with polygon geometries

### ddbs_centroid(x, ...)
Calculates geometric center points.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with point geometries at centroids

### ddbs_concave_hull(x, ...) / ddbs_convex_hull(x, ...)
Computes minimum enclosing shapes.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters (concavity for concave_hull)

**Returns:** duckspatial_df with hull geometries

### ddbs_endpoint(x, ...)
Retrieves last point of linestring geometries.

**Parameters:**
- `x`: duckspatial_df with linestring geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with point geometries

### ddbs_exterior_ring(x, ...)
Extracts outer boundary of polygon geometries.

**Parameters:**
- `x`: duckspatial_df with polygon geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with linestring geometries

### ddbs_make_polygon(x, ...)
Creates polygon from closed linestring.

**Parameters:**
- `x`: duckspatial_df with closed linestring geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with polygon geometries

### ddbs_polygonize(x, ...)
Assembles polygons from linestring networks.

**Parameters:**
- `x`: duckspatial_df with linestring geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with polygon geometries

### ddbs_union(x, ...) / ddbs_union_agg(x, ...)
Dissolves geometries into single multipolygon or geometry collection.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with dissolved geometries

**Usage:**
```r
dissolved <- polygons |>
  ddbs_make_valid() |>
  ddbs_union()
```

### ddbs_combine(x, ...)
Combines geometries without dissolving boundaries.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with combined geometries

### ddbs_voronoi(x, ...)
Generates Voronoi diagram from point geometries.

**Parameters:**
- `x`: duckspatial_df with point geometries
- `...`: Additional parameters

**Returns:** duckspatial_df with Voronoi polygon geometries

## Coordinate Operations

### ddbs_transform(x, crs, ...)
Converts between coordinate reference systems.

**Parameters:**
- `x`: duckspatial_df object
- `crs`: Target CRS (EPSG code or proj4string)
- `...`: Additional parameters

**Returns:** duckspatial_df in new CRS

**Usage:**
```r
# Transform to UTM Zone 33N
utm <- data |> ddbs_transform(crs = 32633)
```

### ddbs_flip_coordinates(x, ...)
Swaps X and Y coordinate axes.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with flipped coordinates

## Geometry Validation

### ddbs_geometry_type(x, ...)
Identifies geometry type for each feature.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Character vector of geometry types

### ddbs_make_valid(x, ...)
Repairs invalid geometries using ST_MakeValid.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with valid geometries

**Usage:**
```r
# Always validate before union operations
valid_data <- data |> ddbs_make_valid()
```

### ddbs_simplify(x, tolerance, ...)
Reduces geometry complexity using Douglas-Peucker algorithm.

**Parameters:**
- `x`: duckspatial_df object
- `tolerance`: Simplification tolerance in CRS units
- `...`: Additional parameters

**Returns:** duckspatial_df with simplified geometries

**Usage:**
```r
simplified <- polygons |> ddbs_simplify(tolerance = 100)
```

### Validation Check Functions

All return logical vectors:

- `ddbs_is_simple(x, ...)` - Geometry has no self-intersections
- `ddbs_is_valid(x, ...)` - Geometry is topologically valid
- `ddbs_is_closed(x, ...)` - Linestring start equals end
- `ddbs_is_empty(x, ...)` - Geometry is empty
- `ddbs_is_ring(x, ...)` - Linestring is simple and closed

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Logical vector

### Dimension Check Functions

- `ddbs_has_z(x, ...)` - Geometry has Z coordinate
- `ddbs_has_m(x, ...)` - Geometry has M coordinate

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Logical vector

### Dimension Forcing Functions

- `ddbs_force_2d(x, ...)` - Removes Z and M coordinates
- `ddbs_force_3d(x, ...)` - Ensures Z coordinate (adds 0 if missing)
- `ddbs_force_4d(x, ...)` - Ensures Z and M coordinates

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with specified dimensions

## Format Conversion

### ddbs_as_text(x, ...)
Exports geometries to WKT (Well-Known Text) format.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Character vector of WKT strings

### ddbs_as_wkb(x, ...)
Exports geometries to WKB (Well-Known Binary) format.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** List of raw vectors

### ddbs_as_hexwkb(x, ...)
Exports geometries to hexadecimal WKB format.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Character vector of hex strings

### ddbs_as_geojson(x, ...)
Exports geometries to GeoJSON format.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Character vector of GeoJSON strings

## Spatial Extent and Boundaries

### ddbs_bbox(x, ...)
Retrieves minimum bounding rectangle for each feature.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Data frame with xmin, ymin, xmax, ymax columns

### ddbs_envelope(x, ...)
Extracts axis-aligned bounding box as geometry.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** duckspatial_df with polygon bounding boxes

## Affine Transformations

### ddbs_flip(x, axis, ...)
Mirrors geometries along specified axis.

**Parameters:**
- `x`: duckspatial_df object
- `axis`: "x" or "y"
- `...`: Additional parameters

**Returns:** duckspatial_df with flipped geometries

### ddbs_rotate(x, angle, ...)
Rotates geometries around centroid.

**Parameters:**
- `x`: duckspatial_df object
- `angle`: Rotation angle in degrees
- `...`: Additional parameters

**Returns:** duckspatial_df with rotated geometries

### ddbs_rotate_3d(x, angle, axis, ...)
Rotates 3D geometries along specified axis.

**Parameters:**
- `x`: duckspatial_df object
- `angle`: Rotation angle in degrees
- `axis`: "x", "y", or "z"
- `...`: Additional parameters

**Returns:** duckspatial_df with rotated 3D geometries

### ddbs_scale(x, factor, ...)
Resizes geometries by scale factor(s).

**Parameters:**
- `x`: duckspatial_df object
- `factor`: Numeric scale factor (single value or c(x_scale, y_scale))
- `...`: Additional parameters

**Returns:** duckspatial_df with scaled geometries

### ddbs_shear(x, factor, ...)
Applies shearing transformation.

**Parameters:**
- `x`: duckspatial_df object
- `factor`: Numeric shear factor
- `...`: Additional parameters

**Returns:** duckspatial_df with sheared geometries

### ddbs_shift(x, offset, ...)
Translates geometries by offset.

**Parameters:**
- `x`: duckspatial_df object
- `offset`: Numeric vector c(x_offset, y_offset)
- `...`: Additional parameters

**Returns:** duckspatial_df with shifted geometries

**Usage:**
```r
shifted <- data |> ddbs_shift(offset = c(1000, 500))
```

## Measurements

### ddbs_area(x, ...)
Computes area of polygon geometries.

**Parameters:**
- `x`: duckspatial_df with polygon geometries
- `...`: Additional parameters

**Returns:** Numeric vector of areas in CRS units squared

### ddbs_length(x, ...)
Computes length of linestring geometries.

**Parameters:**
- `x`: duckspatial_df with linestring geometries
- `...`: Additional parameters

**Returns:** Numeric vector of lengths in CRS units

### ddbs_perimeter(x, ...)
Computes perimeter of polygon geometries.

**Parameters:**
- `x`: duckspatial_df with polygon geometries
- `...`: Additional parameters

**Returns:** Numeric vector of perimeters in CRS units

### ddbs_distance(x, y, ...)
Computes minimum distance between geometries.

**Parameters:**
- `x`: duckspatial_df object
- `y`: duckspatial_df or sf object
- `...`: Additional parameters

**Returns:** Numeric vector or matrix of distances

**Usage:**
```r
# Distance from each point to nearest polygon
distances <- ddbs_distance(points, polygons)
```

## Database Utilities

### ddbs_create_schema(conn, schema_name, ...)
Establishes new database schema.

**Parameters:**
- `conn`: DuckDB connection
- `schema_name`: Name for new schema
- `...`: Additional parameters

**Returns:** NULL (modifies database)

### ddbs_crs(x)
Retrieves coordinate reference system metadata.

**Parameters:**
- `x`: duckspatial_df object

**Returns:** CRS object

### ddbs_drivers()
Lists GDAL-supported file formats available.

**Returns:** Data frame with driver information

### ddbs_glimpse(x, ...)
Shows preview of first rows.

**Parameters:**
- `x`: duckspatial_df object
- `...`: Additional parameters

**Returns:** Printed summary

### ddbs_list_tables(conn, schema = NULL, ...)
Enumerates database tables.

**Parameters:**
- `conn`: DuckDB connection
- `schema`: Optional schema name filter
- `...`: Additional parameters

**Returns:** Character vector of table names

## sf Integration Methods

duckspatial_df objects support standard sf methods:

- `st_crs(x)` - Get/set CRS
- `st_geometry(x)` - Extract geometry column
- `st_bbox(x)` - Get bounding box
- `st_as_sf(x)` - Convert to sf object (same as ddbs_collect)
- `print(x)` - Print object summary

## dplyr Integration Methods

duckspatial_df objects support dplyr verbs:

- `left_join()`, `inner_join()`, `right_join()`, `full_join()` - Non-spatial joins
- `head(x, n)` - Return first n rows
- `count(x, ...)` - Count by group
- `glimpse(x)` - Compact summary
- `compute(x)` - Force computation
- `distinct(x, ...)` - Select unique rows
- `filter()`, `select()`, `mutate()`, `summarise()`, `group_by()` - Standard dplyr operations

**Note:** All dplyr operations preserve the lazy duckspatial_df structure until `collect()` is called.
