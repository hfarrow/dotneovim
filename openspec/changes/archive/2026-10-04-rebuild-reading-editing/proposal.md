# Proposal

## Why

Phase 3 adds the approved reading and structural editing aids to the tested foundation/navigation setup. Parser-backed behavior must be installed deliberately and degrade safely for large or unsupported files.

## What Changes

- Add focused current Tree-sitter highlighting/textobjects, rainbow delimiters and explicit parser provisioning.
- Restore `gz` surrounds, automatic pairs and current Codeberg Leap with first-operation-safe loading.
- Add local Markdown rendering/spell/toggle/link behavior and shared large-file safeguards.

## Capabilities

### New Capabilities

- `reading-editing`: Syntax, structural selection/movement, editing aids and local prose presentation.

### Modified Capabilities

None.

## Impact

New plugin specs, reading/size modules, after/ftplugin overrides, parser installer, fixtures and docs. Parser builds require tree-sitter CLI >=0.26.1, C compiler, curl and tar. Personal spell source stays preserved.
