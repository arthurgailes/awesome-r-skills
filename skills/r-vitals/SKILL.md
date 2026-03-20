---
name: r-vitals
description: Use when evaluating LLM output quality, testing RAG retrieval accuracy, scoring AI-generated responses, or benchmarking prompt changes
---

# vitals: LLM Evaluation and Testing

## Overview

**vitals tests LLM output quality.** Create test datasets, define solvers (LLM pipelines), score outputs. Benchmark RAG systems, prompt changes, model performance.

**Install:** `install.packages("vitals")`

## When to Use

- Test LLM output quality
- Evaluate RAG retrieval accuracy
- Benchmark different prompts/models
- Score AI-generated responses
- Create LLM test suites

## When NOT to Use

- Just running one test case manually
- Traditional unit testing (use testthat)
- Non-LLM code testing

## Quick Reference

```r
library(vitals)

# Create test dataset
test_cases <- tibble::tibble(
  input = c("question 1", "question 2"),
  target = c("answer 1", "answer 2")
)

# Define solver (your LLM pipeline)
chat <- chat_openai()
solver <- function(input) {
  chat$chat(input, echo = "none")
}

# Run evaluation
task <- Task$new(
  dataset = test_cases,
  solver = solver,
  scorer = model_graded_qa()
)
task$run()
task$view()

# Test RAG system
ragnar_register_tool_retrieve(chat, store)
task$run(chat)  # Tests with RAG
```

## Common Mistakes

| Issue | Solution |
|-------|----------|
| No test dataset | Create tibble with input/target columns |
| Solver not function | Wrap chat in function: `function(input) chat$chat(input)` |
| Using for non-LLM tests | Use testthat for traditional testing |
| Forgetting echo = "none" | Solver should return text, not print |

## Core Functions

**Task Management:**
- `Task$new()`: Create evaluation task
- `task$run()`: Execute tests
- `task$view()`: View results

**Scorers:**
- `model_graded_qa()`: LLM grades Q&A quality
- Custom scorers for specific domains

## Advanced

See `references/` for:
- **API.md**: Complete function reference
- **Package docs**: Full package documentation

## Integration

**With ellmer:** Test chat quality
**With ragnar:** Evaluate RAG accuracy
**Cross-package patterns:** See r-ai meta-skill
