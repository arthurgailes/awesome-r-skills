# Getting Started with ellmer

## Overview
The ellmer R package provides access to large language models (LLMs). Treat LLMs as "convenient black boxes" while building foundational understanding through practical examples.

## Core Vocabulary

### Prompts and Conversations
A **prompt** is user input sent to an LLM, initiating a **conversation**—a sequence of alternating user prompts and model responses. Both the prompt and response are represented by a sequence of tokens.

### Tokens
Tokens represent individual words or word components used by models for computation. Example: "When was R created?" converts to 5 tokens. "counterrevolutionary" requires 4 tokens: counter, re, volution, ary.

**Pricing context**: State-of-the-art models cost $2-3 per million input tokens, while cheaper models cost substantially less ($0.10-$0.40 per million tokens).

### Providers vs. Models
A **provider** delivers access to one or more **models**. Examples: OpenAI (GPT), Anthropic (Claude), Ollama, AWS Bedrock.

### System Prompts
Platform prompts (set by providers), system prompts (created per conversation), and user prompts. When programming with LLMs, you'll primarily iterate on the system prompt.

## Practical Applications

### Chatbots
Custom chatbots provide domain-specific knowledge by preloading prompts with documentation, package information, or educational materials. Examples: ellmer assistant, Shiny Assistant.

### Structured Data Extraction
LLMs excel at converting unstructured text to organized formats—sentiment analysis, geocoding, recipe parsing, document indexing via image processing.

### Programming Assistance
- Code modernization
- Documentation lookup integration
- Code explanation
- Security analysis
- Issue labeling automation
- Cross-language code conversion

### Additional Uses
- Automated alt text generation for plots
- Statistical reasoning analysis
- Brand style guide implementation

## Code Example

```r
chat <- chat_openai(model = "gpt-4.1")
. <- chat$chat("Who created R?", echo = FALSE)
chat
token_usage()
```

This shows token costs and conversation history management within ellmer.

## Key Recommendations
- Keep conversations short to manage costs
- Start fresh conversations rather than extended back-and-forths to avoid local optimization
- Use LLMs for rapid prototyping, not accuracy-critical work
- Prioritize system prompt iteration during development
