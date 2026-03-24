# Usage Prompt Tests

Tests that verify package skills are triggered and apply intelligence from reference docs.

## Tests

### mapgl-library-call.txt
**Trigger test**: Verifies `library(mapgl)` triggers r-mapgl skill

### collapse-function-call.txt
**Trigger test**: Verifies `collapse::fmean()` triggers r-collapse skill

### freestiler-zoom-intelligence.txt
**Intelligence test**: Verifies r-freestiler skill:
1. Is triggered by county tileset request
2. Reads `references/zoom-strategy.md`
3. Applies appropriate `max_zoom = 10` for county data
4. Does NOT use default zoom (0-14) that creates 10x larger tilesets

**Why this test exists**: Prevents regression of the "intelligence gap" problem where skills provide correct API docs but fail to surface parameter guidance from reference files. Before the `<MANDATORY-CONTEXT>` fix, agents would skip reading references and generate bloated tilesets.

**Pass criteria**:
- ✅ r-freestiler skill triggered
- ✅ Code includes `max_zoom` parameter
- ✅ `max_zoom` value is 8-11 (appropriate for counties)
- ❌ FAIL if max_zoom = 12-14 (too detailed, bloated tileset)
- ❌ FAIL if max_zoom missing (uses default 0-14)
