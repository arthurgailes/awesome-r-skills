# Awesome R Skills

Opinionated R skills for AI coding agents. Encode expert judgment about *when* to use tools, not just *how*.

## Why?

AI agents know R syntax but lack judgment. These skills provide:

- **When-to-use guidance** - collapse vs dplyr vs data.table decision trees
- **Non-obvious patterns** - TRA transformations, panel data decomposition, Shiny proxies
- **Gotcha prevention** - grouping incompatibilities, CRS requirements, output format quirks

## Installation

### Claude Code

```
/plugin install github:arthurgailes/awesome-r-skills
```

### Cursor

```
/plugin-add awesome-r-skills
```

### Codex / OpenCode

See [.codex/INSTALL.md](.codex/INSTALL.md) or [.opencode/INSTALL.md](.opencode/INSTALL.md)

## Skills

### Data Operations

| Skill | When to Use |
|-------|-------------|
| [r-collapse](skills/r-collapse/SKILL.md) | Fast grouped/weighted stats, panel data, when dplyr is too slow |
| [r-flextable](skills/r-flextable/SKILL.md) | Publication tables for Word/PowerPoint/PDF with conditional formatting |

### Spatial & Visualization

| Skill | When to Use |
|-------|-------------|
| [r-mapgl](skills/r-mapgl/SKILL.md) | Interactive WebGL maps, vector tiles, 3D terrain, Shiny map apps |

### Package Development

| Skill | When to Use |
|-------|-------------|
| [creating-r-package](skills/creating-r-package/SKILL.md) | Starting a new R package from scratch |

### Meta (Creating Skills)

| Skill | When to Use |
|-------|-------------|
| [writing-skills](skills/writing-skills/SKILL.md) | Creating new skills with TDD methodology |
| [r-package-skill](skills/r-package-skill/SKILL.md) | Extracting R package docs into skill format |

## Example: What Skills Add

**Without r-collapse skill**, agent writes:
```r
data |> group_by(id) |> mutate(demeaned = value - mean(value))
```

**With r-collapse skill**, agent writes:
```r
data |> fgroup_by(id) |> fmean(TRA = "-")  # 50-100x faster, single C pass
```

The skill encodes the judgment that collapse exists, when it's appropriate, and the idiomatic patterns.

## Contributing

1. Fork
2. Follow [writing-skills](skills/writing-skills/SKILL.md) TDD methodology
3. Prefer goal-oriented skills over package-centric skills
4. PR

## License

MIT
