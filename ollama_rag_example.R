# ============================================================================
# Setup: Ollama + ellmer + ragnar for fully local RAG
# ============================================================================
# Scenario: Use local Ollama model instead of OpenAI
# Prerequisites: Ollama must be running (ollama serve)
# ============================================================================

library(ellmer)
library(ragnar)

# ============================================================================
# 1. CREATE OR REOPEN A LOCAL VECTOR STORE
# ============================================================================

# Path to store (persists embeddings to disk)
store_path <- "my_local_rag.duckdb"

# Option A: Create new store (first time only)
# Must specify Ollama as embedding provider
store <- ragnar_store_create(
  store_path,
  embed = ragnar_embed_ollama(model = "nomic-embed-text")
  # Note: Pull the model first if needed: ollama pull nomic-embed-text
)

# Option B: Reopen existing store (subsequent sessions)
# store <- ragnar_store_connect(store_path)

# ============================================================================
# 2. ADD DOCUMENTS TO THE STORE
# ============================================================================

# Read documents (supports PDF, markdown, HTML, text)
# For this example, assume we have docs in a local directory:
docs <- read_as_markdown("path/to/docs/")  # Directory or single file

# Chunk documents (split into retrieval-sized pieces)
chunks <- markdown_chunk(docs)

# Insert into store (will embed with Ollama)
ragnar_store_insert(store, chunks)

# ============================================================================
# 3. CREATE CHAT CLIENT WITH LOCAL OLLAMA MODEL
# ============================================================================

# Create chat client using local Ollama model
# Model must be pulled first: ollama pull llama3.2
chat <- chat_ollama(model = "llama3.2")

# Optional: Specify custom Ollama server URL (default is http://localhost:11434)
# chat <- chat_ollama(model = "llama3.2", api_url = "http://localhost:11434")

# ============================================================================
# 4. REGISTER RAG RETRIEVAL WITH CHAT
# ============================================================================

# Link the store to the chat - now chat can retrieve relevant docs
ragnar_register_tool_retrieve(chat, store)

# ============================================================================
# 5. CHAT WITH RAG (DOCUMENTS ARE AUTOMATICALLY RETRIEVED)
# ============================================================================

# Interactive mode (output goes to console)
chat$chat("Based on the documentation, how do I handle errors?")

# Programmatic mode (capture response)
response <- chat$chat(
  "What are the main features described?",
  echo = "none"  # Suppress console output
)
print(response)

# ============================================================================
# 6. OPTIONAL: MANUAL RETRIEVAL (INSPECT BEFORE PASSING TO LLM)
# ============================================================================

# Search store directly
results <- ragnar_retrieve(store, "error handling patterns")

# Consolidate overlapping chunks
consolidated <- chunks_deoverlap(results)

# Inspect what will be sent to LLM
print(consolidated)

# ============================================================================
# 7. FULL WORKFLOW: SETUP → QUERY → INSPECT
# ============================================================================

# Minimal example for fresh start:
{
  # Create store with Ollama embeddings
  store <- ragnar_store_create(
    "docs.duckdb",
    embed = ragnar_embed_ollama(model = "nomic-embed-text")
  )

  # Add documents
  docs <- read_as_markdown("C:/path/to/docs/")
  chunks <- markdown_chunk(docs)
  ragnar_store_insert(store, chunks)

  # Create Ollama chat and register retrieval
  chat <- chat_ollama(model = "llama3.2")
  ragnar_register_tool_retrieve(chat, store)

  # Query with automatic retrieval
  answer <- chat$chat(
    "Summarize the key concepts",
    echo = "none"
  )
  print(answer)
}

# ============================================================================
# TROUBLESHOOTING
# ============================================================================

# If you get "connection refused" error:
# - Ensure Ollama is running: ollama serve
# - Check Ollama is on localhost:11434 (default)

# If embedding model not found:
# - Pull the model: ollama pull nomic-embed-text
# - Verify with: ollama list

# If chat model not found:
# - Pull the model: ollama pull llama3.2
# - List available: ollama list

# To use different models:
# chat <- chat_ollama(model = "mistral")
# store <- ragnar_store_create(path, embed = ragnar_embed_ollama(model = "mxbai-embed-large"))
