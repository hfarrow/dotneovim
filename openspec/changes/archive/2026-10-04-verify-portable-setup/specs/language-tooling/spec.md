# Spec Delta

## ADDED Requirements

### Requirement: Platform executable and interpreter paths
Managed tools SHALL resolve to the platform's native executable or command wrapper in the managed bin directory. Python project discovery SHALL recognize both .venv and venv layouts for the active platform and use an available host Python only when no project or explicit virtual environment is available.

#### Scenario: Windows path review
- **WHEN** native Windows paths are selected
- **THEN** native tools resolve with .exe, Node transports with .cmd, and both project environment names resolve Scripts/python.exe and formatter executables
- **AND** macOS/WSL retain POSIX bin paths without Windows suffixes

#### Scenario: Project Python environment
- **WHEN** a project environment or explicit VIRTUAL_ENV exists
- **THEN** its Python interpreter is selected independently of the managed language server runtime
