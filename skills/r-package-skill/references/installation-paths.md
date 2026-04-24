# Installation Paths for R Package Skills

Always ask the user where to install a new skill. No defaults, no silent auto-detection. If the user's message already specified a path, use it and skip this prompt.

## The Prompt

> Where should I create this skill?
> 1. **Personal** -- your home skills directory (reusable across projects)
> 2. **Project** -- this repository's `skills/` (for contributing / sharing)
> 3. **Custom** -- specify an exact path

After the user chooses, show the resolved path (`Creating skill at: {path}`) and wait for confirmation.

## Path by Agent

| Agent | Personal path |
|---|---|
| Claude Code | `~/.claude/skills/r-{package}/` |
| Codex | `~/.agents/skills/r-{package}/` |
| OpenCode | `~/.config/opencode/skills/r-{package}/` |

**Project path:** `./skills/r-{package}/` relative to the project root.

**Precedence (OpenCode):** Project > Personal > Plugin.

## Detecting the Agent (only needed for Personal)

Try in order; stop at the first match:

1. Environment variables (`CLAUDE_CODE_SESSION` -> Claude Code, etc.).
2. Existence of `~/.claude/skills/`, `~/.agents/skills/`, or `~/.config/opencode/skills/`.
3. Ask: "Are you using Claude Code, Codex, or OpenCode?"

## Plugin Installation (Claude Code)

```
/plugin marketplace add arthurgailes/r-package-skills
/plugin install r-package-skills@r-package-skills
```

Plugin skills are symlinked into Claude's skill directory.

## Manual Installation (Codex / OpenCode)

```bash
# Codex
git clone https://github.com/arthurgailes/r-package-skills.git ~/.codex/r-package-skills
ln -s ~/.codex/r-package-skills/skills ~/.agents/skills/r-package-skills

# OpenCode
git clone https://github.com/arthurgailes/r-package-skills.git ~/.config/opencode/r-package-skills
ln -s ~/.config/opencode/r-package-skills/skills ~/.config/opencode/skills/r-package-skills
```

## Working Directory

Temporary files during doc gathering go in a gitignored temp directory (or the system temp directory). Clean up after extracting the final content to the skill's `references/`.
