# Packaging Skills

Guide to bundling skills for marketplace distribution.

## Package Structure

A skill package is a directory containing:

```
skill-name/
  SKILL.md              # Required: main skill document
  references/           # Optional: supporting documentation
    *.md                # Reference docs, API guides
  scripts/              # Optional: executable tools
    *.R, *.py, etc.     # Helper scripts
  assets/               # Optional: images, data files
    *.png, *.csv, etc.
```

## .skill File Format

The `.skill` file is a compressed archive (tar.gz or zip) of the skill directory:

```bash
# Create .skill package
cd skills/
tar -czf skill-name.skill skill-name/

# Or using zip
zip -r skill-name.skill skill-name/
```

## Validation Requirements

Before packaging, verify:

**SKILL.md validation:**
- [ ] YAML frontmatter with name and description only
- [ ] Name uses letters, numbers, hyphens only (no special chars)
- [ ] Description starts with "Use when..."
- [ ] Description is third-person, under 500 chars
- [ ] Total frontmatter under 1024 chars

**Content validation:**
- [ ] All file paths referenced in SKILL.md exist in package
- [ ] No absolute paths to user's local system
- [ ] Scripts are executable and portable
- [ ] No sensitive data (credentials, tokens, API keys)

**Testing validation:**
- [ ] Skill passes 90% of test cases
- [ ] Description triggers accurately (tested with eval queries)
- [ ] Plateau reached (no improvement for 2 iterations)

## Distribution

**For Claude Code marketplace:**
1. Create GitHub repository with skill
2. Add `.claude-plugin/marketplace.json` with metadata
3. Submit to Claude Code marketplace

**For Codex/OpenCode:**
1. Package as .skill archive
2. Provide installation instructions in `.codex/INSTALL.md` or `.opencode/INSTALL.md`
3. Distribute via GitHub releases or direct download

**For team/project use:**
1. Add to `./skills/` in project repository
2. Skills load automatically for project contributors
3. No packaging needed (already in repo)

## Marketplace Metadata

For Claude Code marketplace distribution, include `.claude-plugin/marketplace.json`:

```json
{
  "name": "skill-collection-name",
  "version": "1.0.0",
  "description": "Brief description of skill collection",
  "author": "Your Name",
  "skills": [
    {
      "name": "skill-name",
      "path": "skills/skill-name"
    }
  ]
}
```

## Installation Paths

When users install your skill, it goes to agent-specific locations:

- **Claude Code**: `~/.claude/skills/skill-name/`
- **Codex**: `~/.agents/skills/skill-name/`
- **OpenCode**: `~/.config/opencode/skills/skill-name/`

Package should work regardless of installation path (use relative paths within skill).
