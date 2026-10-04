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
