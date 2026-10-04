# Spec Delta

## Purpose

Make plugin installation, updates, restore, and normal startup predictable and portable across machines.

## ADDED Requirements

### Requirement: Explicit locked provisioning
The configuration SHALL provide an explicit bootstrap/install operation and track tested plugin revisions. A new environment SHALL restore those revisions rather than arbitrary upstream HEAD. Updates SHALL be explicit.

#### Scenario: Clean installation
- **WHEN** the documented setup operation runs with Neovim and Git available
- **THEN** the manager and declared plugins install at recorded revisions
- **AND** the configuration starts using them without a generated loader

### Requirement: Offline provisioned startup
Routine startup SHALL NOT install or update dependencies. Missing dependencies SHALL produce actionable setup guidance while core editing remains available.

#### Scenario: Dependencies already exist
- **WHEN** provisioned Neovim starts without network access
- **THEN** it starts without initiating dependency downloads or updates

#### Scenario: First startup precedes provisioning
- **WHEN** the manager or a declared plugin is missing
- **THEN** the user can read/edit files and is told how to install dependencies explicitly

### Requirement: Legacy plugin isolation
The new runtime SHALL not automatically load historical unmanaged start packages. It SHALL retain installed user data on disk and use portable standard paths for its own dependencies.

#### Scenario: Old Packer installations remain
- **WHEN** the new configuration starts with legacy start packages in the data directory
- **THEN** those plugins are not sourced by the new runtime
- **AND** their directories are not deleted
