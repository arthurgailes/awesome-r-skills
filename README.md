# R Package Skills

AI agents don't know every R package. When they encounter unfamiliar ones, they hallucinate APIs or fall back to verbose base R.

This plugin teaches them.

**Generate a skill from any R package:**

```
/r-package-skill collapse
```

Pulls documentation from CRAN, extracts patterns, writes a skill file. Your agent now knows when to use `collapse`, which functions matter, and how they compose.

Works for any package—CRAN, GitHub, internal tools. Each skill is tested, graded, and optimized before deployment.

## Installation

### Claude Code

```bash
/plugin marketplace add arthurgailes/r-package-skills
/plugin install r-package-skills@r-package-skills
```

### Codex

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/r-package-skills/main/.codex/INSTALL.md
```

### OpenCode

```
Fetch and follow instructions from https://raw.githubusercontent.com/arthurgailes/r-package-skills/main/.opencode/INSTALL.md
```

## Quick Start

Generate your first skill:

```bash
/r-package-skill data.table
```

You'll be asked where to install (Personal, Project, or Custom path). Then the agent:

1. Pulls CRAN reference manual and vignettes
2. Runs baseline test without the skill
3. Writes minimal `SKILL.md` addressing failures
4. Iterates until tests pass (90%+ score)

Takes 10-12 minutes with 3-4 approval prompts. Skill appears at your chosen path, ready to use.

## Included Skills

### Skill Generators

| Skill                                                | Description                                       |
| ---------------------------------------------------- | ------------------------------------------------- |
| [r-package-skill](skills/r-package-skill/SKILL.md)   | Generate a skill from any R package documentation |
| [writing-r-skills](skills/writing-r-skills/SKILL.md) | Build skills from scratch using TDD methodology   |

### Package Skills

#### Meta-Skills (Multi-Package Integration)

| Skill                                  | Focus                                              |
| -------------------------------------- | -------------------------------------------------- |
| [r-ai](skills/r-ai/SKILL.md)           | R AI ecosystem navigation and integration patterns |
| [r-mapping](skills/r-mapping/SKILL.md) | R mapping workflow guidance (freestiler + mapgl)   |

#### R AI Packages

| Skill                                    | Focus                                                |
| ---------------------------------------- | ---------------------------------------------------- |
| [r-ellmer](skills/r-ellmer/SKILL.md)     | Chat with LLMs, multi-provider support (hub package) |
| [r-btw](skills/r-btw/SKILL.md)           | Provide R context (docs, data) to LLMs               |
| [r-mcptools](skills/r-mcptools/SKILL.md) | Let AI agents execute R code in live sessions        |
| [r-ragnar](skills/r-ragnar/SKILL.md)     | RAG workflows, vector stores, document search        |
| [r-vitals](skills/r-vitals/SKILL.md)     | LLM output evaluation and quality testing            |

#### Data & Performance

| Skill                                    | Focus                                                   |
| ---------------------------------------- | ------------------------------------------------------- |
| [r-collapse](skills/r-collapse/SKILL.md) | Fast grouped/weighted stats, panel data transformations |
| [r-duckplyr](skills/r-duckplyr/SKILL.md) | Lazy evaluation for large datasets with DuckDB backend  |

#### Spatial & Visualization

| Skill                                          | Focus                                                    |
| ---------------------------------------------- | -------------------------------------------------------- |
| [r-duckspatial](skills/r-duckspatial/SKILL.md) | Spatial operations on large geometries via DuckDB        |
| [r-flextable](skills/r-flextable/SKILL.md)     | Publication-ready tables for Word/PowerPoint/PDF         |
| [r-freestiler](skills/r-freestiler/SKILL.md)   | Vector tilesets (PMTiles) from large spatial data        |
| [r-mapgl](skills/r-mapgl/SKILL.md)             | Interactive WebGL maps, vector tiles, Shiny applications |

### Development Workflows

| Skill                                                    | Focus                                |
| -------------------------------------------------------- | ------------------------------------ |
| [creating-r-package](skills/creating-r-package/SKILL.md) | R package creation and project setup |

## What Skills Do

Skills encode judgment. They teach agents which packages exist, when to use them, and how they compose.

**Without r-ai skill:**

```r
# Agent defaults to direct API calls
resp <- httr2::request("https://api.openai.com/v1/chat/completions") |>
  httr2::req_auth_bearer_token(key) |>
  httr2::req_body_json(list(messages = ...))
```

**With r-ai meta-skill and package skills:**

```r
# Agent knows the ecosystem and uses the right packages
chat <- chat_openai()                          # r-ellmer
chat$set_tools(btw_tools())                    # r-btw
ragnar_register_tool_retrieve(chat, store)     # r-ragnar
chat$chat("What does the documentation say about X?")
```

**Without r-collapse skill:**

```r
# Works, but slow on large data
data |> group_by(id) |> mutate(demeaned = value - mean(value))
```

**With r-collapse skill:**

```r
# Agent chooses the fast path
data |> fgroup_by(id) |> fmean(TRA = "-")  # 50-100x faster
```

Each skill is tested against realistic scenarios, graded by specialized validators, and refined until it passes.

## How Skills Are Built

Skills follow a test-driven workflow:

1. **RED**: Run a pressure scenario without the skill. Agent fails.
2. **GREEN**: Write minimal skill addressing the failure. Agent passes.
3. **REFACTOR**: Close loopholes, add edge cases, optimize.

Validators check domain-specific correctness:

- `plot-validator.R` - ggplot2 visualizations have required layers
- `spatial-validator.R` - geometries are valid, projections correct
- `html-validator.R` - tables render, conditional formatting works
- `numerical-validator.R` - grouped stats match expected results

Grading agents evaluate each test run, score assertions, and drive the improvement loop until tests consistently pass.

## Contributing

New skills follow the TDD methodology in [writing-r-skills](skills/writing-r-skills/SKILL.md):

1. **Baseline test** - Run realistic scenario without the skill
2. **Minimal skill** - Write just enough to pass
3. **Iterate** - Refine until grading agents consistently score 90%+

Package skills go in `skills/r-{package}/`. Goal-oriented skills (workflows that span multiple packages) are preferred when they make sense.

Each skill needs:

- `SKILL.md` under 500 words (overview, when to use, common mistakes)
- `references/` directory with detailed docs
- Test cases in `tests/{skill-name}/evals.json`

Fork, build, test, PR.

## License

MIT
