# Keymap guide

Space is the leader. Core bindings load before plugins.

| Key | Action |
| --- | --- |
| `jj`, `jk`, `kj` in insert | Escape |
| `H` / `L` | First nonblank / end of line (visual `L`: last nonblank) |
| `n` / `N` | Search matches, centered |
| Ctrl-h/j/k/l | Move between splits |
| Visual `<` / `>` | Indent and keep selection |
| Space-y + motion, or visual Space-y | Copy to system clipboard |
| Space-p | Paste system clipboard |
| Space-P | Paste last Vim yank (`"0p`) |
| Space-Enter | Clear search highlighting |
| Space-u-w | Toggle soft wrapping in this window |
| Space-u-n / u-r / u-c | Toggle numbers / relative numbers / cursor line |

Ordinary `y/p/d/c/x` follow native Vim semantics. Deletion does not replace the
system clipboard; the last yank remains in register `0`. Clipboard mappings use
register `+`, with Neovim's platform clipboard provider. Visual leader-p/P retains
the paste source.

Save explicitly with `:write`; focus and buffer changes do not save. Prose wraps
visually without rewriting lines. `:Appearance light` or `:Appearance dark` is a
manual override for terminals without automatic background detection.
# Navigation

Plain `nvim` / `nvim .` show Hyper; file, stdin, commit and multi-file launches edit
normally. Dashboard `f/F/a` search normal/hidden/all files, `/` greps, `;` opens
recent files, `c` edits this checkout and `e` toggles the tree.

| Key | Action |
| --- | --- |
| `<leader>e` / `<leader>E` | Toggle tree / reveal file |
| `<leader>'`, `fh`, `fa` | Normal / hidden / all filename search |
| `<leader>fg`, `fG`, `fA` | Normal / hidden / all content search |
| `<leader>fp` | Project-root normal files |
| `<leader>;`, `fb`, `/` | Recent files / buffers / current-buffer search |
| Picker `<C-v>` / `<C-r>` | Cycle visibility / directory-project scope |
| Picker `<C-j/k>` | Select next / previous |
| Picker Enter or normal `;` | Open selection |
| Picker `<C-q>` | Send results to quickfix |

Every visibility/scope combination is also available through
`:Search files|grep normal|hidden|all directory|project`. Prompts label both.
Directory scope follows the editing file's directory or cwd on the dashboard;
project widening never changes cwd. No-project fallback is labeled. All mode
includes ignored files but excludes `.git` contents; symlinks are not followed.

Tree `?` / `g?` shows its real mapping list. `a` creates, `r` renames, `<C-r>`
renames a full path (move), `c/x/p` copy/cut/paste, `d` deletes with confirmation,
`R` refreshes and `q` closes. Closing restores the previous editing window.
Tree local clipboard keys are intentional UI operations. Which-key displays
described shortcuts after 350 ms; the mapping timeout remains 500 ms.
