# btw API Reference

Complete function reference for the btw package - a toolkit for connecting R and LLMs.

## Core Functions

| Function | Purpose |
|----------|---------|
| `btw()` | Generate plain-text descriptions of R objects |
| `btw_this()` | Create descriptions suitable for LLM consumption |
| `btw_client()` | Establish a btw-enhanced ellmer chat client |
| `btw_app()` | Set up a btw-enhanced ellmer chat application |
| `btw_tools()` | Register tools from btw for use with ellmer |
| `btw_mcp_server()` | Launch a Model Context Protocol server featuring btw tools |
| `btw_mcp_session()` | Initialize a Model Context Protocol session with btw tools |

**Example:**
```r
library(btw)

# Describe objects for LLM
btw(mtcars)  # Copies description to clipboard

# With ellmer
library(ellmer)
chat <- chat_openai()
chat$set_tools(btw_tools())
```

## Project Context Management

| Function | Purpose |
|----------|---------|
| `use_btw_md()` | Establish a btw.md context file for projects |
| `edit_btw_md()` | Modify an existing btw.md context file |
| `btw_task_create_btw_md()` | Execute workflow to initialize project context file |

**Example:**
```r
# Create project context file
use_btw_md()

# Edit it
edit_btw_md()
```

## R Object Description Functions

| Function | Purpose |
|----------|---------|
| `btw_this(<character>)` | Describe character objects |
| `btw_this(<data.frame>)` | Convert data frames to plain-text descriptions |
| `btw_this(<tbl>)` | Describe tibble objects |
| `btw_this(<environment>)` | Document environment contents |

**Example:**
```r
# Describe data frame
btw_this(iris)

# Describe environment
btw_this(globalenv())
```

## Tasks & Agents

| Function | Purpose |
|----------|---------|
| `btw_task_create_readme()` | Execute workflow to generate polished README |
| `btw_task()` | Run a pre-formatted btw task |
| `btw_task_create_skill()` | Task: Create a Skill |

## Skills Management

| Function | Purpose |
|----------|---------|
| `install_btw_cli()` | Install the btw CLI |
| `btw_agent_tool()` | Create a custom agent tool from a markdown file |
| `btw_tool_skill()` | Tool: Load a skill |
| `btw_skill_install_github()` | Install a skill from GitHub |
| `btw_skill_install_package()` | Install a skill from an R package |

**Example:**
```r
# Create a custom agent tool from a markdown spec
tool <- btw_agent_tool("path/to/tool-spec.md")

# Install a skill from GitHub
btw_skill_install_github("user/repo")
```

## Tools (for LLM Integration)

### Documentation Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_docs_package_news()` | Read package release notes |
| `btw_tool_docs_package_help_topics()` | List help topics for a package |
| `btw_tool_docs_help_page()` | Display help pages |
| `btw_tool_docs_available_vignettes()` | List package vignettes |
| `btw_tool_docs_vignette()` | Display vignette contents |

### Environment Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_env_describe_data_frame()` | Describe data frame structure |
| `btw_tool_env_describe_environment()` | Document environment contents |

### File Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_files_code_search()` | Search project code |
| `btw_tool_files_list_files()` | List project files |
| `btw_tool_files_read_text_file()` | Read file contents |
| `btw_tool_files_write_text_file()` | Write text files |

### Git Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_git_status()` | Check git status |
| `btw_tool_git_diff()` | Display git differences |
| `btw_tool_git_log()` | View git history |
| `btw_tool_git_commit()` | Create git commits |
| `btw_tool_git_branch_list()` | List available branches |
| `btw_tool_git_branch_create()` | Create git branches |
| `btw_tool_git_branch_checkout()` | Switch git branches |

### Package Development Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_pkg_document()` | Generate package documentation |
| `btw_tool_pkg_test()` | Execute package tests |
| `btw_tool_pkg_check()` | Run R CMD check |
| `btw_tool_pkg_coverage()` | Calculate test coverage |

### CRAN Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_search_packages()` | Search CRAN packages |
| `btw_tool_search_package_info()` | Describe CRAN packages |

### Session Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_session_platform_info()` | Describe system platform |
| `btw_tool_session_package_info()` | Gather package information |
| `btw_tool_session_check_package_installed()` | Verify package installation |

### Web Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_web_read_url()` | Convert web pages to markdown |

### Other Tools

| Function | Purpose |
|----------|---------|
| `btw_tool_github()` | GitHub operations |
| `btw_tool_ide_read_current_editor()` | Access current editor file |
| `btw_tool_run_r()` | Execute R code (experimental) |

**Example:**
```r
# Register all btw tools with ellmer
chat <- chat_openai()
chat$set_tools(btw_tools())

# Now chat can use tools
chat$chat("What packages are available for data.table operations?")
# LLM calls btw_tool_search_packages()

chat$chat("Show me the dplyr vignette on two-table verbs")
# LLM calls btw_tool_docs_vignette()
```

## Documentation

**Package site:** https://posit-dev.github.io/btw/
**GitHub:** https://github.com/posit-dev/btw
**CRAN:** https://cran.r-project.org/web/packages/btw/
