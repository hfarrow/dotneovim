# Proposal

## Why

The approved rebuild needs a reliable core before navigation and language integrations are reintroduced. Replacing the generated Packer startup and implicit clipboard/save behavior first makes subsequent increments testable and their load order understandable.

## What Changes

- Replace legacy runtime modules/filetype helpers with a minimal Lua entry point, core modules, lazy.nvim, and Gruvbox Material.
- Preserve agreed editing shortcuts, two-space defaults, smart-case search, split direction, cursor restoration, and persistent undo.
- **BREAKING:** keep native editing registers separate from the system clipboard; introduce leader clipboard/last-yank operations and remove black-hole/cut aliases.
- **BREAKING:** remove autosave and implicit physical text wrapping; reload external changes only for unmodified buffers and soft-wrap prose.
- Isolate installed plugin discovery from legacy Packer start packages without deleting user installations; use explicit dependency provisioning and a tracked lockfile.
- Add core behavioral checks, minimal/reference startup evidence, and setup/keymap documentation.

## Capabilities

### New Capabilities

- `terminal-core`: Stable editing preferences, register isolation, save/reload behavior, and prose display.
- `plugin-lifecycle`: Explicit portable dependency provisioning, locked plugin restore, and provisioned startup.

### Modified Capabilities

None; no main specs exist yet.

## Impact

Replaces `init.lua`, `lua/user/*`, `lua/packer_compiled.lua`, and legacy `ftplugin` files; adds `lua/config`, a theme plugin spec, setup script, tests, lockfile, and documentation. Personal spelling data and `.ideavimrc` remain available. This is phase 1 of the approved `plan-terminal-neovim-rebuild`; later phases own dashboard/navigation and language functionality.
