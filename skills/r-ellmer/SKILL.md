---
name: r-ellmer
description: Use when chatting with LLMs from R, creating chatbots, extracting structured data from text, or needing multi-provider LLM access (OpenAI, Claude, Ollama, etc.)
---

# ellmer: R Interface to Large Language Models

## Overview

**ellmer is the hub of the R AI stack.** Provides unified interface to 20+ LLM providers (OpenAI, Claude, Ollama, etc.) with stateful chat sessions, tool calling, and token tracking.

**Install:** `install.packages("ellmer")`

**API keys:** Set `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` in `.Renviron`

## When to Use

- Chat with any LLM from R
- Create custom chatbots with domain knowledge
- Extract structured data from unstructured text
- Need multi-provider support (switch between OpenAI/Claude/Ollama)
- Build LLM-powered R applications

## When NOT to Use

- Single one-off HTTP request (use httr2)
- Need streaming with custom callbacks
- Non-chat ML workflows (use tidymodels)

## Quick Reference

```r
# Create chat
chat <- chat_openai(model = "gpt-4o")
chat <- chat_claude(model = "claude-sonnet-4")
chat <- chat_ollama(model = "llama3.2")  # Local

# Chat (stateful - history preserved)
chat$chat("Explain this error")
chat$chat("How do I fix it?")  # Remembers context

# Fresh conversation
chat <- chat_openai()  # New = no history

# Track costs
token_usage()

# Tool calling
chat$set_tools(btw_tools())  # See r-btw skill
```

## Common Mistakes

| Issue | Solution |
|-------|----------|
| Forgot API key | Set in `.Renviron`, restart R |
| Ollama connection error | Run `ollama serve` first |
| Conversation too long/expensive | Start fresh chat for new topics |
| Expecting accuracy | LLMs for prototyping, not critical work |
| Using chat for single request | Just use httr2 for one-off calls |

## Use Cases

**Custom chatbots:** Preload with documentation, package info, educational materials

**Structured data extraction:** Sentiment analysis, geocoding, recipe parsing, document indexing

**Programming assistance:** Code modernization, documentation lookup, explanation, security analysis

**Other:** Alt text generation, statistical reasoning, brand style guide enforcement

## Advanced

See `references/` for:
- **API.md**: Complete function reference (all providers, models, methods)
- **getting-started.md**: Core vocabulary, tokens, system prompts
- **tool-calling.md**: Tool/function calling patterns

## Integration

**With btw (context tools):** See r-btw skill
**With ragnar (RAG):** See r-ragnar skill
**With vitals (evaluation):** See r-vitals skill
**Cross-package patterns:** See r-ai meta-skill
