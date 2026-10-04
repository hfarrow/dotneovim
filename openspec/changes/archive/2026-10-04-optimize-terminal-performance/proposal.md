# Proposal

## Why

Phase 7 completed real setup/host acceptance, so the approved final phase can now establish useful-redraw and first-operation latency rather than assuming lazy loading makes work disappear. Reproducible evidence and hard Mac budgets are required before umbrella finalization.

## What Changes

- Measure at least ten warmed samples for empty, directory, explicit dashboard, text, code and Markdown; separately report first empty-cache launches, minimal and runnable original reference.
- Establish warmed median useful-redraw budgets of 100 ms for text/code/Markdown and 150 ms for dashboard variants on the tested Mac. Retain these approved targets; a failure after reasonable tuning requires input.
- Measure first real tree/picker/completion/terminal readiness, audit eager ownership and routine network work, and optimize only evidenced costs while preserving first operations.
- Exercise sizable multi-line log, many short lines and minified line reading/search/reload with expensive features excluded; publish data, environment, revisions, median/p95 and profiling recipes.
- Run final cross-capability/actual-host acceptance after changes, then archive/commit this child and finalize the umbrella only on genuine completion.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `terminal-core`: file-launch useful-redraw performance budgets and measurement evidence.
- `workspace-navigation`: dashboard useful-redraw budget and actual first-operation evidence.
- `reading-editing`: bounded expensive-feature exclusions and executable large-input responsiveness.

## Impact

Targets measurement/test scripts, docs/performance.md and measured runtime loading/guard fixes if needed. No additional runtime dependency or plugin; test-only Msgpack already provisioned. Reference `9746670` worktree and original legacy data remain available read-only. Parent phase 8 follows completed `verify-portable-setup` (759f95d).
