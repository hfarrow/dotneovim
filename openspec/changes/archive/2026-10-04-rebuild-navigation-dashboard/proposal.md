# Proposal

## Why

The foundation intentionally has no browsing UI. Phase 2 delivers the approved dashboard and navigation workflows with one owner per action and explicit search boundaries.

## What Changes

- Route empty and sole-directory launches to Hyper; preserve file, stdin and multi-file launches.
- Add on-demand nvim-tree, three visibility modes and directory/project Telescope scopes.
- Add Which-key and a restrained theme-derived lualine; document all navigation keys.

## Capabilities

### New Capabilities

- `workspace-navigation`: Startup routing, search visibility/scope, tree operations and navigation discovery.

### Modified Capabilities

None.

## Impact

Adds startup/project/search modules, capability-oriented plugin specs, locked dependencies, real-plugin fixtures and attached UI checks. Requires ripgrep; no native sorter build dependency.
