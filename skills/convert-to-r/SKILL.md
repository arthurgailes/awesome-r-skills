---
name: convert-to-r
description: Use when converting a Python skill to R.
---

# Convert to R

## Process

1. Read `refs/clone/claude-scientific-skills/scientific-skills/{skill}/`
2. Map libraries (see table)
3. Translate syntax
4. Create `skills/{skill}/SKILL.md`

## Library Map

| Python       | R                             |
| ------------ | ----------------------------- |
| pandas       | data.table / collapse / dplyr |
| numpy        | base R                        |
| matplotlib   | ggplot2                       |
| scikit-learn | tidymodels                    |
| requests     | httr2                         |

## Syntax

```python
df.groupby('x').agg({'y': 'mean'})
```

```r
dt[, .(y = mean(y)), by = x]
```

## R Idioms

- `|>` not `%>%`
- `\(x)` for lambdas
- Vectorize over loops
- ASCII-safe only
