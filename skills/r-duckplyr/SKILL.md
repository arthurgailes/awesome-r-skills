---
name: r-duckplyr
description: Use when processing datasets >100k rows with dplyr syntax, using the duckplyr package in R, needing lazy evaluation, or working with larger-than-memory data files (Parquet, CSV)
---

# duckplyr: DuckDB-Backed dplyr

## Overview

**duckplyr is a drop-in replacement for dplyr powered by DuckDB for speed and memory efficiency.** It uses identical syntax but lazy evaluation - operations execute only when results are needed, enabling processing of datasets larger than available RAM.

## When to Use duckplyr vs Alternatives

| Use duckplyr when...       | Use dplyr when...      | Use duckspatial when...  | Use data.table when...       |
| -------------------------- | ---------------------- | ------------------------ | ---------------------------- |
| Data >100k rows            | Small datasets (<100k) | Spatial operations       | In-place modification (`:=`) |
| Larger-than-memory files   | All data fits in RAM   | Geospatial joins/buffers | Reference semantics          |
| Parquet/CSV on disk        | Already in memory      | DuckDB + spatial queries | Non-equi joins               |
| Lazy pipeline optimization | Immediate results      | PMTiles, vector tiles    | Keyed/rolling joins          |

**Key insight:** duckplyr works on files without loading into R - queries Parquet/CSV directly from disk or URLs.

## Quick Start

```r
library(duckplyr)

# Convert existing data frame
df <- as_duckdb_tibble(my_data)

# Or read files directly (lazy evaluation)
df <- read_parquet_duckdb("large_file.parquet")

# Standard dplyr syntax
result <- df |>
  filter(year == 2024) |>
  group_by(category) |>
  summarise(total = sum(value)) |>
  collect()  # Materializes result
```

## Critical Differences from dplyr

| Difference          | dplyr                   | duckplyr                                     |
| ------------------- | ----------------------- | -------------------------------------------- |
| **Function name**   | N/A                     | `as_duckdb_tibble()` (not `as_duck_frame()`) |
| **Evaluation**      | Eager (immediate)       | Lazy (until `collect()`)                     |
| **Sorting**         | Auto-sorts groups       | NO auto-sort - use `arrange()`               |
| **NULL handling**   | `na.rm = FALSE` default | Excludes NULLs by default                    |
| **Materialization** | Always in memory        | Controlled by `prudence` parameter           |

### Prudence Levels (Memory Protection)

- `"lavish"`: Converts regardless of size (may OOM)
- `"thrifty"`: Max 1 million cells (default)
- `"stingy"`: Never auto-converts (safest for large data)

```r
read_parquet_duckdb("file.parquet", prudence = "stingy")
```

## Quick Reference

| Task                  | Function                                         |
| --------------------- | ------------------------------------------------ |
| Read Parquet          | `read_parquet_duckdb(path, prudence = "stingy")` |
| Read CSV/JSON         | `read_csv_duckdb()`, `read_json_duckdb()`        |
| Multiple files        | `read_parquet_duckdb("data_*.parquet")` (globs)  |
| Convert data frame    | `as_duckdb_tibble(df)`                           |
| Bring to R            | `collect()` (materializes in R memory)           |
| Cache in DuckDB       | `compute()` (temp table)                         |
| Write file            | `compute_parquet()`, `compute_csv()`             |
| Remote data (HTTP/S3) | `db_exec("INSTALL httpfs")`, then use URLs       |
| Query plan            | `explain(df \|> filter(...))`                    |
| Memory limit          | `db_exec("PRAGMA memory_limit = '4GB'")`         |

## Common Mistakes

| Mistake                | Fix                                       |
| ---------------------- | ----------------------------------------- |
| `as_duck_frame()`      | Use `as_duckdb_tibble()`                  |
| Early `collect()`      | Keep lazy until end                       |
| No prudence setting    | Set `prudence = "stingy"` for large files |
| Expecting auto-sort    | Use explicit `arrange()`                  |
| arrow/readr instead    | Use `read_*_duckdb()` functions           |
| Missing httpfs         | `db_exec("INSTALL httpfs")` for URLs      |
| No `compute()` caching | Cache expensive intermediates             |

## When NOT to Use

- Small data (<100k rows) - dplyr, collapse, data.table faster
- Spatial operations - use duckspatial
- In-place modification - use data.table or collapse

**See references/API.md for complete function reference**
