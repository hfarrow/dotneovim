# Spec Delta

## Purpose

Provide an approval-gated, reproducible delivery process for rebuilding the terminal Neovim configuration in small verified increments. Keep agreed workflows, implementation progress, compatibility decisions, and validation evidence recoverable from repository artifacts.

## ADDED Requirements

### Requirement: Initial roadmap approval

The rebuild MUST present its high-level scope, incremental changes, dependency choices, and validation strategy for user approval before changing runtime configuration. Material departures from the approved scope MUST be reviewed before implementation.

#### Scenario: Roadmap is awaiting review
- **WHEN** exploration and workflow interviews have produced an initial proposal
- **THEN** the proposal is available for review and runtime configuration remains unmodified
- **AND** unchecked implementation tasks are not reported as completed

#### Scenario: User authorizes execution
- **WHEN** the user subsequently approves the roadmap for execution
- **THEN** the incremental delivery process proceeds within the approved scope
- **AND** unresolved checks or new scope decisions are surfaced rather than silently dropped

### Requirement: Incremental implementation contracts

Every substantive rebuild increment MUST have its own OpenSpec proposal, applicable capability delta specs, design decisions, and actionable tasks before implementation. Its acceptance scenarios and checks MUST be completed or reported as blocked before it is considered finished.

#### Scenario: An increment is ready to implement
- **WHEN** a roadmap phase enters implementation
- **THEN** its artifacts define observable outcomes, dependency/load-order choices, mapping ownership, setup requirements, and verification
- **AND** the approved umbrella design is referenced as context

#### Scenario: A required check cannot run
- **WHEN** an increment cannot verify an acceptance scenario because a tool or environment is unavailable
- **THEN** its evidence records the blocker and the task remains incomplete unless the user explicitly revises acceptance

### Requirement: Reviewable version-control checkpoints

Rebuild commits MUST be made on a new branch, with only intended files staged. Completed increments MUST be validated, have their delta specs synchronized through archive, and be recorded with their validation evidence in reviewable commits. The initial reference commit MUST remain recoverable throughout the rebuild.

#### Scenario: An increment is finalized
- **WHEN** its implementation and required validation pass
- **THEN** its tasks are complete, its change is archived, and its intended files are committed on the rebuild branch
- **AND** the commit and evidence allow the increment to be identified and rolled back

#### Scenario: Reference comparison is needed
- **WHEN** a preference or regression needs comparison with the original configuration
- **THEN** the detached reference worktree or recorded reference commit supplies the original configuration independently of rebuild commits

### Requirement: Bounded initial runtime scope

The delivered initial configuration MUST target standalone terminal Neovim and the approved lightweight reading, searching, and editing workflows. Installed historical plugins MUST NOT become requirements merely because they appear in the reference. Follow-up host integrations and omitted capabilities MUST remain explicit future scope.

#### Scenario: Historical functionality is outside the approved core
- **WHEN** a reference plugin supplies debugging, clipboard-history persistence, a buffer bar, Zen Mode, or an unrelated language integration
- **THEN** it is omitted from the initial dependency set unless the user approves a scope change

#### Scenario: A future host integration is requested
- **WHEN** VS Code or IdeaVim support becomes an active requirement
- **THEN** it is planned as a follow-up change using separately organized core editing preferences and host-specific behavior

### Requirement: Reproducible dependency provisioning

The configuration MUST record tested plugin revisions and externally managed editor-tool versions, provide explicit installation/update procedures, and avoid routine startup downloads after provisioning. Project-required tools and configuration MUST take priority over editor defaults without arbitrary system-tool substitution.

#### Scenario: A fresh machine is provisioned
- **WHEN** documented runtime and build prerequisites are available
- **THEN** the setup procedure restores the recorded plugin/tool set and installs the focused parser set for that platform
- **AND** the procedure distinguishes project dependencies from editor-managed tools

#### Scenario: An established configuration starts offline
- **WHEN** its dependencies have been provisioned and network access is unavailable
- **THEN** basic startup, file reading, and installed workflows remain usable without an update/install attempt

### Requirement: Platform-specific validation evidence

Each increment MUST record relevant successful checks, failed checks, and untested platform assumptions. macOS MUST receive executable validation; Windows and WSL portability MUST receive documented setup/path/runtime review without being described as tested when they were not exercised.

#### Scenario: A portability feature is reported complete
- **WHEN** setup documentation and portable process/path handling have been reviewed on macOS
- **THEN** evidence distinguishes macOS checks from Windows/WSL design review and lists their remaining runtime checks

### Requirement: Performance verification

The rebuild MUST capture repeatable startup and first-use measurements, audit unnecessary eager loading, and validate responsive large-file reading. Final performance evidence MUST state the measured environment, cold/warm definitions, sample counts, and unresolved regressions rather than treating deferred work as eliminated latency.

#### Scenario: Final optimization is completed
- **WHEN** all approved runtime increments are installed
- **THEN** measurements compare the rebuilt configuration with a minimal baseline and the original configuration where runnable
- **AND** file, directory/dashboard, Markdown, code, and large-log scenarios are checked
- **AND** first picker, tree, completion, and terminal-use latency is reported alongside startup
