# ragnar Reference

## Document Processing

```r
# Read documents (returns markdown)
docs <- read_as_markdown("path/to/file.pdf")
docs <- read_as_markdown("path/to/docs/")      # Directory
docs <- read_as_markdown("https://example.com/page.html")

# Supported formats: PDF, markdown, HTML, text, docx

# Extract links from webpage
links <- ragnar_find_links("https://docs.example.com")
```

## Chunking

```r
# Semantic chunking (preserves headings)
chunks <- markdown_chunk(docs)

# Custom chunk size
chunks <- markdown_chunk(docs, chunk_size = 1000, chunk_overlap = 200)
```

Chunks include metadata: source file, headings hierarchy, position.

## Embedding Providers

```r
# OpenAI (default)
store <- ragnar_store_create("store.duckdb")  # Uses OPENAI_API_KEY

# Ollama (local)
store <- ragnar_store_create("store.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))

# Other providers
embed = ragnar_embed_openai(model = "text-embedding-3-small")
embed = ragnar_embed_azure_openai(
  endpoint = "https://your-resource.openai.azure.com",
  deployment_id = "your-embedding-deployment",
  api_version = "2024-02-01"
)
embed = ragnar_embed_bedrock(model = "...")
embed = ragnar_embed_google(model = "...")
embed = ragnar_embed_databricks(model = "...")
```

## Store Operations

```r
# Create new store
store <- ragnar_store_create("docs.duckdb")

# Open existing store
store <- ragnar_store_connect("docs.duckdb")

# Insert chunks
ragnar_store_insert(store, chunks)

# Check store contents
ragnar_store_list(store)
ragnar_store_count(store)
```

## Retrieval

```r
# Basic retrieval (hybrid: vector + BM25)
results <- ragnar_retrieve(store, "search query")
results <- ragnar_retrieve(store, "query", k = 10)  # Top 10

# Consolidate overlapping chunks
results <- chunks_deoverlap(results)

# Vector-only or BM25-only
results <- ragnar_retrieve(store, "query", method = "vector")
results <- ragnar_retrieve(store, "query", method = "bm25")
```

## Chat Integration

```r
# Register retrieval as chat tool
chat <- chat_openai()
ragnar_register_tool_retrieve(chat, store)

# LLM automatically retrieves when needed
chat$chat("What does the documentation say about X?")

# Custom tool name/description
ragnar_register_tool_retrieve(chat, store,
  name = "search_manual",
  description = "Search the user manual for information")
```

## Multiple Stores

```r
# Different stores for different doc types
api_store <- ragnar_store_connect("api_docs.duckdb")
manual_store <- ragnar_store_connect("user_manual.duckdb")

# Register both
ragnar_register_tool_retrieve(chat, api_store, name = "search_api")
ragnar_register_tool_retrieve(chat, manual_store, name = "search_manual")
```

## Incremental Updates

```r
# Add new documents to existing store
store <- ragnar_store_connect("docs.duckdb")
new_docs <- read_as_markdown("new_file.md")
new_chunks <- markdown_chunk(new_docs)
ragnar_store_insert(store, new_chunks)
```
