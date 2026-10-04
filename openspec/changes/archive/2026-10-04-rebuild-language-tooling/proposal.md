# Proposal

## Why

Phase 4 supplies semantic editing for the agreed four language families. Managed tools and completion acceptance need explicit ownership before any server starts.

## What Changes

- Versioned explicit Mason provisioning; no routine registry refresh/downloads or host-tool fallback.
- Native LSP definitions/activation for Bash, JS/TS, Lua and Python with quiet diagnostics.
- Stable Blink v1 automatic no-preselect completion, selected Ctrl-y acceptance and native snippets.
- Zsh native syntax plus buffer/path completion, C#/Rust syntax-only, large-file exclusions.

## Capabilities

### New Capabilities

- `language-tooling`: Managed tools, semantic attachment, diagnostics and completion.

### Modified Capabilities

None.

## Impact

Adds tool manifest/provisioning, native LSP configuration and completion specs/tests/docs. Requires Node >=22.22.2 and Python >=3.10. Current TS transport requires TypeScript <7; pin 6.0.3 and honor compatible project versions.
