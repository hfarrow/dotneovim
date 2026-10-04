# Design

## Context

See proposal.md and the approved umbrella design sections 7–9. Current Neovim is 0.12.5; existing validation data is reused only for development, not fresh-install proof. Scripts already explicitly provision plugins, parsers and tool receipts. ToolHealth only prints managed paths. Review found StyLua/shfmt incorrectly classified as Windows .cmd, missing venv/Scripts formatter lookup, and host Python fallback limited to python3.

Installed cmux 0.64.25 (106) embeds Ghostty 1.3.2-HEAD (+4a0e9e185), whose CLI is a helper-only .none runtime. No standalone Ghostty.app was found under /Applications. The provided cmux-source directory contains only incomplete .git state, so protocol reference must be read from upstream/installed CLI without changing the application.

## Goals / Non-Goals

**Goals:** Reproducible complete setup and truthful executable acceptance; consolidate diagnostics without routine overhead. Protect the user's pasteboard and shared data.

**Non-Goals:** Additional plugins, Windows/WSL runtime claims, persistent user terminal config/OS changes, synthetic appearance success, performance tuning before phase 7 completes.

## Decisions

1. Health lives in `lua/config/health.lua` plus a native health adapter; `:SetupHealth` and `:checkhealth dotneovim` are on demand. Check local Git revisions, parser loading/queries, Mason receipt IDs and executability; never refresh registries. Preserve ToolHealth compatibility. Document build-only versus runtime prerequisites.
2. Use an explicit native-tool list for Windows suffixes and platform-aware virtualenv candidates. Test pure path decisions and real Mac interpreter selection; do not describe injected-platform tests as Windows execution. Existing argv-based process calls and native shell defaults are retained.
3. Create a fresh temp XDG hierarchy using the three existing scripts. Assert all revisions/receipts, deliberately move one plugin to a different existing commit and rerun explicit restore, then run all behavioral suites and attached startup matrix. Keep test fixture npm and Python Msgpack separate from editor dependencies.
4. Use a test-only Swift AppKit pasteboard helper to snapshot every item/type as data and restore in a finally path. Real Neovim input drives mappings; ordinary register isolation and replacement are observed against pbpaste. A text-only pbpaste backup would lose rich clipboard formats and is rejected.
5. Use a dedicated cmux workspace/surface, original foreground selection recorded and restored. The user subsequently authorized temporary light/dark switching and enabled UI automation/screen capture. Snapshot the system dark and automatic mode and restore them in finally; leave cmux/Ghostty configuration files and user pane contents unchanged. Actual OSC 11 startup and mode-2031 live handling must be observed with theme-derived highlights, and actual captured window images visually inspected. Protocol injection cannot establish host-generated switching.
6. After every isolated acceptance gate passes, resolve ~/.config/nvim and provision normal standard data explicitly, retaining old pack directories; verify normal startup/health. User approved installation. Record paths and commands in evidence, not machine-specific tracked config.

## Risks / Trade-offs

- Host appearance is app-global → use the subsequent explicit temporary-switch permission, capture/restore original system appearance keys, and operate only the test workspace contents.
- Registry or release downloads may fail → record actual failure, retry boundedly where appropriate, never mark provisioning passed.
- Attached RPC grids cannot prove font glyph rendering → use actual host presentation capture and font inspection as separate acceptance.
- Clipboard can change while testing → keep fixture short and restore all formats in finally, report restoration failure explicitly.

## Migration Plan

Implement fixes and docs, provision/test fresh isolation, run actual Mac acceptance, then normal provisioning. Validate strictly, sync owning deltas without rewriting Purpose, archive and only then commit; update umbrella ledger. On a required acceptance blocker leave the child active with exact incomplete tasks and do not commit runtime work.
