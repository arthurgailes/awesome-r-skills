---
name: r-ai
description: Use when building LLM-powered R applications, connecting R to AI agents, implementing RAG workflows, or evaluating AI outputs
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

**When NOT to use:** Single one-off API call (httr2 is simpler), non-chat ML tasks (tidymodels), or when you need streaming callbacks (ellmer streams but callbacks are limited).

## ellmer: Chat with LLMs

```r
library(ellmer)
chat <- chat_openai()                        # Uses OPENAI_API_KEY
chat <- chat_anthropic()                     # Uses ANTHROPIC_API_KEY
chat <- chat_ollama(model = "llama3.2")      # Local, no API key

chat$chat("Explain this error")              # Interactive
response <- chat$chat("...", echo = "none")  # Programmatic
chat$set_tools(my_tools)                     # Add tools
```

**Key insight:** Chat objects are stateful - history persists across calls. Create new chat for fresh context.

## btw: Context Tools

```r
library(btw)
btw("ggplot2")              # Copy package docs to clipboard
chat$set_tools(btw_tools()) # Register with ellmer
btw_app()                   # Interactive chat UI
```

## mcptools: Agent Integration

```r
library(mcptools)
mcp_session()  # Run in console (not scripts), each R session
```

**Claude Code config:** `claude mcp add r-mcptools -- Rscript -e "mcptools::mcp_server()"`

## ragnar: RAG Workflows

```r
library(ragnar)

# Create store (supports PDF, markdown, HTML)
docs <- read_as_markdown("path/to/docs/")
chunks <- markdown_chunk(docs)
store <- ragnar_store_create("docs.duckdb")
ragnar_store_insert(store, chunks)  # Embeds with OpenAI by default

# Reopen existing store
store <- ragnar_store_connect("docs.duckdb")

# Integrate with chat
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)
chat$chat("What does the documentation say about X?")
```

**Local embeddings (Ollama):**
```r
store <- ragnar_store_create("docs.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))
```

## vitals: LLM Evaluation

```r
library(vitals)
task <- Task$new(
  dataset = tibble::tibble(
    input = c("What is 2+2?", "Capital of France?"),
    target = c("4", "Paris")
  ),
  solver = generate(),
  scorer = model_graded_qa()
)
task$run(chat_openai())
task$view()
```

**Evaluate RAG pipeline:**
```r
rag_solver <- function(input) chat$chat(input, echo = "none")
task <- Task$new(dataset = test_cases, solver = rag_solver, scorer = model_graded_qa())
task$run()
```

## Integration Patterns

```r
# Chat + context tools
chat <- chat_openai()
chat$set_tools(btw_tools())

# Chat + RAG
store <- ragnar_store_connect("docs.duckdb")
ragnar_register_tool_retrieve(chat, store)

# Agent access + RAG (in console)
mcp_session()  # Claude Code can now query store via R

# Fully local (Ollama)
chat <- chat_ollama(model = "llama3.2")
store <- ragnar_store_create("local.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))
```

## Common Gotchas

1. **Stateful chat:** Each `$chat()` adds to history. New chat = fresh context
2. **btw vs mcptools:** btw gives tools TO ellmer; mcptools lets agents INTO R
3. **Embedding mismatch:** Store and retrieval must use same provider
4. **mcp_session() per-session:** Call each R startup, in console not scripts
5. **Ollama must run:** Start with `ollama serve` before using

## Detailed Reference

For full API details, see `references/`:
- `ellmer.md` - Providers, models, tools, multimodal
- `btw.md` - Available tools, MCP server, config
- `ragnar.md` - Chunking, embedding providers, retrieval
- `mcptools.md` - Agent config (Claude, VS Code), security
- `vitals.md` - Solvers, scorers, custom evaluation
