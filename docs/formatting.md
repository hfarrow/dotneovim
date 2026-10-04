# Project formatting

Conform owns one format-only operation before explicit writes, bounded to 1500 ms.
JS/TS/JSX/TSX, Lua, Python and Bash format on save. Markdown formats only through
`:Format` / `<leader>ff`; text/logs/Zsh/C#/Rust remain untouched. No autosave,
ESLint fixes, Biome check/write, Ruff fix-all or import organization on save.

`:FormatDisable` disables automatic formatting globally, `:FormatDisable!` for
this buffer; `:FormatEnable` clears both. Manual `:Format` is independent. Missing
tools/config errors/timeouts warn and let the original edits save; no alternative
formatter or generic LSP fallback is used.

## Selection and versions

Nearest relevant package/config wins, searching bounded ancestors to Git/home.
Workspace `node_modules/.bin` is supported. JS policy detects Biome/Prettier
config/package/dependency declarations; both require an explicit owner. ESLint
alone is diagnostics/manual fixes and does not format. Exact dependency versions
must match installed package metadata; ranges require a project lockfile; npm
lock package versions are checked against installed versions. Restore the project
dependencies when warned, rather than installing global formatters.

Python Ruff/Black configs require project `.venv`/`venv` executables; conflicting
configs require an override. Lua StyLua config requires local `bin/stylua`; shell
`.shfmt` requires local `bin/shfmt`. Absent project policy only, managed defaults
are StyLua v2.5.2, shfmt v3.14.1, Ruff 0.16.10 and Prettier 3.9.9. Provision via
`nvim -l scripts/tools.lua`; no routine downloads. Tools read their own project
config and EditorConfig normally.

## Explicit override

Place `.nvim-format.json` in the package/workspace:

```json
{
  "javascript": { "formatter": "prettier", "version": "3.9.9" },
  "typescript": { "formatter": "biome", "version": "2.5.15" },
  "python": { "formatter": "black", "version": "26.1.0" },
  "lua": { "formatter": "stylua", "command": ["bin/stylua"], "version": "2.5.2" },
  "bash": { "formatter": false }
}
```

Keys are Neovim filetypes (shell commonly `sh`, JSX `javascriptreact`, TSX
`typescriptreact`). Supported owners: prettier/biome/stylua/shfmt/ruff/black.
Optional `command` is an argv array with executable absolute or relative to this
policy file, never shell syntax. Version overrides are checked with `--version`.
Formatter-specific stdin/filename arguments are appended by the pipeline.
`formatter: false` disables that filetype's formatting. Invalid policy warns.

## Lint actions

Configured project ESLint uses managed transport 4.10.0 with the project's ESLint
library; Biome uses the required local project binary. Both can provide diagnostics
when intentionally configured. No configured library means no client substitution.
Use native `gra` for an explicit code action or `:LspEslintFixAll` for deliberate
ESLint cleanup. Save only formats; it does not run those actions.

Validation dependencies: `DOTNEOVIM_TEST_HOME=... nvim -l
scripts/format-fixtures.lua` installs exact Prettier 3.9.9, Biome 2.5.15 and ESLint
9.39.4 in isolated fixture state, then `tests/run.lua formatting` exercises real
processes, saves, diagnostics and manual fixes.
