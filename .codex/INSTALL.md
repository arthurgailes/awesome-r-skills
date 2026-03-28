# Installing R Package Skills for Codex

Opinionated R skills for fast data operations, interactive maps, and package skill creation.

## Prerequisites

- Git installed
- Codex CLI

## Installation

1. **Clone the repository:**

```bash
git clone https://github.com/arthurgailes/r-package-skills.git ~/.codex/r-package-skills
```

2. **Create symlink for skill discovery:**

**macOS/Linux:**

```bash
mkdir -p ~/.agents/skills
ln -s ~/.codex/r-package-skills/skills ~/.agents/skills/r-package-skills
```

**Windows (PowerShell as Administrator):**

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.agents\skills\r-package-skills" -Target "$env:USERPROFILE\.codex\r-package-skills\skills"
```

3. **Restart Codex**

## Included Skills

| Skill            | Purpose                                                                            |
| ---------------- | ---------------------------------------------------------------------------------- |
| r-collapse       | Fast grouped/weighted stats, panel data, TRA transformations                       |
| r-mapgl          | Interactive WebGL maps with maplibre/mapbox                                        |
| r-flextable      | Publication-ready tables                                                           |
| r-ai             | LLM chat (ellmer), RAG (ragnar), agent integration (mcptools), evaluation (vitals) |
| r-package-skill  | Extract R package docs into skills                                                 |

## Updating

```bash
cd ~/.codex/r-package-skills
git pull
```

## Uninstalling

```bash
rm ~/.agents/skills/r-package-skills
rm -rf ~/.codex/r-package-skills  # optional
```
