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

## Reading and structural editing

`af/if` select outer/inner function, `ac/ic` class and `aa/ia` argument in visual
or operator mode where queries provide them. Outer function/class is linewise.
`]m/[m` jump to next/previous function start; `]M/[M` to ends. The equivalent
`c/C` and `a/A` suffixes navigate classes and arguments. Missing queries retain
native filetype motions; no swapping or global `;` repeat remap is added.

Surround: `gz{motion}{pair}` adds, `gZ{pair}` surrounds the current line,
`gzz{motion}{pair}` / `gZZ{pair}` add on new lines, `gzd{pair}` deletes and
`gzc{old}{new}` changes. Visual `gz/gZ` and insert `<C-g>z/Z` also add surrounds.
Counts and dot-repeat work. `s` leaps within the window in normal/visual/operator
mode; normal `S` leaps across windows. These intentionally replace substitutes.
Typed pairs have one owner; Enter remains newline.

Markdown `<leader>um` toggles rendered/raw view locally; insert mode shows raw
syntax. Native `gx` opens links, `]s/[s`, `z=` and `zg` handle spelling. Changing
filetype cleans local spelling and render mapping; the dictionary source remains
in the checkout.

## Language editing

Native `K` hover, `grr` references, `grn` rename, `gra` code action and `gri`
implementation remain available on attached buffers; no short `gr` blocks them.
`[d/]d` navigate diagnostics, `<C-w>d` or `<leader>df` shows a float,
`<leader>dd` opens the diagnostic picker. No inline/virtual-line diagnostics.
Insert Ctrl-n/p selects without insertion, Ctrl-y accepts only a selected item,
Ctrl-space requests a menu, Ctrl-e hides it. Enter inserts newline; Tab/Shift-Tab
visit native snippet placeholders when active, otherwise retain ordinary input.

`<leader>ff` / `:Format` formats explicitly; `:FormatDisable[!]` and
`:FormatEnable` control save formatting. See [format policy](formatting.md).
`:LspEslintFixAll` is deliberate lint cleanup; it is never a save hook.

## Git and terminals

`[h/]h` previous/next Git hunk; `<leader>hp` preview, `hs` stage/unstage,
`hr` reset (discards that hunk), `hb` blame. Visual `hs/hr` act on selected lines;
`ih` selects a hunk. Structural `[c/]c` stay class motions. Staged signs are enabled;
continuous inline blame is disabled.

`<leader>th/tv/tf` toggle horizontal/vertical/float shells (ids 1/2/3),
`<leader>lg` toggles dedicated LazyGit. A different layout hides the previous one.
Shell processes and their cwd survive hiding, until `exit`. `:TermSelect` exposes
ordinary Toggleterm instances. LazyGit is an isolated native terminal buffer so
it can spawn portable argv directly; Toggleterm's command-string shell wrapper
is not used for LazyGit. Opening a different Git project replaces its hidden job.

Terminal Esc or native `<C-\><C-n>` enters terminal normal mode; Ctrl-h/j/k/l
navigates splits, Ctrl-g hides the current owned terminal. In terminal normal
mode leader-lg hides LazyGit; in LazyGit input mode native `q` exits its process.
Normal leader-lg opens it again. Closing/exiting returns editing focus and checks
external changes without saving or overwriting modified buffers.
