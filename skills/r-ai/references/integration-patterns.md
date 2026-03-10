# Integration Patterns

Cross-package patterns for combining the R AI stack.

## Chat + Context Tools

Give ellmer access to R documentation and data:

```r
chat <- chat_openai()
chat$set_tools(btw_tools())
```

## Chat + RAG

Let ellmer search your documentation:

```r
store <- ragnar_store_connect("docs.duckdb")
ragnar_register_tool_retrieve(chat, store)
```

## Agent Access + RAG

Let Claude Code/VS Code query your R data store:

```r
# In R console (not scripts)
mcp_session()

# Now Claude Code can call R functions and query ragnar stores
```

## Fully Local Stack (Ollama)

No API keys, all local:

```r
# Chat
chat <- chat_ollama(model = "llama3.2")

# RAG with local embeddings
store <- ragnar_store_create("local.duckdb",
  embed = ragnar_embed_ollama(model = "nomic-embed-text"))

# Start Ollama first: ollama serve
```

## RAG Evaluation Pipeline

Test retrieval quality:

```r
# Create test dataset
test_cases <- tibble::tibble(
  input = c("question 1", "question 2"),
  target = c("answer 1", "answer 2")
)

# Define solver that uses RAG
rag_solver <- function(input) {
  chat$chat(input, echo = "none")
}

# Evaluate
task <- Task$new(
  dataset = test_cases,
  solver = rag_solver,
  scorer = model_graded_qa()
)
task$run()
task$view()
```

## Context + RAG + Evaluation

Full stack integration:

```r
# Setup chat with all context
chat <- chat_openai()
chat$set_tools(btw_tools())
ragnar_register_tool_retrieve(chat, store)

# Evaluate the integrated system
task <- Task$new(
  dataset = validation_set,
  solver = function(input) chat$chat(input, echo = "none"),
  scorer = model_graded_qa()
)
task$run()
```
