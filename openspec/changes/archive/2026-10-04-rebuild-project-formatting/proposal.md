# Proposal

## Why

Phase 5 makes explicit saves format supported code without running cleanup fixes or substituting missing project dependencies. Project policy must be resolved per package, including monorepos.

## What Changes

- Add Conform format-only save/manual pipeline, opt-outs and bounded failure handling.
- Resolve project configs/pinned tools and explicit overrides before managed defaults.
- Add configured project ESLint/Biome diagnostics with explicit manual fixes only.

## Capabilities

### New Capabilities

- `project-formatting`: Project-aware format-only saves, manual formatting/fixes and missing-tool policy.

### Modified Capabilities

None.

## Impact

Extends project/tool modules, adds Conform policy and configured lint clients, exact managed formatter versions, real project fixtures and documentation. No new autosave events.
