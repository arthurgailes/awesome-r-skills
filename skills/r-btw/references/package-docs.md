# btw Reference

## Quick Context

```r
btw("dplyr")           # Package documentation
btw(my_data)           # Data frame structure
btw(my_function)       # Function source/docs
```

## Available Tools

When registered with `btw_tools()`, these tools become available to the LLM:

| Tool | Description |
|------|-------------|
| `btw_tool_docs` | Package help pages, vignettes, news |
| `btw_tool_data` | Data frame structure, head, summary |
| `btw_tool_environment` | List objects, search path |
| `btw_tool_files` | Read files, list directories |
| `btw_tool_search` | Search files with regex |
| `btw_tool_git` | Status, diff, log, blame |
| `btw_tool_github` | Issues, PRs, discussions |
| `btw_tool_execute` | Run R code in session |
| `btw_tool_web` | Fetch URLs as markdown |

## Integration with ellmer

```r
library(btw)
library(ellmer)

chat <- chat_openai()
chat$set_tools(btw_tools())

# LLM can now use any btw tool
chat$chat("Show me the structure of mtcars")
chat$chat("What does the mutate function do?")
chat$chat("What files are in the R/ directory?")
```

## Interactive Apps

```r
# Shiny-based chat interface
btw_app()

# Pre-configured chat client (includes btw_tools)
client <- btw_client()
client$chat("Help me analyze this data")
```

## MCP Server

Expose btw tools to external agents (Claude Desktop, VS Code):

```r
btw_mcp_server()  # Start MCP server with btw tools
```

## Project Configuration

Create `btw.md` in project root for persistent context:

```markdown
# btw.md
This project uses tidyverse conventions.
Data lives in data/ directory.
Tests use testthat.
```

The LLM reads this file for project-specific context.

## Selective Tool Registration

```r
# Register only specific tools
chat$set_tools(list(
  btw_tool_docs(),
  btw_tool_data()
))
```
