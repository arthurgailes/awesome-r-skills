# Collapse's Handling of R Objects

## Overview

The **collapse** package employs a "class-agnostic architecture" that enables statistical and data manipulation operations across diverse R object types. It explicitly supports base R classes (logical, integer, double, character, list, data.frame, matrix, factor, Date, POSIXct, ts) and popular extensions including data.table, tibble, xts/zoo, units, and sf objects.

## Core Design Principles

Collapse operates on three fundamental object types internally: atomic vectors, matrices, and lists (often treated as data frames). The package "preserves attributes and classes" unless preservation risks producing incorrect or useless results. High-risk operations—those altering dimensions or internal data types—trigger attribute modifications.

**Key preservation rules:**
- Operations maintaining object dimensions (like `fscale()`) preserve all attributes
- Statistical reductions to single dimensions drop non-essential attributes
- Atomic vectors retain attributes during statistical operations (except ts objects)
- Dimension changes trigger selective attribute preservation based on object class

## Handling Specific Transformations

When using the `TRA()` function for data transformation, simple modifications (`"-"`, `"/"`, `"+"`) copy all attributes. More complex operations like `"fill"` and `"replace"` apply stricter rules: the result adopts the data type of the replacement statistics, and attribute preservation depends on whether objects have class attributes and matching data types.

## Class-Specific Implementations

**Data.table Support:** Collapse avoids assigning descriptive row names to data.tables and implements reference semantics, creating overallocated lists compatible with data.table's column addition operations.

**Time Series Handling:** xts/zoo objects use `.zoo` methods following the pattern of applying appropriate statistical functions (matrix or default) based on object structure. Users must explicitly specify time identifiers via the `t` argument for indexed computations.

**SF Spatial Data:** The package protects geometry columns during subsetting operations while omitting them from statistical calculations. Geometric operations remain unsupported.

**Units Objects:** Simple wrapper methods preserve the units class using `copyMostAttrib()`, which copies attributes except dimensions and names.

## Advanced Structures

Collapse introduces two modern class-agnostic alternatives:

1. **GRP_df** (grouped data frames): Created via `fgroup_by()`, these objects prepend a "GRP_df" class while preserving original classes, enabling seamless compatibility with data.tables and tibbles.

2. **indexed_series/indexed_frame**: These "deeply indexed" structures allow time-aware computations on nearly any object type, supporting irregular time series and complex panels natively. Each indexed series maintains an external pointer to its frame's index, enabling safe use across different data masking environments.

## Practical Examples

For conversion functions like `qM()` and `qDF()`, the default behavior (`keep.attr = FALSE`) performs strict conversions removing non-essential attributes. This ensures predictable behavior—for instance, `qM(EuStockMarkets)` returns a plain matrix, not a time series object.

Column selection functions (`num_vars()`, `cat_vars()`) use C-level implementations checking `typeof()` rather than respecting custom S3 methods, which may cause unexpected behavior with classes defining specialized `is.numeric()` methods.

## Limitations

The vignette acknowledges that hard-coded C implementations, while providing speed and generality, cannot accommodate all specialized classes. Notable failures include lubridate's interval class, which has subsetting-incompatible attributes that collapse cannot properly handle.
