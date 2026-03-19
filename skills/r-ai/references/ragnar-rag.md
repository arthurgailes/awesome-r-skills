# RAG (Retrieval-Augmented Generation) with ragnar

## Overview

The ragnar package provides tools for building RAG workflows in R, emphasizing transparency and control at each step. This approach grounds LLM outputs with external, trusted content.

## The Hallucination Problem

Large language models generate fluent responses without necessarily understanding truth. LLMs operate on text sequences; they do not seem to possess a concept of 'facts' and 'truth' like humans do. RAG addresses this by retrieving relevant excerpts from verified sources and asking the LLM to summarize or answer using only that material.

## Use Case: Documentation Chat

Rather than traditional search requiring precise wording, a RAG-powered chat tool accepts natural language questions, retrieves relevant excerpts, and returns contextualized answers with source links.

## Setting Up RAG

### Creating the Store

```r
store_location <- "quarto.ragnar.duckdb"
store <- ragnar_store_create(
  store_location,
  embed = \(x) ragnar::embed_openai(x, model = "text-embedding-3-small")
)
```

Multiple embedding providers supported: `embed_ollama()`, `embed_openai()`, `embed_google_vertex()`, `embed_bedrock()`, `embed_databricks()`.

### Document Identification

```r
paths <- ragnar_find_links("https://quarto.org/", depth = 3)
```

### Converting to Markdown

Transform documents using `read_as_markdown()`, which handles PDFs, DOCX, PPTX, HTML, ZIP files, and EPUBs. This maintains low token counts and works well for both humans and LLMs.

### Chunking and Augmentation

```r
chunks <- path |>
  read_as_markdown() |>
  markdown_chunk()
```

The function automatically adjusts chunk boundaries to semantic breaks and extracts markdown headings as context.

### Inserting and Building

```r
for (path in paths) {
  chunks <- path |>
    read_as_markdown() |>
    markdown_chunk()
  ragnar_store_insert(store, chunks)
}

ragnar_store_build_index(store)
```

## Retrieval Methods

`ragnar_retrieve()` uses two approaches:
- **Vector Similarity Search**: Finds semantically related content
- **BM25**: Performs keyword-based matching

## Registering as an LLM Tool

```r
client <- ellmer::chat_openai()
ragnar_register_tool_retrieve(
  client, store, top_k = 10,
  description = "the quarto website"
)
```

## Custom Retrieval Implementation

For specialized tasks, define custom tools with system prompts:

```r
client$set_system_prompt(glue::trim(
  "You are an expert in Quarto documentation. Always perform a
  search for each user request. If initial results lack relevance,
  perform up to three additional searches returning unique excerpts."
))
```

Implement stateful retrieval excluding previously retrieved chunks:

```r
rag_retrieve_quarto_excerpts <- local({
  retrieved_chunk_ids <- integer()
  function(text) {
    chunks <- ragnar::ragnar_retrieve(
      text,
      top_k = 10,
      filter = !.data$chunk_id %in% retrieved_chunk_ids
    )
    retrieved_chunk_ids <<- unique(c(retrieved_chunk_ids, chunks$chunk_id))
    chunks
  }
})
```

## Troubleshooting and Iteration

Development requires iterative refinement: source selection, markdown conversion, chunking strategy, chunk augmentation, metadata filtering, embedding model choice, LLM selection, system prompts, and tool definitions.

Use `ragnar_store_inspect()` to interactively evaluate retrieval results and confirm that chunking preserves semantic meaning.
