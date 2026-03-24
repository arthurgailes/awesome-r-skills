---
name: r-btw
description: Use when providing R context (docs, data, git info) to LLMs, registering tools for ellmer chat sessions, or copying R object descriptions to clipboard
---

# btw: Context Tools for R and LLMs

## Overview

**btw connects R's context to LLMs.** Provides tools that describe R objects, fetch documentation, and expose R information to chat sessions.

**btw vs mcptools:** btw gives tools TO ellmer (R → LLM). mcptools lets agents INTO R (LLM → R).

**Install:** `install.packages("btw")`

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/API.md` - Complete function reference
□ `references/package-docs.md` - Tool registration and usage patterns

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>

## When to Use

- Copy R object descriptions to clipboard for LLMs
- Register R documentation tools with ellmer
- Give chat sessions access to R help, data frames, packages
- Create project context files (btw.md)

## When NOT to Use

- Want agents to run R code (use r-mcptools)
- Just need to print object (use `print()` or `str()`)
- One-off manual description (just copy/paste)

## Quick Reference

```r
library(btw)

# Copy description to clipboard
btw(mtcars)           # Describe data frame
btw("ggplot2")        # Package documentation
btw_this(model)       # For LLM consumption

# Register tools with ellmer
library(ellmer)
chat <- chat_openai()
chat$set_tools(btw_tools())

# Now chat can call R documentation
chat$chat("What functions does dplyr have?")

# Project context
use_btw_md()    # Create btw.md
edit_btw_md()   # Edit context file
```

## Common Mistakes

| Issue | Solution |
|-------|----------|
| btw vs mcptools confusion | btw = tools TO chat; mcptools = agent INTO R |
| Tools not registered | Must call `chat$set_tools(btw_tools())` |
| Using in scripts vs console | btw() for clipboard works in console |
| Expecting code execution | btw describes, doesn't execute (use mcptools) |

## Core Functions

**Description:**
- `btw()`: Generate plain-text descriptions (copies to clipboard)
- `btw_this()`: Create LLM-optimized descriptions

**Integration:**
- `btw_tools()`: Register with ellmer
- `btw_client()`: btw-enhanced ellmer chat
- `btw_app()`: btw-enhanced ellmer app

**Project Context:**
- `use_btw_md()`: Create project context file
- `edit_btw_md()`: Modify context file

## Advanced

See `references/` for:
- **API.md**: Complete function reference
- **Package docs**: Full package documentation

## Integration

**With ellmer:** `chat$set_tools(btw_tools())`
**Cross-package patterns:** See r-ai meta-skill
