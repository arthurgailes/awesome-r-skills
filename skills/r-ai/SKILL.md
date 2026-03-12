---
name: r-ai
description: Use when building LLM-powered R applications, using ellmer/ragnar/mcptools packages in R, connecting R to AI agents, implementing RAG workflows, or evaluating AI outputs
---

# R AI Ecosystem

## Overview

**Five packages form the R AI stack:** ellmer (chat), btw (context tools), mcptools (agent integration), ragnar (RAG), vitals (evaluation). Ellmer is the hub.

**Install:** `install.packages(c("ellmer", "btw", "mcptools", "ragnar", "vitals"))`

**API keys:** Set `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` in `.Renviron`

## When to Use Which

| Package | Use When | Key Function |
|---------|----------|--------------|
| **ellmer** | Chat with any LLM from R | `chat_openai()`, `chat_ollama()` |
| **btw** | Provide context (docs, data, git) to LLMs | `btw_tools()` |
| **mcptools** | Let Claude/VS Code run R code | `mcp_session()` |
| **ragnar** | LLM searches your documents | `ragnar_register_tool_retrieve()` |
| **vitals** | Test LLM output quality | `Task$new()` |

**When NOT to use:** Single one-off API call (httr2 simpler), non-chat ML (tidymodels), streaming callbacks needed.

## Quick Start

```r
# ellmer: Chat
library(ellmer)
chat <- chat_openai()
chat$chat("Explain this error")

# btw: Context tools
library(btw)
btw("ggplot2")              # Copy docs to clipboard
chat$set_tools(btw_tools()) # Register with ellmer

# mcptools: Agent access
library(mcptools)
mcp_session()  # In console, each startup

# ragnar: RAG
library(ragnar)
docs <- read_as_markdown("docs/")
chunks <- markdown_chunk(docs)
store <- ragnar_store_create("docs.duckdb")
ragnar_store_insert(store, chunks)

chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)
chat$chat("What does the documentation say?")

# vitals: Evaluation
library(vitals)
task <- Task$new(
  dataset = test_cases,
  solver = generate(),
  scorer = model_graded_qa()
)
task$run(chat_openai())
```

## Common Gotchas

| Issue | Solution |
|-------|----------|
| Stateful chat | Each `$chat()` adds to history. New chat = fresh context |
| btw vs mcptools | btw gives tools TO ellmer; mcptools lets agents INTO R |
| Embedding mismatch | Store and retrieval must use same provider |
| mcp_session() per-session | Call each R startup, in console not scripts |
| Ollama not running | Start with `ollama serve` first |

## Integration Patterns

```r
# Chat + context
chat <- chat_openai()
chat$set_tools(btw_tools())

# Chat + RAG
ragnar_register_tool_retrieve(chat, store)

# Fully local
chat <- chat_ollama(model = "llama3.2")
store <- ragnar_store_create("local.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))
```

## Advanced

See `references/` for:
- **integration-patterns.md**: Cross-package integration, RAG evaluation, full stack
- **ellmer-api.md**: Complete ellmer function reference
- **btw-api.md**: Complete btw function reference (30+ tools)
- **mcptools-api.md**: Complete mcptools function reference
- **ragnar-api.md**: Complete ragnar function reference
- **vitals-api.md**: Complete vitals function reference
- **ellmer.md**: Providers, models, tools, multimodal
- **btw.md**: Available tools, MCP server, config
- **ragnar.md**: Chunking, embedding providers, retrieval
- **mcptools.md**: Agent config (Claude, VS Code), security
- **vitals.md**: Solvers, scorers, custom evaluation
