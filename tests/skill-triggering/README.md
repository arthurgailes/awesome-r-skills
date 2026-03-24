# Skill Triggering Tests

Tests to ensure skills are triggered by natural language prompts, not just explicit `/skill-name` invocations.

## The 3 Core Tests

1. **Creation trigger**: "Create a skill for ipumsr" → should trigger r-package-skill
2. **library() trigger**: Code with `library(mapgl)` → should trigger r-mapgl
3. **package::function() trigger**: "How do I use collapse::fmean?" → should trigger r-collapse

These cover the essential skill triggering patterns.

## Running Tests

### Single test:
```bash
./run-test.sh r-mapgl prompts/usage/mapgl-library-call.txt
```

### All tests:
```bash
./run-all-tests.sh
```

## Test Structure

Each test:
1. Submits a natural prompt (no explicit skill mention)
2. Checks if the expected skill was invoked via Skill tool
3. Reports pass/fail with details

Tests run in isolated tmp directories with full logs for debugging.

## Expected Behavior

**Skills MUST trigger when:**
- User mentions the package name ("mapgl", "collapse", "flextable")
- Code contains `library(package)` or `require(package)`
- Code contains `package::function()` calls
- User asks about package-specific functionality

**Skills should NOT require:**
- Explicit `/skill-name` invocation
- Mentioning the word "skill"
- Knowledge of the skill system

## Adding New Tests

1. Create a prompt file in `prompts/creation/` or `prompts/usage/`
2. Add test to `run-all-tests.sh`
3. Verify the skill description would catch this pattern

## Debugging Failed Tests

If a test fails:
1. Check the log file (shown in test output)
2. Look for what skills WERE triggered
3. Review the skill's `description:` field in SKILL.md
4. Consider if description needs package name, `library()` pattern, or function names
