# mcptools + btw Reference

## Overview

**mcptools**: MCP infrastructure for R - connects R sessions to Claude Code
**btw**: Tools that mcptools exposes - docs, environments, code execution

## How They Work Together

```
Claude Code <--MCP--> mcptools <---> btw tools <---> R session
```

mcptools provides the transport; btw provides the capabilities.

## mcptools Functions

| Function | Purpose |
|----------|---------|
| `mcp_server()` | Start MCP server (called by Claude Code) |
| `mcp_session()` | Register active R session for access |
| `mcp_tools()` | Use external MCP servers as ellmer tools |

## btw Functions

| Function | Purpose |
|----------|---------|
| `btw()` | Gather context, copy to clipboard |
| `btw_tools()` | Get tool definitions for LLM integration |
| `btw_this()` | Describe R object for LLM |
| `btw_client()` | Pre-configured ellmer chat client |
| `btw_app()` | Interactive chat UI |
| `btw_mcp_server()` | Start MCP server with btw tools |

## btw Tool Categories

- Documentation: package/function help
- Data frames: structure, summaries
- Environments: object inspection
- Files: read, list, search
- Git: status, diff, log
- GitHub: issues, PRs
- R execution: run code in session
- Web: fetch URLs

## Setup (Claude Code)

```bash
claude mcp add r-mcptools -- Rscript -e "mcptools::mcp_server()"
```

Then in R session:
```r
mcptools::mcp_session()
```

## Links

- mcptools: https://posit-dev.github.io/mcptools/
- btw: https://posit-dev.github.io/btw/
