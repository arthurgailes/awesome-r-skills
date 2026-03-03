# Awesome R Skills

R skills for AI coding agents.

## Why?

1. **Instant package knowledge** - Create a skill for any R package and your agent immediately knows the docs. New package? Rare package? Doesn't matter - make a skill and your agent knows how to use it.

2. **Opinionated references** - Topics like R package development have large, scattered documentation. Skills consolidate this into opinionated defaults agents can access immediately.

3. **Extensible** - `r-package-skill` and `writing-skills` let you create skills for your own packages.

## Installation

**Note:** Installation differs by platform. Claude Code has a built-in plugin system. Codex and OpenCode require manual setup.

### Claude Code (via Plugin Marketplace)

Register the marketplace:

```bash
/plugin marketplace add arthurgailes/awesome-r-skills
```

Install the plugin:

```bash
/plugin install awesome-r-skills@awesome-r-skills
```

### Codex

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/awesome-r-skills/main/.codex/INSTALL.md
```

**Detailed docs:** [.codex/INSTALL.md](.codex/INSTALL.md)

### OpenCode

Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/awesome-r-skills/main/.opencode/INSTALL.md
```

**Detailed docs:** [.opencode/INSTALL.md](.opencode/INSTALL.md)

## Skills

### Data Operations

| Skill                                      | When to Use                                                            |
| ------------------------------------------ | ---------------------------------------------------------------------- |
| [r-collapse](skills/r-collapse/SKILL.md)   | Fast grouped/weighted stats, panel data, when dplyr is too slow        |
| [r-flextable](skills/r-flextable/SKILL.md) | Publication tables for Word/PowerPoint/PDF with conditional formatting |

### Spatial & Visualization

| Skill                              | When to Use                                                      |
| ---------------------------------- | ---------------------------------------------------------------- |
| [r-mapgl](skills/r-mapgl/SKILL.md) | Interactive WebGL maps, vector tiles, 3D terrain, Shiny map apps |

### AI/LLM Integration

| Skill                        | When to Use                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------- |
| [r-ai](skills/r-ai/SKILL.md) | LLM chat (ellmer), RAG (ragnar), agent integration (mcptools), evaluation (vitals) |

### Package Development

| Skill                                                    | When to Use                           |
| -------------------------------------------------------- | ------------------------------------- |
| [creating-r-package](skills/creating-r-package/SKILL.md) | Starting a new R package from scratch |

### Meta (Creating Skills)

| Skill                                              | When to Use                                 |
| -------------------------------------------------- | ------------------------------------------- |
| [writing-skills](skills/writing-skills/SKILL.md)   | Creating new skills with TDD methodology    |
| [r-package-skill](skills/r-package-skill/SKILL.md) | Extracting R package docs into skill format |

## Example: What Skills Add

**Without r-ai skill**, agent writes:

```r
# Tries to use httr2 to call OpenAI API directly,
# doesn't know about ellmer/ragnar ecosystem
resp <- httr2::request("https://api.openai.com/v1/chat/completions") |> ...
```

**With r-ai skill**, agent writes:

```r
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)  # RAG-enabled chat
chat$chat("What does the documentation say about X?")
```

**Without r-collapse skill**, agent writes:

```r
data |> group_by(id) |> mutate(demeaned = value - mean(value))
```

**With r-collapse skill**, agent writes:

```r
data |> fgroup_by(id) |> fmean(TRA = "-")  # 50-100x faster, single C pass
```

Skills encode judgment: which packages exist, when they're appropriate, and idiomatic patterns.

## Contributing

1. Fork
2. Follow [writing-skills](skills/writing-skills/SKILL.md) TDD methodology
3. Prefer goal-oriented skills over package-centric skills
4. PR

## License

MIT
