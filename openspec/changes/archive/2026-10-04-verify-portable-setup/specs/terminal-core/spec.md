# Spec Delta

## MODIFIED Requirements

### Requirement: Matched theme variants
The editor SHALL use the approved Gruvbox Material palette and accommodate both light and dark background values without forcing dark mode. Compatible terminal hosts SHALL select the matching variant automatically at startup and on native live appearance reports. Manual appearance selection SHALL be available for terminals lacking detection.

#### Scenario: Background variant changes
- **WHEN** the terminal or user changes the editor background between dark and light
- **THEN** the matching theme variant is applied with the agreed base foreground/background colors

#### Scenario: Installed Mac host reports appearance
- **WHEN** the installed cmux/Ghostty terminal supplies light/dark startup and live appearance reports
- **THEN** Neovim automatically follows both variants and updates theme-derived navigation/render/status highlights without user editor commands
- **AND** acceptance uses the actual host without modifying terminal configuration files; any user-authorized temporary appearance switch restores the original setting

## ADDED Requirements

### Requirement: Actual Mac clipboard integration
Mac clipboard acceptance SHALL exercise the real provider through the configured operator/visual yank and paste mappings while preserving the user's complete prior pasteboard contents around fixtures.

#### Scenario: Real clipboard round trip
- **WHEN** a fixture yanks via leader-y and pastes via leader-p using the Mac provider
- **THEN** the system clipboard and buffer contain the expected text, visual replacement preserves its source and ordinary native edits do not change the clipboard
- **AND** all prior pasteboard items and types are restored after the fixture
