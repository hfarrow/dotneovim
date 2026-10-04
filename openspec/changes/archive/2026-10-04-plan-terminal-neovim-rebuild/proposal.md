# Proposal

## Why

The current configuration has an unmaintained Packer loader, machine-specific generated code, conflicting mappings, and integrations using obsolete APIs. Rebuild it around the user's confirmed lightweight terminal-editing workflows, retaining useful muscle memory and presentation while improving reliability, portability, and startup time.

## What Changes

- Establish an approval-gated roadmap, then deliver the rebuild through small OpenSpec changes that are independently planned, implemented, validated, archived, and committed on `rebuild/neovim-modernization`.
- Rebuild configuration from scratch; use reference commit `9746670fb9dc3640969151947b110380aac178f4` and its detached temporary worktree only to understand preferences and compare behavior.
- Replace Packer with lazy.nvim, lock tested plugin revisions, and use current native Neovim APIs. Proposed supported baseline: Neovim 0.12.5 or a newer compatible stable release, rechecked during implementation.
- Retain the dashboard-nvim Hyper presentation, add a polished on-demand nvim-tree experience, and provide filename/content search with three visibility modes and explicit directory/project scopes.
- Retain Gruvbox Material, closely match the existing Ghostty/cmux palette, and follow terminal light/dark appearance using native detection where supported.
- Provide language tooling for Bash, JS/TS, Lua, and Python; C# and Rust remain syntax-only initially. Zsh receives highlighting and word/path completion without a dedicated LSP, Shuck evaluation, Bash diagnostics, or automatic formatting.
- Prefer Mason-managed editor tools; honor project-pinned tools and configuration for formatting and linting. Format supported code on explicit save, leave ESLint fixes manual, and keep Markdown formatting manual.
- Retain Toggleterm, LazyGit, Gitsigns, surround, automatic pairing, Leap, rainbow delimiters, and structural selection/navigation. Add Which-key and in-buffer Markdown rendering.
- **BREAKING:** restore standard delete/change/register semantics; use `<leader>y` / `<leader>p` for the system clipboard and `<leader>P` for the last Vim yank. Move tree toggle to `<leader>e` and dashboard tree action to `e`.
- **BREAKING:** remove focus-loss/autowrite saving; use explicit saves. Omit Barbar, persistent clipboard history, Zen Mode, debugging, Diffview, Glow's archived wrapper, redundant diagnostic/comment plugins, and unrelated language integrations from the first rebuild.
- Test behavior incrementally in isolated Neovim environments; finish with startup and first-use profiling, large-file checks, fresh-install verification, and macOS/Windows/WSL setup documentation.

## Capabilities

### New Capabilities

- `configuration-delivery`: Approval, incremental OpenSpec delivery, bounded runtime scope, dependency reproducibility, validation evidence, and performance verification for configuration changes.

This umbrella change specifies the delivery contract and records the agreed target in its design. Child changes introduce actual runtime capability specs only as their implementation is planned; it does not create retroactive baseline specs for the old configuration.

### Modified Capabilities

None. The main spec directory contains no capability specs.

## Impact

The umbrella change initially adds planning artifacts only. Its approved child changes replace `init.lua`, `lua/user/*`, the generated Packer loader, and applicable filetype configuration; add modular Lua configuration, a plugin lockfile, focused validation fixtures/scripts, and setup documentation; and preserve the personal source spell dictionary. Existing `.ideavimrc` remains available as reference for a future host-integration change, outside the initial terminal scope.

Plugin/tool installation will use Neovim data directories and an explicit provisioning workflow. Node/Python and parser-build prerequisites remain external, documented dependencies. Windows and WSL compatibility will be designed and reviewed, with macOS as the tested platform.

**Review boundary:** the user must approve this roadmap before any runtime implementation or child-change execution. Approval will authorize the incremental loop within this scope; a material scope/design change returns for review.
