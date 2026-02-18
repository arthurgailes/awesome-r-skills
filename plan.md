# AwesomeRSkills - Plan

## Core Insight

**Skills should be goal-oriented, not package-centric.**

Package documentation can be automated or fetched by LLMs. The value is in:

- **Judgment**: When to use which tool
- **Opinions**: Recommended approaches that differ from defaults
- **Cross-cutting patterns**: GDAL underneath sf, Arrow underneath DuckDB
- **Efficiency goals**: Fewer deps, faster code, simpler solutions

A package like collapse is useful _because_ it achieves efficiency goals. The skill should anchor to the goal, with collapse as the recommended tool.

## Skill Types

### 1. Goal-Oriented Skills (Primary)

Encode judgment about _what to achieve_ and _which tools to use_:

| Skill              | Goal                              | Tools                | Status  |
| ------------------ | --------------------------------- | -------------------- | ------- |
| r-fast-data        | Efficient grouped ops, fewer deps | collapse, data.table | Planned |
| r-interactive-maps | Best interactive maps             | mapGL                | Planned |
| r-spatial          | Spatial processing patterns       | sf, terra, GDAL      | Planned |
| r-big-data         | Out-of-memory data                | Arrow, DuckDB        | Planned |
| r-llm              | LLM integration                   | ellmer, btw          | Planned |

### 2. Package References (Supporting)

Detailed package patterns that goal-oriented skills can reference:

| Reference  | Status  | Notes                                        |
| ---------- | ------- | -------------------------------------------- |
| r-collapse | Done    | TRA argument, eager vectorization, panel ops |
| r-mapgl    | Planned |                                              |
| r-sf       | Planned | GDAL gotchas                                 |
| r-arrow    | Planned |                                              |

### 3. Meta Skills (How to Create Skills)

| Skill          | Status | Purpose                              |
| -------------- | ------ | ------------------------------------ |
| writing-skills | Done   | TDD methodology                      |
| r-pkg-skill    | Done   | Extract package docs into references |

## Build Process

Efficiently capture judgment without hours of manual work:

### 1. Decision-Tree Interview (5-10 min per skill)

For each goal skill, answer:
- What's the goal?
- What tool(s) do you recommend?
- What's the main gotcha people miss?
- When would you NOT use this approach?

### 2. Code Archaeology

Point at code you're proud of. Agent extracts patterns and opinions embedded in it.

### 3. Pain-Point Dump

List things that break, annoy, or you repeat explaining. Agent structures into gotchas.

### 4. Opinionated Defaults

Quick statements: "For X, always use Y unless Z" - Agent expands into skill content.

## Interview Queue

| Skill | Status | Notes |
|-------|--------|-------|
| r-fast-data | Next | collapse vs data.table vs dplyr |
| r-big-data | Queued | Arrow vs DuckDB |
| r-spatial | Queued | sf/terra/GDAL patterns |
| r-interactive-maps | Queued | Why mapGL |
| r-llm | Queued | ellmer/btw patterns |

## Completed

- [x] writing-skills (R-adapted from superpowers)

## Next Steps

1. Identify 3-5 goal-oriented skills from actual workflow
2. For each: what's the goal, what's the opinion, what are the gotchas
3. Create goal skill, reference package docs as needed

## Research (refs/)

| Resource                 | Location            | Purpose                |
| ------------------------ | ------------------- | ---------------------- |
| superpowers              | refs/clone/         | TDD skill methodology  |
| claude-scientific-skills | refs/clone/         | Python skill templates |
| collapse vignettes       | refs/docs/collapse/ | Package reference      |
| mcptools/btw docs        | refs/docs/          | MCP integration        |

## Conventions

- `|>` not `%>%`
- ASCII-safe strings only
- Goal skills: `r-{goal}` (e.g., r-fast-data)
- Package refs: `r-{package}` (e.g., r-collapse)
