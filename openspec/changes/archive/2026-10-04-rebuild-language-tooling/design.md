# Design

## Context

See proposal.md and umbrella section 6. Current TypeScript is 7.0.2, which removed tsserver.js; ts_ls and registry explicitly require TS <7 and bundle 6.0.3. Node 24.15.0/Python 3.13.12 available locally satisfy chosen runtimes.

## Goals / Non-Goals

**Goals:** Test actual managed processes, explicit capabilities ordering, no save-side formatting ownership here.

**Non-Goals:** Mason auto-enable bridges, extra snippets, C#/Rust/Zsh servers or Shuck.

## Decisions

- Eager Mason stable 2.x setup precedes eager native LSP activation and Blink capabilities. Registry auto refresh and UI outdated checks disabled. Exact tools in `config.tools`: BashLS 5.8.1, TSLS 6.0.1 (bundled TS 6.0.3), LuaLS 3.19.1, Pyright 1.1.414, Ruff 0.16.10, ShellCheck 0.11.0. Explicit installer updates registry once then installs selected versions and checks receipts. Server commands are absolute managed paths, never PATH fallback.
- Native `vim.lsp.config/enable` using current stable lspconfig definition data. Root callbacks include guard and standalone directory fallback. Bash settings disable formatting and give ShellCheck's managed path. Lua library only Neovim runtime Lua, no plugin scan. Python `.venv/venv` interpreter search, explicit VIRTUAL_ENV fallback; Ruff hover disabled and Pyright diagnostic overlap reduced. TS initialization selects nearest project tsserver.js; declared TS7/missing TS reports unavailable semantics instead of silently substituting compiler.
- Stable Blink 1.10.2 loaded before capabilities; explicit prebuilt provisioning, Lua matcher fallback supported. Sources lsp/path/buffer only; native snippets. No default Ctrl-y select-and-accept, Enter falls through autopairs newline. Disable cmdline/terminal completion and auto brackets so pairing has one owner.
- Add diagnostic float/picker, keep native `gr*`, `[d/]d` and Ctrl-w d. Zsh dotfile detection/native syntax, no Bash attachment. Health reports tools/parser availability.

## Risks / Trade-offs

- [New TS major lacks legacy server] → Pin compatible editor compiler and require compatible declared project compiler.
- [Managed registry recipes evolve] → Pin versions, validate receipts and actual handshakes; no routine refresh.
- [Completion native binary unavailable] → Explicit provisioning, tested Lua fallback without runtime downloads.

## Migration Plan

Install locked plugins/tools explicitly in isolation, exercise handshake/semantic requests and attached completion, document versions/runtimes, sync/archive then commit. Revert this increment for rollback; managed tools remain isolated in data.
