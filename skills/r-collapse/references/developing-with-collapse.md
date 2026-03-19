# Developing with Collapse: A Guide for Package Developers

## Overview

Sebastian Krantz's vignette on developing with collapse provides three core principles for writing efficient R statistical packages, complementing an earlier blog post on programming techniques.

## Point 1: Minimalistic Computations

The first recommendation emphasizes using minimal operations to accomplish tasks. Key strategies include:

**Grouping Efficiency**: When performing grouped operations, avoid creating unnecessary grouping objects. The author demonstrates that `fsum(x, g)` outperforms approaches involving pre-created factor or 'qG' objects when grouping occurs only once. For repeated operations with complex functions like `fmedian()`, creating 'GRP' objects becomes worthwhile despite their creation cost.

**Data Structure Choice**: As the text states, "think carefully about how to vectorize in a minimalistic and memory efficient way." The vignette illustrates this with a deduplication example using `fsubset(data, source == fmode(...))` to solve a complex spatial data problem in a single expression.

**Function Selection**: The guidance recommends consulting the fastverse ecosystem when collapse doesn't offer ideal solutions, noting that packages like `kit` and `data.table` provide specialized efficient functions.

## Point 2: Memory Optimization

This section addresses the two principal inefficiencies in R: unvectorized operations and excessive intermediate objects.

**Logical Vector Replacement**: Rather than `x[x == 0] <- NA`, use `setv(x, 0, NA)` to avoid creating million-element logical vectors. Similarly, `whichv()` and operators like `%iin%` return indices instead of logical vectors, improving subsetting efficiency dramatically (39,878 iterations/sec versus 6,008 for `%in%`).

**In-Place Operations**: The infix operators `%+=%`, `%-=%`, `%*=%`, and `%/=%` perform operations by reference, preventing intermediate copies. Combined with the `TRA` argument and `set = TRUE` option in statistical functions, these enable efficient transformations. The author demonstrates a complete grouped linear regression function achieving performance comparable to C-level algorithms.

**Efficient Data Access**: Use `.subset()`, `.subset2()`, and `get_vars()` for faster column extraction than standard bracket notation.

## Point 3: Primitive Objects Over Complex Structures

This principle reverses conventional wisdom in the tidyverse ecosystem, advocating for vectors, matrices, and lists over data frames.

**Internal Representation**: The text notes that "internally, collapse does not use data frame-like objects at all." Instead, such objects are cast to lists using `unclass(data)` or `class(data) <- NULL`. Benchmarks show this approach is approximately 6 times faster for identical operations.

**Construction Methods**: For creating data frame-like objects, collapse provides `qDF()`, `qDT()`, and `qTBL()` functions that substantially outperform `as.data.frame()` and equivalents (1.7 microseconds versus 210.4 for list conversion).

**Attribute Management**: The vignette recommends using `setattrib()` and `copyMostAttrib()` for efficient attribute operations, suggesting a workflow of saving attributes before manipulation and reapplying afterward.

## Global Options Considerations

Package developers must carefully manage collapse's global options through `set_collapse()` and `get_collapse()`:

**Responsibility**: "setting these options inside a package also affects how collapse behaves outside of your package." Options must be reset using `on.exit()` to prevent side effects on user settings.

**Critical Options**: The `na.rm`, `nthreads`, and `sort` options particularly impact package code. Developers should either explicitly set these arguments in function calls or use conditional logic checking `get_collapse()` values.

**Namespace Masking**: The vignette advises against setting namespace masking options (`mask` and `remove`) within packages due to unintended consequences for users.

## Conclusion

The vignette emphasizes that efficient collapse-based development requires deep familiarity with the package ecosystem, careful attention to memory allocation patterns, and architectural decisions favoring primitives over abstractions. This approach enables "programs that effectively run like C while accomplishing complex statistical/data tasks with few lines of code."
