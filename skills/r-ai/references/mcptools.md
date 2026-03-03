# mcptools Reference

## R as MCP Server

Allow external agents to access your R session:

```r
library(mcptools)
mcp_session()  # Run in console you want agents to access
```

**Important:** Call each time R starts. Must be in interactive console, not scripts.

## Agent Configuration

### Claude Code

```bash
claude mcp add r-mcptools -- Rscript -e "mcptools::mcp_server()"
```

### Claude Desktop

Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "r-mcptools": {
      "command": "Rscript",
      "args": ["-e", "mcptools::mcp_server()"]
    }
  }
}
```

### VS Code (Continue)

Add to Continue config:

```json
{
  "mcpServers": {
    "r-mcptools": {
      "command": "Rscript",
      "args": ["-e", "mcptools::mcp_server()"]
    }
  }
}
```

## What Agents Can Do

Once connected, agents can:
- Execute R code in your session
- Access objects in your environment
- Call functions from loaded packages
- Read/write files via R
- Use any packages you have installed

## R as MCP Client

Use external MCP servers as ellmer tools:

```r
library(mcptools)
library(ellmer)

# Get tools from external MCP server
tools <- mcp_tools()

# Register with chat
chat <- chat_openai()
chat$set_tools(tools)
```

## Combining with btw

For agents to have btw tools available:

```r
# Option 1: Use btw's MCP server directly
btw::btw_mcp_server()

# Option 2: Register btw tools in your session, then mcp_session()
library(btw)
library(mcptools)
mcp_session()  # Agent can now use btw via R execution
```

## Session Discovery

```r
# List available R sessions (for debugging)
mcp_list_sessions()
```

## Security Notes

- Agents can execute arbitrary R code in your session
- They have access to your environment variables
- They can read/write files your R process can access
- Use in trusted environments only
