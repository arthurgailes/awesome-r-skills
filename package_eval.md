# R Package Distribution Evaluation

Should AwesomeRSkills be distributed as an R package?

## Comparison: How Similar Projects Distribute

| Project | Language | Distribution | What's Distributed |
|---------|----------|--------------|-------------------|
| **Skill Seekers** | Python | pip | Tooling (scrapes docs, generates skills) |
| **claude-skills-mcp** | Python | pip | MCP server (vector search over skills) |
| **claude-scientific-skills** | Python | git repo | Skills only (markdown files) |
| **superpowers** | JS/Markdown | git repo | Skills + hooks + commands |
| **AwesomeRSkills** | R/Markdown | ? | Skills + optional tooling |

**Key insight:** pip packages distribute *tooling*, not raw skill files. The skills themselves live in git repos.

---

## Distribution Options

### Option 1: Git Repository Only (Current)

```bash
git clone https://github.com/user/AwesomeRSkills
cp -r AwesomeRSkills/skills/* ~/.claude/skills/
```

| Pros | Cons |
|------|------|
| Simple, no dependencies | Manual installation |
| Works for non-R users | No versioning beyond git tags |
| Easy to contribute | Users must know git |
| No review process | No discoverability (CRAN, r-universe) |

### Option 2: R Package (GitHub / r-universe)

```r
pak::pak("username/AwesomeRSkills")
AwesomeRSkills::install_skills()
```

**Package structure:**
```
AwesomeRSkills/
  DESCRIPTION
  NAMESPACE
  R/
    install_skills.R
    list_skills.R
    update_skills.R
  inst/
    skills/
      writing-skills/SKILL.md
      r-ggplot2/SKILL.md
      ...
```

| Pros | Cons |
|------|------|
| Familiar R installation | Requires R to install |
| Versioned releases | Extra indirection (inst/ -> ~/.claude/) |
| r-universe auto-builds | Package maintenance overhead |
| Can include R tooling | Non-R users excluded |
| Dependency tracking | |

**r-universe benefits:**
- No CRAN review process
- Automatic builds from GitHub
- Binary packages for all platforms
- Dashboard at `https://username.r-universe.dev`

### Option 3: R Package (CRAN)

```r
install.packages("AwesomeRSkills")
```

| Pros | Cons |
|------|------|
| Maximum discoverability | Strict review process |
| Trusted distribution | Size limits (5MB tarball typical) |
| Binary builds | Must justify non-code content |
| Widest reach | Maintenance burden (check results) |

**CRAN-specific concerns:**

1. **Content policy**: CRAN packages should primarily contain R code. A package that's mostly markdown skill files may face reviewer pushback. Precedent exists (e.g., data packages), but skills are a novel category.

2. **Size limits**: CRAN prefers packages under 5MB. A large skill collection could exceed this. Reference files compound the problem.

3. **Update frequency**: Skill iteration may be faster than CRAN's review cycle supports. Each update requires submission and review.

4. **Check compliance**: Must pass `R CMD check` with no warnings. Not hard, but adds friction to pure-content updates.

---

## Tooling Possibilities

If going the package route, useful R functions could include:

```r
# Installation
install_skills(dest = "~/.claude/skills")
update_skills()
uninstall_skills()

# Discovery
list_skills()
search_skills("time series")
skill_info("r-ggplot2")

# Generation (like Skill Seekers)
skill_from_package("dplyr")
skill_from_vignette("ggplot2", "extending-ggplot2")
skill_from_cran("data.table")

# Validation
validate_skill("path/to/SKILL.md")
lint_skill("path/to/SKILL.md")
```

This tooling would justify the package approach beyond just distributing markdown files.

---

## Recommendation

### For MVP: Git Repository

Start with a git repo. It's simpler, works for everyone, and lets you iterate quickly on skill content without package overhead.

### For Growth: R Package on r-universe

Once you have:
- 10+ stable skills
- Desire for R tooling (generators, validators)
- Users requesting easier installation

Then create an R package distributed via r-universe (not CRAN initially).

### For Maximum Reach: Consider CRAN Later

Only pursue CRAN if:
- Package is mature and stable
- You have significant R tooling (not just skills)
- You want to reach users who only use CRAN
- You're prepared for maintenance burden

---

## Implementation Path

```
Phase 1 (Now)
  └── Git repo with skills/

Phase 2 (10+ skills)
  └── R package on GitHub
      └── inst/skills/
      └── R/install_skills.R
      └── Register on r-universe

Phase 3 (Mature + Tooling)
  └── Consider CRAN submission
      └── skill_from_package()
      └── validate_skill()
      └── Full documentation
```

---

## Decision

**Current recommendation: Stay with git repo (Option 1)**

Rationale:
- Skills are the focus, not R tooling
- No R dependency for non-R users (Claude Code works with any language)
- Faster iteration without package overhead
- Revisit when tooling needs emerge

**Open question for you:** Do you want to build R tooling (skill generators from CRAN docs, validators)? If yes, the package approach becomes more compelling.
