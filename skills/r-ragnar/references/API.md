# ragnar API Reference

Complete function reference for the ragnar package - Retrieval-Augmented Generation (RAG) in R.

## Document Processing

| Function | Purpose |
|----------|---------|
| `read_as_markdown()` | Convert files to Markdown |
| `MarkdownDocument` | Markdown documents object |
| `ragnar_find_links()` | Find links on a page |

**Example:**
```r
library(ragnar)

# Read documents
docs <- read_as_markdown("docs/")

# Find links in a page
links <- ragnar_find_links("https://example.com")
```

## Text Chunking

| Function | Purpose |
|----------|---------|
| `markdown_chunk()` | Chunk a Markdown document |
| `MarkdownDocumentChunks` | Markdown documents chunks object |
| `ragnar_chunks_view()` | View chunks with the store inspector |

**Example:**
```r
# Chunk documents
chunks <- markdown_chunk(docs)

# View chunks interactively
ragnar_chunks_view(chunks)
```

## Store Management

| Function | Purpose |
|----------|---------|
| `ragnar_store_create()` | Create a vector store |
| `ragnar_store_connect()` | Connect to an existing vector store |
| `ragnar_store_insert()` | Insert chunks into a store |
| `ragnar_store_update()` | Update chunks in a store |
| `ragnar_store_ingest()` | Concurrently ingest documents into a store |
| `ragnar_store_build_index()` | Build a store index |
| `ragnar_store_inspect()` | Launch the Store Inspector |
| `ragnar_store_atlas()` | Visualize a store using Embedding Atlas |

**Example:**
```r
# Create store with OpenAI embeddings
store <- ragnar_store_create(
  "docs.duckdb",
  embed = embed_openai()
)

# Insert chunks
ragnar_store_insert(store, chunks)

# Build index for faster search
ragnar_store_build_index(store)

# Inspect store
ragnar_store_inspect(store)

# Visualize embeddings
ragnar_store_atlas(store)
```

## Embeddings

| Function | Purpose |
|----------|---------|
| `embed_openai()` | Embed text using OpenAI models |
| `embed_ollama()` | Embed text using Ollama models |
| `embed_lm_studio()` | Embed text using LM Studio |
| `embed_azure_openai()` | Create embeddings via Azure AI Foundry |
| `embed_bedrock()` | Embed text using AWS Bedrock model |
| `embed_databricks()` | Embed text using Databricks model |
| `embed_google_gemini()` | Embed using Google Gemini API |
| `embed_google_vertex()` | Embed using Google Vertex API |
| `embed_snowflake()` | Generate embeddings using Snowflake |

**Example:**
```r
# OpenAI embeddings
store <- ragnar_store_create("store.duckdb", embed = embed_openai())

# Local Ollama embeddings (no API key)
store <- ragnar_store_create(
  "local.duckdb",
  embed = embed_ollama(model = "nomic-embed-text")
)
```

## Retrieval

| Function | Purpose |
|----------|---------|
| `ragnar_retrieve()` | Retrieve chunks from a store |
| `ragnar_retrieve_bm25()` | Retrieve chunks using BM25 score |
| `ragnar_retrieve_vss()` | Vector Similarity Search Retrieval |
| `ragnar_register_tool_retrieve()` | Register a 'retrieve' tool with ellmer |
| `mcp_serve_store()` | Serve a Ragnar store over MCP |
| `chunks_deoverlap()` | Merge overlapping chunks in results |

**Example:**
```r
# Retrieve chunks
results <- ragnar_retrieve(store, "query text")

# BM25 retrieval (keyword-based)
results <- ragnar_retrieve_bm25(store, "query text", k = 5)

# Vector similarity search
results <- ragnar_retrieve_vss(store, "query text", k = 5)

# Register with ellmer chat
library(ellmer)
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)

# Now chat can retrieve from store
chat$chat("What does the documentation say about RAG?")

# Deoverlap results
results |> chunks_deoverlap()
```

## Complete RAG Workflow

```r
library(ragnar)
library(ellmer)

# 1. Read and chunk documents
docs <- read_as_markdown("docs/")
chunks <- markdown_chunk(docs)

# 2. Create store and insert
store <- ragnar_store_create("docs.duckdb", embed = embed_openai())
ragnar_store_insert(store, chunks)
ragnar_store_build_index(store)

# 3. Connect to chat
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)

# 4. Query with retrieval
chat$chat("Explain the key concepts from the documentation")
```

## Documentation

**Package site:** https://ragnar.tidyverse.org/
**GitHub:** https://github.com/tidyverse/ragnar
**Blog post:** https://tidyverse.org/blog/2025/08/ragnar-0-2/
