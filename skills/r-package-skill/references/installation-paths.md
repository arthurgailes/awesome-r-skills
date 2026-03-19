# Installation Paths for R Package Skills

When creating an R package skill, you must choose WHERE to install it. This affects discoverability and precedence across different AI agents.

## ALWAYS Ask Where to Install

**Every time you create a skill, ask the user where to put it.** No defaults, no auto-detection.

**Required question:** "Where should I create this skill?"

**Offer 3 options:**
1. **Personal** - Your home skills directory (reusable across projects)
2. **Project** - This repository's skills/ directory (for contributing/sharing)
3. **Custom** - Specify exact path (for testing/experimenting)

**After user chooses, detect agent and show exact path before proceeding.**

## Path Types

### 1. Personal (Home Directory)

Skills available across all your projects for a specific agent.

**Agent-specific paths (Unix notation, OS-dependent):**
- **Claude Code**: `~/.claude/skills/r-{package}/`
- **Codex**: `~/.agents/skills/r-{package}/`
- **OpenCode**: `~/.config/opencode/skills/r-{package}/`

**When to use:**
- You'll use this package across multiple projects
- Personal skill library for your workflow
- Not contributing to a shared repository

**Example:**
```
~/.claude/skills/r-mapboxapi/
  SKILL.md
  references/
    API.md
```

### 2. Project (Current Working Directory)

Skills stored in the current project's skill directory.

**Path:** `./skills/r-{package}/` (relative to project root)

**When to use:**
- Contributing to awesome-r-skills or similar plugin
- Team repository with shared skills
- Project-specific skill customizations

**Precedence (OpenCode):** Project skills override Personal skills override Plugin skills

**Example:**
```
W:\arthur\misc\202602_awesome_r_skills\skills\r-mapboxapi/
  SKILL.md
  references/
    API.md
```

### 3. Custom Path

Any path you specify.

**When to use:**
- Experimenting with skill structure
- Non-standard repository layout
- Testing before committing to personal/project

**Example:**
```
W:\temp\test-skills\r-mapboxapi/
  SKILL.md
  references/
    API.md
```

## Agent-Specific Details

### Claude Code

**Personal skills:** `~/.claude/skills/`

**Installation via plugin marketplace:**
```bash
/plugin marketplace add arthurgailes/awesome-r-skills
/plugin install awesome-r-skills@awesome-r-skills
```

Plugin skills are symlinked to Claude's skill directory.

### Codex

**Personal skills:** `~/.agents/skills/`

**Manual installation:**
```bash
git clone https://github.com/arthurgailes/awesome-r-skills.git ~/.codex/awesome-r-skills
ln -s ~/.codex/awesome-r-skills/skills ~/.agents/skills/awesome-r-skills
```

### OpenCode

**Personal skills:** `~/.config/opencode/skills/`

**Precedence:** Project > Personal > Plugin

**Manual installation:**
```bash
git clone https://github.com/arthurgailes/awesome-r-skills.git ~/.config/opencode/awesome-r-skills
ln -s ~/.config/opencode/awesome-r-skills/skills ~/.config/opencode/skills/awesome-r-skills
```

## Workflow Integration

### Step 0: Determine Installation Path

**ALWAYS ask the user - no defaults:**

**Question:** "Where should I create this skill?"

**Options:**
- **Personal** - Your home skills directory (e.g., `~/.claude/skills/r-{package}`)
- **Project** - This repository (`./skills/r-{package}`)
- **Custom** - You specify the exact path

**After user chooses:**
1. Detect agent (Claude Code, Codex, OpenCode) if needed for Personal option
2. Show exact path: "Creating skill at: {path}"
3. Wait for confirmation before proceeding

### During Workflow

All file writes use the determined base path:

```
{base_path}/
  SKILL.md
  references/
    API.md
    vignette-name.md
```

### Working Directory

You may use temporary working files during doc gathering. Choose an appropriate location:
- If current project has a gitignored temp directory, use it
- Otherwise, use system temp directory
- Clean up temp files after extracting to final skill location

## Agent Detection Logic

Try detection in order:

1. **Check environment variables**
   - CLAUDE_CODE_SESSION → Claude Code
   - Other agent-specific vars

2. **Check common paths exist**
   - `~/.claude/skills/` exists → Claude Code
   - `~/.agents/skills/` exists → Codex
   - `~/.config/opencode/skills/` exists → OpenCode

3. **Check current working directory**
   - Is cwd inside a skills plugin repo? → Project path

4. **If detection fails**, ask: "Are you using Claude Code, Codex, or OpenCode?"
   - Single question, then use appropriate personal path

**Silent confirmation:** "Creating skill at: {detected_path}"

## When to Override Default

### Contributing to a Plugin Repository

If user says "I'm contributing to awesome-r-skills" or similar:

```
Path type: Project
Base path: {repo}/skills/r-{package}
Confirm: "Creating in project skills/ directory for contribution"
```

After creating skill, user will commit and create PR.

### Team Repository

If working in a shared skills repository:

```
Path type: Project
Base path: {team-repo}/skills/r-{package}
```

### Custom/Testing

If user specifies a path or is experimenting:

```
Path type: Custom
Base path: user-specified
```
