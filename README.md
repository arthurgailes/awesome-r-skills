# Awesome R Skills

You want your AI agent to use R packages correctly.

But your agent hallucinates APIs, writes verbose base R when fast packages exist, or doesn't know enough about new packages.

**`/r-package-skill` fixes it:**

```
/r-package-skill collapse
```

Extracts the docs. Outputs a skill your agent can use. Works for any package—CRAN, GitHub, your team's internal code.

## Installation

### Claude Code

```bash
/plugin marketplace add arthurgailes/awesome-r-skills
/plugin install awesome-r-skills@awesome-r-skills
```

### Codex

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/awesome-r-skills/main/.codex/INSTALL.md
```

### OpenCode

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/awesome-r-skills/main/.opencode/INSTALL.md
```

## Included Skills

### Skill Generators (the main event)

| Skill                                              | What It Does                                                         |
| -------------------------------------------------- | -------------------------------------------------------------------- |
| [r-package-skill](skills/r-package-skill/SKILL.md) | **Generate a skill from any R package** - point at docs, get a skill |
| [writing-skills](skills/writing-skills/SKILL.md)   | Create skills from scratch with TDD methodology                      |

### Ready-to-Use Package Skills

| Skill                                        | When to Use                                               |
| -------------------------------------------- | --------------------------------------------------------- |
| [r-collapse](skills/r-collapse/SKILL.md)     | Fast grouped/weighted stats, panel data, dplyr too slow   |
| [r-flextable](skills/r-flextable/SKILL.md)   | Publication tables for Word/PowerPoint/PDF                |
| [r-mapgl](skills/r-mapgl/SKILL.md)           | Interactive WebGL maps, vector tiles, Shiny map apps      |
| [r-freestiler](skills/r-freestiler/SKILL.md) | PMTiles vector tilesets from large spatial datasets       |
| [r-ai](skills/r-ai/SKILL.md)                 | LLM chat, RAG, agent integration (ellmer/ragnar/mcptools) |

### R Development

| Skill                                                    | When to Use                           |
| -------------------------------------------------------- | ------------------------------------- |
| [creating-r-package](skills/creating-r-package/SKILL.md) | Starting a new R package from scratch |

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
