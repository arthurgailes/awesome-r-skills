# Installing Awesome R Skills for Codex

Opinionated R skills for fast data operations, interactive maps, and package skill creation.

## Prerequisites

- Git installed
- Codex CLI

## Installation

1. **Clone the repository:**

```bash
git clone https://github.com/arthurgailes/awesome-r-skills.git ~/.codex/awesome-r-skills
```

2. **Create symlink for skill discovery:**

**macOS/Linux:**
```bash
mkdir -p ~/.agents/skills
ln -s ~/.codex/awesome-r-skills/skills ~/.agents/skills/awesome-r-skills
```

**Windows (PowerShell as Administrator):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.agents\skills\awesome-r-skills" -Target "$env:USERPROFILE\.codex\awesome-r-skills\skills"
```

3. **Restart Codex**

## Included Skills

| Skill | Purpose |
|-------|---------|
| r-collapse | Fast grouped/weighted stats, panel data, TRA transformations |
| r-mapgl | Interactive WebGL maps with maplibre/mapbox |
| r-flextable | Publication-ready tables |
| creating-r-package | R package development patterns |
| r-package-skill | Extract R package docs into skills |
| writing-skills | TDD methodology for skill creation |

## Updating

```bash
cd ~/.codex/awesome-r-skills
git pull
```

## Uninstalling

```bash
rm ~/.agents/skills/awesome-r-skills
rm -rf ~/.codex/awesome-r-skills  # optional
```
