# Proposal

## Why

Filename and content searches currently use different normal/hidden mnemonics, making the visibility modes harder to remember. The user approved paired unshifted/shifted final keys under a common leader-f prefix and explicitly authorized implementation through archive and commit.

## What Changes

- **BREAKING:** normal filename search moves from `<leader>'` to `<leader>f'`; normal content search moves from `<leader>fg` to `<leader>f"`.
- **BREAKING:** hidden filename search moves from `<leader>fh` to `<leader>fg`; hidden content remains `<leader>fG`.
- All filename/content search remains `<leader>fa` / `<leader>fA`.
- Remove the retired mappings; retain format, buffer, project-root and picker-local actions.
- Make mapping/dashboard descriptions explicit about search kind and visibility, update the keymap guide, and exercise real cold/warm mapping dispatch plus collision checks.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `workspace-navigation`: Add the explicit paired search-shortcut contract and mapping/discovery acceptance.

## Impact

Changes the navigation plugin's lazy key declarations and labels, `docs/keymaps.md`, and focused mapping tests. No dependency updates or changes to visibility, root handling, formatting, clipboard, tree, or underlying search commands. Existing dashboard one-key launch actions remain but their labels clarify kind/mode.
