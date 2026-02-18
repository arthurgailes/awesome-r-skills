# AwesomeRSkills

Opinionated R skills for Claude Code.

## Philosophy

**Skills are goal-oriented, not package-centric.**

The value isn't in documenting packages (LLMs can fetch docs). The value is in:
- **Judgment**: When to use collapse vs dplyr, mapGL vs leaflet
- **Opinions**: Which tool is best for a given goal
- **Cross-cutting patterns**: GDAL behaviors affecting sf/terra/vapour, Arrow underneath DuckDB
- **Efficiency**: Fewer dependencies, faster code, simpler solutions

A skill like `r-fast-data` might recommend collapse, but collapse is a *tool* within the goal of "efficient grouped operations." The skill encodes *why* and *when*, not just *how*.

## Installation

```bash
git clone https://github.com/user/AwesomeRSkills
cp -r AwesomeRSkills/skills/* ~/.claude/skills/
```

## Skills

### Meta (How to Create Skills)

| Skill | Purpose |
|-------|---------|
| writing-skills | TDD methodology for skill creation |
| r-pkg-skill | Extract R package docs into skill references |

### Goal-Oriented Skills

| Skill | Goal | Recommended Tools |
|-------|------|-------------------|
| (planned) | Fast grouped operations | collapse |
| (planned) | Interactive maps | mapGL |
| (planned) | Spatial processing | sf, terra, GDAL patterns |
| (planned) | Big data / out-of-memory | Arrow, DuckDB |

### Package References

Package-specific docs that support goal-oriented skills:

| Reference | Status |
|-----------|--------|
| r-collapse | Done |

## Structure

```
skills/           # SKILL.md files
  writing-skills/ # Meta: how to create skills
  r-pkg-skill/    # Meta: extract package docs
  r-collapse/     # Reference: collapse patterns
refs/             # Reference materials (gitignored)
  docs/           # Package docs, vignettes
  clone/          # Cloned repos
```

## Contributing

1. Fork
2. Create skill per `skills/writing-skills/SKILL.md`
3. Goal-oriented skills > package skills
4. PR

## License

MIT
