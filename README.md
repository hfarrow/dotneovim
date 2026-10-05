# dotneovim

## Branches

`main` is the bleeding-edge development branch. New development targets `main`;
`v2` is retained as historical configuration, not the ongoing development line.

## Setup

Requires **Neovim 0.12.5+** and Git. This configuration targets standalone terminal
Neovim; the rebuild was delivered through incremental OpenSpec changes.

See [consolidated setup and restore](docs/setup.md) for the complete provisioning
order, `:SetupHealth`, platform paths/shells/clipboard, isolation and rollback.
Windows/WSL are portability-reviewed and runtime-untested.
See [performance and validation](docs/performance.md) for measured startup,
first-use latency, large-input guards and repeatable profiling recipes.

Clone this repository and link it at Neovim's config path (`~/.config/nvim` on
macOS/Linux, `%LOCALAPPDATA%\nvim` on Windows), or start with
`nvim -u /path/to/dotneovim/init.lua`. Paths are resolved from the checkout.

Install the locked plugin set explicitly, from the repository root:

```sh
nvim -l scripts/install.lua
```

Normal startup does not install/update plugins. `:Lazy` manages plugins; updates
are deliberate, with tested revisions tracked in `lazy-lock.json`. The installer
restores that lockfile, including the manager. Historical Packer installations
are left on disk and no longer auto-loaded.

Gruvbox Material matches the current terminal palette. Compatible terminals can
select light/dark appearance natively; `:Appearance light` / `dark` overrides it.
See [the keymap guide](docs/keymaps.md) for clipboard and core editing behavior.

For isolated macOS checks, set `XDG_CONFIG_HOME`, `XDG_DATA_HOME`,
`XDG_STATE_HOME`, and `XDG_CACHE_HOME` to subdirectories of a temporary environment
and run the installer. Then run `DOTNEOVIM_TEST_HOME=/path/to/environment nvim -l
tests/run.lua core` (the harness applies those paths and bounds test runtime).
Do not share test state with your normal Neovim data. Additional language/parser
dependencies are documented as their increments land.

Navigation requires **ripgrep** (`brew install ripgrep` on macOS). Tree, picker,
dashboard and statusline icons use an optional Nerd Font in your terminal.
Attached UI checks use `tests/ui.py`: create an isolated Python venv, install
`msgpack==1.2.3`, then run it with `DOTNEOVIM_TEST_HOME` set as above. This
exercises an attached Neovim grid and input; terminal appearance checks are separate.

Provision focused syntax parsers explicitly after installing plugins:

```sh
brew install tree-sitter-cli # >=0.26.1; the tree-sitter library alone has no CLI
nvim -l scripts/parsers.lua
```

Parser builds also require a C compiler (macOS Command Line Tools), curl and tar.
Re-run parser provisioning when deliberately updating the locked Tree-sitter
plugin: its parser table pins compatible revisions. Normal startup downloads
nothing. Files over 1 MiB, 50,000 lines or with a line over 10,000 bytes skip parsing, rainbow,
Markdown decoration and semantic tooling. Markdown/text spelling uses the
preserved `spell/en.utf-8.add`; native `zg` updates that dictionary deliberately.

## Language tools

Requires Node **>=22.22.2**, npm and Python **>=3.10** for the selected tools.
Run `nvim -l scripts/tools.lua` explicitly after plugin installation. It refreshes
the Mason registry once, then installs exact versions from `lua/config/tools.lua`.
Normal startup and opening `:Mason` do not refresh/download/check versions.
`:ToolHealth` shows required managed paths; host copies are not substituted.

BashLS 5.8.1 + ShellCheck v0.11.0, TSLS 6.0.1 + TypeScript 6.0.3, LuaLS 3.19.1,
Pyright 1.1.414 and Ruff 0.16.10 are the initial manifest. TSLS currently needs
TypeScript **<7**; a declared missing/incompatible project compiler is reported,
not replaced by an editor compiler. Nearest compatible local TypeScript wins.
Python `.venv`/`venv` is discovered independently of the Node-based Pyright
transport, with explicit `VIRTUAL_ENV` fallback. Lua libraries are limited to
Neovim runtime Lua, not every installed plugin. C#/Rust are syntax-only; Zsh
uses native syntax and buffer/path completion without Bash diagnostics.

Blink stable 1.10.2 uses native Neovim snippets with no collections. The plugin
installer explicitly downloads its checked prebuilt matcher; routine startup
has downloads disabled. `DOTNEOVIM_BLINK_LUA=1` selects the portable Lua fallback.
Completion never preselects/inserts: select with Ctrl-n/p, accept a selected item
with Ctrl-y; Enter remains newline. Diagnostic signs are quiet, with explicit
float/picker and native navigation.

See [project formatting](docs/formatting.md) for save policy, explicit overrides,
missing-tool behavior and manual lint fixes. Re-run explicit tool provisioning
to install the formatter/ESLint transport manifest additions.

## Git and terminals

Requires Git, a working Neovim `shell` and LazyGit (`brew install lazygit` on
macOS). Gitsigns attaches to tracked files; Toggleterm supplies persistent shell
layouts. `<leader>lg` opens a dedicated LazyGit float at the Git/worktree root;
ordinary shells start at the editing directory and keep their process cwd.
See [keys](docs/keymaps.md) for hunk actions, layout and terminal-mode exits.
Return refreshes Git/tree state and reloads only unmodified external changes.

## Agent setup

Repository-wide agent instructions live in the root [`AGENTS.md`](AGENTS.md); `CLAUDE.md` imports that file. Reusable skills live in [`.agents/skills/`](.agents/skills/), with `.claude/skills/` linking to that directory.

OpenSpec is the primary workflow for defining, planning, and implementing substantive changes. See `AGENTS.md` for the workflow and planning-to-implementation handoff. Specs are introduced with new work; existing configuration does not need retroactive specs or changes.

The OpenSpec CLI is pinned locally in `.agents/tools/` and requires Node.js 20.19.0 or newer and npm. Install the locked dependencies and invoke the CLI from the repository root:

```sh
npm ci --prefix .agents/tools
.agents/tools/node_modules/.bin/openspec list --json
```

The manifest and lockfile are tracked; installed `node_modules/` are ignored. To upgrade the CLI and refresh the repository-local skills, run:

```sh
npm install --prefix .agents/tools --save-dev --save-exact @fission-ai/openspec@latest
.agents/tools/node_modules/.bin/openspec update
```

OpenSpec is configured for the shared `.agents` skills target, so `update` writes skills into `.agents/skills/`.
