# Spec Delta

## ADDED Requirements

### Requirement: Consolidated setup health
The editor SHALL expose on-demand health reporting for locked plugins, focused parsers, exact managed tool receipts and executable paths, external prerequisites and clipboard providers, with actionable setup commands. Setup guidance SHALL cover macOS, Windows and WSL and distinguish reviewed portability from executed runtime acceptance.

#### Scenario: Fresh environment acceptance
- **WHEN** documented explicit provisioning runs in a new isolated environment
- **THEN** all locked plugins, focused platform-built parsers and manifest tool versions are available and health reports their actual state
- **AND** locked restore recovers a deliberately displaced plugin revision without changing the lockfile

#### Scenario: Missing setup dependency
- **WHEN** a dependency is missing or has the wrong receipt/revision
- **THEN** on-demand health identifies it and its explicit remedy without downloading during the check

#### Scenario: Platform setup review
- **WHEN** platform setup is published
- **THEN** config/data paths, executable suffixes, shells, build prerequisites and clipboard assumptions are explicit and Windows/WSL runtime checks remain labeled untested until executed
