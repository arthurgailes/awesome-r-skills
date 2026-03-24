---
name: r-mcptools
description: Use when connecting AI agents (Claude Code, VS Code) to running R sessions, letting agents execute R code, or exposing R as MCP server
---

# mcptools: R as Model Context Protocol Server

## Overview

**mcptools lets AI agents INTO your R session.** Agents (Claude Code, VS Code, etc.) can run R code, query data, call functions in your live R environment.

**btw vs mcptools:** btw gives tools TO ellmer (R → LLM). mcptools lets agents INTO R (LLM → R).

**Install:** `install.packages("mcptools")`

<MANDATORY-CONTEXT>
Before using this skill, you MUST read:

□ `references/API.md` - Complete function reference
□ `references/package-docs.md` - Setup and configuration
□ `references/server.md` - MCP server setup and agent configuration

DO NOT write code until verifying all references above are read.
</MANDATORY-CONTEXT>

## When to Use

- Let Claude Code/VS Code run R code
- Give agents access to live R session
- Expose R functions as MCP tools
- Query R data stores from agents

## When NOT to Use

- Want to call LLMs FROM R (use r-ellmer)
- Just need R object descriptions (use r-btw)
- Building chatbot in R (use r-ellmer + r-btw)

## Quick Reference

```r
library(mcptools)

# In R console (each startup, NOT in scripts)
mcp_session()

# Now Claude Code can:
# - Run R code
# - Query data frames
# - Call your R functions
# - Access documentation
```

**CRITICAL:** Call `mcp_session()` in console at each R startup, NOT in scripts.

## Common Mistakes

| Issue | Solution |
|-------|----------|
| btw vs mcptools confusion | btw = tools TO chat; mcptools = agent INTO R |
| mcp_session() in scripts | Call in console, each startup |
| Expecting clipboard copy | mcptools is for agent access, not clipboard |
| Session not detected | Restart R, call mcp_session() in console |

## Core Functions

**Session Management:**
- `mcp_session()`: Initialize MCP session (console only, per startup)
- `mcp_mcp_server()`: Launch MCP server

## Advanced

See `references/` for:
- **API.md**: Complete function reference
- **server.md**: R as MCP server details
- **Package docs**: Full package documentation

## Integration

**With Claude Code:** Call `mcp_session()` in R console
**With ragnar:** Agents can query ragnar stores
**Cross-package patterns:** See r-ai meta-skill
