# Installation Paths for R Package Skills

When creating an R package skill, you must choose WHERE to install it. This affects discoverability and precedence across different AI agents.

## Default: Personal Skills

**Most common:** Create in your personal skills directory for reuse across projects.

**Only ask about path if:**
- User explicitly says they're contributing to a repo
- Current working directory is clearly a skills plugin/repository
- User requests a specific location

**Default behavior:**
- Detect agent from environment or common paths
- Use agent-specific personal directory
- No questions needed

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

**Default behavior (most common):**
1. Detect agent from environment or common paths
2. Use agent-specific personal directory
3. Proceed without asking user

**Only ask if:**
- User mentioned contributing to a repository
- Current directory is a skills plugin repo
- Agent detection fails
- User requests specific location

**Max 1 question:** "Are you contributing this to a repository, or is this for personal use?"
- Personal → auto-detect agent, use personal path
- Contributing → confirm project path
- Other → ask for custom path

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
