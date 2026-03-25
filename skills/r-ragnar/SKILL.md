---
name: r-ragnar
description: Use when code loads or uses ragnar (library(ragnar), ragnar::), implementing RAG in R, creating vector stores, embedding documents for semantic search, or building retrieval pipelines
---

# ragnar: Retrieval Augmented Generation in R

## Overview

**ragnar implements RAG in R.** Create vector stores, embed documents, register retrieval tools with ellmer chat sessions. LLMs search your documents before answering.

**Install:** `install.packages("ragnar")`

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/API.md` - Complete function reference
□ `references/package-docs.md` - Vector store setup and usage
□ `references/rag.md` - RAG patterns and ellmer integration

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>

## When to Use

- LLM needs to search your documentation
- Implement semantic search over documents
- Create vector database from documents
- RAG workflows in R

## When NOT to Use

- Just need keyword search (use grep/Grep tool)
- Documents fit in single prompt (<100k tokens)
- Building chatbot without document search (use r-ellmer only)

## Quick Reference

```r
library(ragnar)

# Create store
docs <- read_as_markdown("docs/")
chunks <- markdown_chunk(docs)
store <- ragnar_store_create("docs.duckdb")
ragnar_store_insert(store, chunks)

# Register with ellmer
library(ellmer)
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)

# Now chat searches docs before answering
chat$chat("What does the documentation say about...?")

# Local embeddings (Ollama)
store <- ragnar_store_create("local.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))
```

## Common Mistakes

| Issue | Solution |
|-------|----------|
| Embedding mismatch | Store and retrieval must use same provider |
| Store not registered | Call `ragnar_register_tool_retrieve(chat, store)` |
| Ollama embeddings not working | Start `ollama serve` first |
| Poor retrieval quality | Check chunking strategy, embedding model |

## Core Functions

**Store Management:**
- `ragnar_store_create()`: Create vector database
- `ragnar_store_connect()`: Connect to existing store
- `ragnar_store_insert()`: Add documents

**Document Processing:**
- `read_as_markdown()`: Read documents
- `markdown_chunk()`: Split into chunks

**Integration:**
- `ragnar_register_tool_retrieve()`: Register with ellmer
- `ragnar_embed_ollama()`: Local embeddings

## Advanced

See `references/` for:
- **API.md**: Complete function reference
- **rag.md**: RAG workflow details
- **Package docs**: Full package documentation

## Integration

**With ellmer:** `ragnar_register_tool_retrieve(chat, store)`
**With vitals (evaluation):** See r-vitals skill for RAG testing
**Cross-package patterns:** See r-ai meta-skill
