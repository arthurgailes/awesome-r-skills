# AwesomeRSkills

Opinionated R skills for coding agents. Fast data ops, interactive maps, publication tables, and skill creation patterns.

## Installation

### Claude Code

```bash
/plugin install github:arthurgailes/awesome-r-skills
```

### Cursor

```bash
/plugin-add awesome-r-skills
```

Or clone and symlink:
```bash
git clone https://github.com/arthurgailes/awesome-r-skills.git ~/.cursor/awesome-r-skills
ln -s ~/.cursor/awesome-r-skills/skills ~/.cursor/skills/awesome-r-skills
```

### Codex

See [.codex/INSTALL.md](.codex/INSTALL.md)

### OpenCode

See [.opencode/INSTALL.md](.opencode/INSTALL.md)

## Skills

### R Package Skills

| Skill | Purpose |
|-------|---------|
| r-collapse | Fast grouped/weighted stats, panel data, TRA transformations |
| r-mapgl | Interactive WebGL maps with maplibre/mapbox |
| r-flextable | Publication-ready tables |
| creating-r-package | R package development patterns |

### Meta Skills (Creating New Skills)

| Skill | Purpose |
|-------|---------|
| writing-skills | TDD methodology for skill creation |
| r-package-skill | Extract R package docs into skills |

## Structure

```
skills/              # SKILL.md files + optional references/
  r-collapse/        # Fast data operations
  r-mapgl/           # Interactive maps
  r-flextable/       # Tables
  creating-r-package/# Package development
  r-package-skill/   # Meta: extract package docs
  writing-skills/    # Meta: TDD for skills
.claude-plugin/      # Claude Code config
.cursor-plugin/      # Cursor config
.codex/              # Codex install instructions
.opencode/           # OpenCode install instructions
refs/                # Reference materials (gitignored)
```

## Contributing

1. Fork
2. Create skill per `skills/writing-skills/SKILL.md`
3. Goal-oriented skills > package-centric skills
4. PR

## License

MIT
