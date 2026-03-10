# vitals API Reference

Complete function reference for the vitals package - Large Language Model Evaluation for R.

## Evaluation Tasks

| Function | Purpose |
|----------|---------|
| `Task()` | Creating and evaluating tasks |

**Example:**
```r
library(vitals)

# Create evaluation task
task <- Task$new(
  dataset = test_cases,
  solver = generate(),
  scorer = model_graded_qa()
)

# Run evaluation
task$run(chat_openai())

# View results
vitals_view()
```

## Solvers

| Function | Purpose |
|----------|---------|
| `generate()` | Convert a chat to a solver function |

**Example:**
```r
# Basic solver
solver <- generate()

# Solver with system prompt
solver <- generate(
  system = "You are an R programming expert."
)

# Use in task
task <- Task$new(
  dataset = data,
  solver = generate(),
  scorer = model_graded_qa()
)
```

## Scorers

### Model-Based Scoring

| Function | Purpose |
|----------|---------|
| `model_graded_qa()` | Evaluate responses using model-based quality assessment |
| `model_graded_fact()` | Evaluate responses using model-based factual accuracy |

**Example:**
```r
# QA grading
scorer <- model_graded_qa()

# Fact checking
scorer <- model_graded_fact()

# Use in task
task <- Task$new(
  dataset = data,
  solver = generate(),
  scorer = model_graded_qa()
)
```

### String Detection Scoring

| Function | Purpose |
|----------|---------|
| `detect_includes()` | Check if response contains specified substring |
| `detect_match()` | Identify pattern matches in responses |
| `detect_pattern()` | Evaluate against regex or text patterns |
| `detect_exact()` | Compare for exact string correspondence |
| `detect_answer()` | Validate answer presence and format |

**Example:**
```r
# Check for substring
scorer <- detect_includes("ggplot2")

# Regex pattern
scorer <- detect_pattern("^[0-9]+$")

# Exact match
scorer <- detect_exact()

# Multiple scorers
task <- Task$new(
  dataset = data,
  solver = generate(),
  scorer = list(
    detect_includes("correct answer"),
    model_graded_qa()
  )
)
```

## Log Management & Deployment

| Function | Purpose |
|----------|---------|
| `vitals_log_dir()` | Get the log directory |
| `vitals_log_dir_set()` | Configure storage location for evaluation logs |
| `vitals_view()` | Interactively view local evaluation logs |
| `vitals_bundle()` | Prepare logs for deployment |
| `vitals_bind()` | Concatenate task samples for analysis |

**Example:**
```r
# Set log directory
vitals_log_dir_set("~/eval-logs")

# View results interactively
vitals_view()

# Bundle for sharing
vitals_bundle("eval_results.zip")

# Combine results
all_results <- vitals_bind(c("log1", "log2"))
```

## Example Evals

| Function | Purpose |
|----------|---------|
| `are()` | An R Eval - example dataset for R coding evaluation |

**Example:**
```r
# Use built-in R eval dataset
task <- Task$new(
  dataset = are(),
  solver = generate(),
  scorer = model_graded_qa()
)

task$run(chat_openai())
```

## Complete Evaluation Workflow

```r
library(vitals)
library(ellmer)

# 1. Create test dataset
test_cases <- tibble::tibble(
  input = c(
    "Explain the pipe operator",
    "What is a data frame?",
    "How do you filter rows in dplyr?"
  ),
  target = c(
    "The pipe operator |> passes the left side as first argument to the right",
    "A data frame is a 2D table with rows and columns",
    "Use dplyr::filter() with logical conditions"
  )
)

# 2. Create task
task <- Task$new(
  dataset = test_cases,
  solver = generate(),
  scorer = model_graded_qa()
)

# 3. Run evaluation
task$run(chat_openai(model = "gpt-4o"))

# 4. View results
vitals_view()

# 5. Compare models
task$run(chat_anthropic(model = "claude-sonnet-4.5"))
vitals_view()
```

## Documentation

**Package site:** https://vitals.tidyverse.org/
**GitHub:** https://github.com/tidyverse/vitals
**Blog post:** https://tidyverse.org/blog/2025/06/vitals-0-1-0/
