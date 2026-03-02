# AwesomeRSkills

Opinionated R skills for Claude Code.

functions: 1. Create ad-hoc skills for any R package [do how-to] 2. Assist in specific package 3. Has some examples of newer packages attached for reference (`collapse`, `mapgl`)

## Installation

```bash
git clone https://github.com/user/AwesomeRSkills
cp -r AwesomeRSkills/skills/* ~/.claude/skills/
```

## Skills

### Meta (How to Create Skills)

| Skill           | Purpose                                      |
| --------------- | -------------------------------------------- |
| writing-skills  | TDD methodology for skill creation           |
| r-package-skill | Extract R package docs into skill references |

### Goal-Oriented Skills

| Skill     | Goal                     | Recommended Tools        |
| --------- | ------------------------ | ------------------------ |
| (planned) | Fast grouped operations  | collapse                 |
| (planned) | Interactive maps         | mapGL                    |
| (planned) | Spatial processing       | sf, terra, GDAL patterns |
| (planned) | Big data / out-of-memory | Arrow, DuckDB            |

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
