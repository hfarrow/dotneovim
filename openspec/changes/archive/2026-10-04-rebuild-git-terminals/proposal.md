# Proposal

## Why

Phase 6 restores the approved frequent Git and terminal workflows after the navigation/language increments. Terminals need explicit process identity, cwd and focus behavior.

## What Changes

- Add Gitsigns hunk signs/navigation/preview/stage/reset.
- Add on-demand persistent shell layouts and isolated LazyGit at leader-lg.
- Refresh externally changed unmodified files and Git/tree state on terminal return.

## Capabilities

### New Capabilities

- `git-terminal-workflows`: Buffer Git hunks and terminal/LazyGit lifecycle.

### Modified Capabilities

None.

## Impact

Adds locked Gitsigns/Toggleterm, terminal module, scratch-Git and attached process/input tests, and setup/key documentation. Requires Git, a working configured shell and LazyGit (available 0.60.0).
