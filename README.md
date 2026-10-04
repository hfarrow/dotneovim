# dotneovim
## Setup

Requires **Neovim 0.12.5+** and Git. This configuration is being rebuilt in
incremental OpenSpec changes for standalone terminal Neovim.

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
