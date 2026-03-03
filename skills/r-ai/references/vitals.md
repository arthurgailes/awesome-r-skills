# vitals Reference

## Task Structure

```r
library(vitals)

task <- Task$new(
  dataset = my_dataset,    # tibble with input/target columns
  solver = my_solver,      # Function that generates output
  scorer = my_scorer       # Function that grades output
)

task$run(chat_openai())    # Run evaluation
task$view()                # Interactive results viewer
```

## Datasets

Tibble with required columns:

```r
dataset <- tibble::tibble(
  input = c("Question 1", "Question 2"),
  target = c("Expected answer 1", "Expected answer 2")
)

# Optional: additional context columns
dataset <- tibble::tibble(
  input = c("What is X?", "Explain Y"),
  target = c("X is ...", "Y means ..."),
  context = c("Background info 1", "Background info 2")
)
```

## Built-in Solvers

```r
# Pass input directly to chat
solver = generate()

# With system prompt
solver = generate(system_prompt = "You are a helpful assistant")

# Chain of thought
solver = generate(system_prompt = "Think step by step")
```

## Custom Solvers

```r
# Simple custom solver
my_solver <- function(input) {
  chat$chat(input, echo = "none")
}

# RAG-enabled solver
rag_solver <- function(input) {
  # chat already has ragnar tool registered
  chat$chat(input, echo = "none")
}

# Multi-step solver
complex_solver <- function(input) {
  step1 <- chat$chat(paste("Analyze:", input), echo = "none")
  step2 <- chat$chat(paste("Summarize:", step1), echo = "none")
  step2
}
```

## Built-in Scorers

```r
# LLM judges if output matches target
scorer = model_graded_qa()

# Exact match
scorer = exact_match()

# Contains target text
scorer = includes()

# Semantic similarity
scorer = semantic_similarity()
```

## Custom Scorers

Scorers receive `output` (solver result) and `target` (expected answer). Return:
- Character: `"correct"`, `"incorrect"`, `"partial"`
- Numeric: 0-1 score

```r
# Binary scorer
my_scorer <- function(output, target) {
  if (grepl(target, output, ignore.case = TRUE)) "correct" else "incorrect"
}

# Numeric scorer (0-1)
my_scorer <- function(output, target) {
  stringsim::stringsim(output, target)
}

# Keyword coverage scorer
keyword_scorer <- function(output, target) {
  keywords <- strsplit(target, ",")[[1]]
  found <- sum(sapply(keywords, function(k) grepl(k, output, ignore.case = TRUE)))
  found / length(keywords)
}
```

## Running Evaluations

```r
# Basic run
task$run(chat_openai())

# With specific model
task$run(chat_anthropic(model = "claude-sonnet-4-20250514"))

# Parallel evaluation
task$run(chat_openai(), parallel = TRUE)
```

## Inspecting Results

```r
# Interactive viewer
task$view()

# Get results as tibble
results <- task$results()

# Summary statistics
task$summary()
```

## Multi-Task Evaluation

```r
# Compare models
task1 <- Task$new(dataset, solver, scorer)
task2 <- Task$new(dataset, solver, scorer)

task1$run(chat_openai(model = "gpt-4o"))
task2$run(chat_openai(model = "gpt-4o-mini"))

# Compare in viewer
task1$view()
task2$view()
```

## Logging

Results are saved to inspect logs for later review:

```r
# View past evaluations
vitals_logs()

# Load specific log
vitals_load_log("path/to/log")
```
