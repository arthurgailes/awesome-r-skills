# R as an MCP Server with mcptools

## Overview

The mcptools package enables AI coding assistants like Claude Desktop, Claude Code, and VS Code GitHub Copilot to execute R code through the Model Context Protocol (MCP).

## Core Concepts

The architecture involves three main components:

1. **Clients**: Applications that connect to R sessions, including Claude Desktop, Claude Code, Copilot Chat in VS Code, and Positron Assistant.

2. **Servers**: MCP servers initiated with `mcp_server()` that expose R functions as tools. Recommended command: `Rscript -e "mcptools::mcp_server()"`.

3. **Sessions**: Active R environments that clients communicate with. Users can opt-in sessions by running `mcptools::mcp_session()` in their `.Rprofile`.

## Key Setup Instructions

To configure mcptools:
- Register the command with your client according to its specifications
- Optionally add `mcptools::mcp_session()` to `.Rprofile` for interactive session access
- No configuration is required; unconfigured tools execute in the server itself

## Multiple Clients and Sessions

- Multiple clients work seamlessly without additional configuration
- When multiple R sessions exist, mcptools selects a default session automatically
- Users can employ `list_r_sessions()` and `select_r_session()` tools to switch between projects
- Note: Clients connect to one R session at a time, which may cause issues with simultaneous multi-chat workflows

## Custom Tools

Beyond built-in tools, developers can supply custom tools by passing "a list of outputs from ellmer::tool()" to the `tools` argument of `mcp_server()`. This enables specialized functionality for package development, data science workflows, or custom automation.
