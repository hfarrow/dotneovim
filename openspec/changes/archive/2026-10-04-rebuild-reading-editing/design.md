# Design

## Context

See proposal.md and umbrella sections 3/7. Neovim 0.12.5 requires the rewritten Tree-sitter main APIs. The personal `spell/en.utf-8.add` source and binary exist and will not be overwritten.

## Goals / Non-Goals

**Goals:** Current upstream contracts, no startup downloads, real parser and key behavior, reusable large-file guard for upcoming language tooling.

**Non-Goals:** Parser indentation, textobject swapping, Leap visit/treeselect, external Markdown preview.

## Decisions

- Eager Tree-sitter main and compatible textobjects main, locked current revisions. Explicit `scripts/parsers.lua` installs only lua/bash/javascript/typescript/tsx/python/c_sharp/rust/markdown/markdown_inline plus vim/vimdoc/query support. CLI >=0.26.1, clang, tar/curl required; Homebrew package is `tree-sitter-cli`, distinct from the runtime library `tree-sitter`.
- Shared guard: >1 MiB or any line >10,000 bytes. Mark before FileType/semantic attachment and stop decorations if content grows. No runtime parser installation. Missing-parser warnings are once per language.
- Query-aware buffer-local textobjects/movements are installed only where captures exist, preserving default native motions otherwise. Function/class outer linewise, argument charwise. No global ftplugin-disable blanket.
- Surround v4 defaults disabled in init; eager lightweight registration and explicit Plug keys avoid replaying operators. `gz/gZ/gzz/gZZ/gzd/gzc`, visual `gz/gZ`, insert Ctrl-g z/Z. Current Codeberg Leap eager registration with internal lazy loading and only `s/S` Plug maps. Autopairs on InsertEnter, no completion integration.
- Rainbow excludes guarded buffers. Render-markdown Markdown-only, normal-mode rendering and raw insert view, explicit leader-um toggle, guard callback. Native local spell in Markdown/text uses the preserved source; link opening uses native gx rather than restoring bespoke blog functions. Add checkout after/ runtimepath explicitly so overrides load after defaults.

## Risks / Trade-offs

- [Current parser ABI/query drift] → Lock plugin revision and provision exact parser revisions from its table; record evidence.
- [Filetype defaults overwrite native motions] → Install only available query captures buffer-locally after runtime ftplugins; undo cleanup.
- [Decoration on growing buffers] → Guard recheck and stop parser/rainbow/renderer on threshold crossing.

## Migration Plan

Provision plugins and parsers explicitly, test real objects/aids/rendering and fallback, update docs, sync/archive then commit. Rollback by reverting and restoring the preceding plugin lock; leave user spell data intact.
