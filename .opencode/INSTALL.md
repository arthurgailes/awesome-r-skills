# Installing R Package Skills for OpenCode

Opinionated R skills for fast data operations, interactive maps, and package skill creation.

## Prerequisites

- Git installed
- OpenCode

## Installation

1. **Clone the repository:**

```bash
git clone https://github.com/arthurgailes/r-package-skills.git ~/.config/opencode/r-package-skills
```

2. **Create symlinks:**

**macOS/Linux:**

```bash
mkdir -p ~/.config/opencode/skills
ln -s ~/.config/opencode/r-package-skills/skills ~/.config/opencode/skills/r-package-skills
```

**Windows (PowerShell as Administrator):**

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\skills"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\opencode\skills\r-package-skills" -Target "$env:USERPROFILE\.config\opencode\r-package-skills\skills"
```

3. **Restart OpenCode**

## Verify Installation

Ask OpenCode: "What R skills do you have?"

## Included Skills

| Skill            | Purpose                                                                            |
| ---------------- | ---------------------------------------------------------------------------------- |
| r-collapse       | Fast grouped/weighted stats, panel data, TRA transformations                       |
| r-mapgl          | Interactive WebGL maps with maplibre/mapbox                                        |
| r-flextable      | Publication-ready tables                                                           |
| r-ai             | LLM chat (ellmer), RAG (ragnar), agent integration (mcptools), evaluation (vitals) |
| r-package-skill  | Extract R package docs into skills                                                 |
| writing-r-skills | TDD methodology for skill creation                                                 |

## Skill Precedence

OpenCode uses: Project skills > Personal skills > Plugin skills

## Updating

```bash
cd ~/.config/opencode/r-package-skills
git pull
```

## Uninstalling

```bash
rm ~/.config/opencode/skills/r-package-skills
rm -rf ~/.config/opencode/r-package-skills  # optional
```
