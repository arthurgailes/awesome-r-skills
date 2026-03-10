# mcptools API Reference

Complete function reference for the mcptools package - Model Context Protocol for R.

## R as a Client

| Function | Purpose |
|----------|---------|
| `mcp_tools()` | Define ellmer tools from MCP servers |

**Example:**
```r
library(mcptools)
library(ellmer)

# Fetch tools from configured MCP servers
tools <- mcp_tools()

# Register with ellmer
chat <- chat_openai()
chat$set_tools(tools)
```

## R as a Server

| Function | Purpose |
|----------|---------|
| `mcp_server()` | Configure R-based tools with LLM-enabled apps |
| `mcp_session()` | Configure R-based tools with LLM-enabled apps |

**Example:**
```r
# In R console (run each session, not in scripts)
mcp_session()

# Now Claude Code/VS Code can call R functions
```

**Key difference:**
- `mcp_server()`: Long-running server process
- `mcp_session()`: Connects current R session to MCP clients

## Configuration

mcptools uses configuration files to define which servers to connect to as a client, and which functions to expose when acting as a server.

**Server config location:**
- **Windows:** `%APPDATA%/Claude/claude_desktop_config.json`
- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux:** `~/.config/Claude/claude_desktop_config.json`

**Example config:**
```json
{
  "mcpServers": {
    "r-session": {
      "command": "Rscript",
      "args": ["-e", "mcptools::mcp_server()"]
    }
  }
}
```

## Documentation

**Package site:** https://posit-dev.github.io/mcptools/
**GitHub:** https://github.com/posit-dev/mcptools
**CRAN:** https://cran.r-project.org/web/packages/mcptools/
