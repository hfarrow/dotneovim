# Setup and restore

## Requirements

Runtime: Neovim **0.12.5+**, Git, ripgrep (`rg`), Node **22.22.2+** with npm,
Python **3.10+**, an installed shell and LazyGit. A Nerd Font is optional for UI
icons. Clipboard uses Neovim's native provider; ordinary editing registers stay
independent. Build-only prerequisites: tree-sitter **CLI >=0.26.1**, a C compiler,
curl and tar. Do not transfer parser binaries between platforms.

## macOS (executable acceptance platform)

```sh
brew install neovim git ripgrep node python lazygit tree-sitter-cli
xcode-select --install # if Command Line Tools/compiler are absent
```

Link the checkout at `~/.config/nvim`, or use `nvim -u /absolute/path/init.lua`.
From the checkout, provision deliberately in this order:

```sh
nvim -l scripts/install.lua
nvim -l scripts/parsers.lua
nvim -l scripts/tools.lua
```

The plugin installer restores `lazy-lock.json`, including the manager and Blink's
prebuilt matcher. The parser installer builds the focused parser table pinned by
the locked Tree-sitter plugin. Mason refreshes its registry only in the explicit
tool installer and installs the exact `lua/config/tools.lua` manifest. Project
dependencies remain separate: see [formatting policy](formatting.md). Inspect
with `:SetupHealth` / `:checkhealth dotneovim`; `:ToolHealth` lists managed paths.
Health is on demand and downloads nothing. It checks plugin Git revisions,
parser loads/queries, tool receipts/executable paths, runtimes and clipboard.

The installer verifies Blink's downloaded matcher, then records the locked commit
in its local matcher receipt so the plugin accepts it with downloads disabled.
Provisioning uses Lua during plugin setup and serializes the one native download
after locked restore, avoiding concurrent writers to the binary/receipt.
If a platform has no prebuilt matcher, use `DOTNEOVIM_BLINK_LUA=1` explicitly
for installation and startup; a failed native download is not reported as success.

Default data/state are `~/.local/share/nvim` and `~/.local/state/nvim`; inspect
actual paths with `:lua print(vim.fn.stdpath('data'))`. Historical `pack` packages
remain on disk but `packpath` is isolated to the runtime. Never delete shared old
packages to fix this setup. The native Mac clipboard uses `pbcopy`/`pbpaste`.

Gruvbox Material follows terminal OSC 11 startup reports and native mode-2031
appearance notifications. Compatible cmux/Ghostty hosts should follow the
terminal's light/dark theme. `:Appearance light` / `dark` is the portable manual
fallback. Tests must distinguish native host reports from direct editor changes;
attached RPC grids do not establish real terminal/font appearance by themselves.

## Native Windows — reviewed, runtime untested

Install supported Neovim, Git, ripgrep, Node/npm, Python and LazyGit on PATH.
Build parsers locally with tree-sitter-cli, a compiler compatible with its build
environment, curl and tar. Mason package availability must be verified on that
machine; a Mac receipt/binary is not Windows validation.

Config defaults to `%LOCALAPPDATA%\nvim`, data to
`%LOCALAPPDATA%\nvim-data`. Run the same three `nvim -l scripts/...` commands
from the checkout (or use absolute paths). Quote checkout paths containing
spaces. Windows native tools use `.exe`; Node transports use `.cmd` wrappers.
No global npm/Python formatter replaces a missing managed/project dependency.

Keep Neovim's detected `shell` unless explicitly choosing another installed
shell. PowerShell users must also configure the appropriate `shellcmdflag`,
`shellquote`, `shellxquote` and redirection options following `:help shell-powershell`;
do not copy POSIX shell flags. Test shell/LazyGit PTYs and focus/exit mappings.
Neovim's Windows clipboard provider must be checked with `:checkhealth` and an
actual yank/paste. Python `.venv` and `venv` use `Scripts\python.exe`; project
formatters use the same native layout. Host fallback checks `python3`, then
`python`. Windows Store aliases are not evidence of a working interpreter.

Remaining runtime acceptance: fresh plugin/tool/parser provisioning and health,
paths with spaces, native `.cmd` process transport, real language handshakes and
formatters, clipboard, shell PTYs, startup UI and terminal appearance.

## WSL — reviewed, runtime untested

Install Linux Neovim/runtimes/Git/ripgrep/LazyGit and parser build prerequisites
inside the distribution. Use Linux `~/.config/nvim` / XDG paths and POSIX `bin`
executables and virtualenvs; do not share Windows plugin/parser/tool data.
Keep projects in the Linux filesystem where possible. Shell defaults/argv remain
POSIX. Windows clipboard bridging depends on installed `win32yank.exe` or usable
`clip.exe` and PowerShell interop recognized by Neovim; inspect provider health
and test both directions instead of assuming desktop access. Terminal theme
reports depend on Windows Terminal/multiplexer support; use manual fallback when
unavailable. Remaining runtime acceptance matches Windows above, using Linux
processes plus an actual Windows clipboard bridge and host terminal.

## Deliberate restore/update and rollback

Re-run the three installers to restore tested versions. Tool receipts are checked
against the manifest; the plugin lock does not lock tools. Deliberate upgrades
require updating/testing the lock or manifest and rebuilding parsers. `:Lazy`
supports inspection/profile; routine startup disables missing-plugin installs,
update checks, registry refreshes and Blink downloads. `DOTNEOVIM_BLINK_LUA=1`
selects the tested Lua matcher fallback.

Rollback by switching to the original reference or reverting an identified
increment, then restore that revision's dependencies deliberately. Keep current
and reference runtime data isolated; do not reset user state or spell sources.

## Isolated validation

Create a new disposable base directory outside the checkout. Export all four
XDG roots under that base before running the three installers:

```sh
export XDG_CONFIG_HOME="$BASE/config" XDG_DATA_HOME="$BASE/data"
export XDG_STATE_HOME="$BASE/state" XDG_CACHE_HOME="$BASE/cache"
nvim -l scripts/install.lua
nvim -l scripts/parsers.lua
nvim -l scripts/tools.lua
DOTNEOVIM_TEST_HOME="$BASE" nvim -l tests/run.lua setup
```

Behavior suites: `core navigation reading language formatting git lifecycle offline`.
Formatting integration needs the exact test-only npm fixture installed by
`DOTNEOVIM_TEST_HOME="$BASE" nvim -l scripts/format-fixtures.lua`. Attached UI tests use
an isolated Python venv with `msgpack==1.2.3`, then
`DOTNEOVIM_TEST_HOME="$BASE" /path/to/venv/bin/python tests/ui.py`.
Mac clipboard fixtures preserve all pasteboard items/types, including rich formats;
keep them short and do not copy other content during the fixture.
Run them using `DOTNEOVIM_TEST_HOME="$BASE" /path/to/venv/bin/python tests/clipboard.py`;
the test compiles a temporary Swift/AppKit helper and keeps snapshot bytes only
in memory, restoring in a finally path and verifying the full restored snapshot.

Actual Mac appearance acceptance: after explicitly authorizing temporary system
light/dark changes and screen capture, run
`DOTNEOVIM_APPEARANCE_TEST=1 DOTNEOVIM_TEST_HOME="$BASE" /path/to/venv/bin/python tests/appearance.py`.
It creates only a test cmux workspace, captures startup/live screenshots and
derived highlights, and restores the original system appearance/automatic keys
and selected workspace in finally. Visually inspect its `appearance-*.png` files;
protocol assertions alone do not prove glyph presentation.
