---
name: r-ai
description: Use when code loads ellmer, btw, mcptools, ragnar, or vitals, building LLM-powered R applications, implementing RAG workflows, or choosing between R AI packages (meta-skill for ellmer/btw/mcptools/ragnar/vitals)
---

# R AI Ecosystem (Meta-Skill)

## Overview

**This is a meta-skill** that helps you choose the right R AI package. The R AI stack consists of 5 specialized packages, each with its own skill.

**Install all:** `install.packages(c("ellmer", "btw", "mcptools", "ragnar", "vitals"))`

**API keys:** Set `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` in `.Renviron`

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/integration-patterns.md` - How packages work together in workflows

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>

## When to Use Which Package

| Package | Use When | Skill |
|---------|----------|-------|
| **ellmer** | Chat with any LLM from R | `/r-ellmer` |
| **btw** | Provide R context (docs, data) to LLMs | `/r-btw` |
| **mcptools** | Let agents (Claude Code) run R code | `/r-mcptools` |
| **ragnar** | LLM searches your documents (RAG) | `/r-ragnar` |
| **vitals** | Test LLM output quality | `/r-vitals` |

**Navigation:** When you know which package you need, invoke the specific skill above.

## When NOT to Use

- Single one-off API call (use httr2)
- Non-chat ML workflows (use tidymodels)
- Production REST APIs (use plumber)

## Key Distinctions

**btw vs mcptools:**
- **btw** = Give tools TO ellmer (R → LLM): Chat can read R docs/data
- **mcptools** = Let agents INTO R (LLM → R): Agents can run R code

**ellmer vs ragnar:**
- **ellmer** = Direct chat, limited by context window
- **ragnar** = Chat searches documents first (RAG)

## Common Integration Patterns

### Chat + Context Tools

```r
library(ellmer)
library(btw)
chat <- chat_openai()
chat$set_tools(btw_tools())
```

### Chat + RAG

```r
library(ellmer)
library(ragnar)
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)
```

### Agent Access to R

```r
library(mcptools)
mcp_session()  # In console, each startup
# Now Claude Code can run R code
```

### Fully Local (Ollama)

```r
library(ellmer)
chat <- chat_ollama(model = "llama3.2")

library(ragnar)
store <- ragnar_store_create("local.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))
```

### RAG Evaluation

```r
library(vitals)
library(ellmer)
library(ragnar)

chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)

task <- Task$new(
  dataset = test_cases,
  solver = function(input) chat$chat(input, echo = "none"),
  scorer = model_graded_qa()
)
task$run()
```

## Advanced

See `references/` for:
- **integration-patterns.md**: Full cross-package integration examples

For package-specific documentation, invoke the individual package skills above.
