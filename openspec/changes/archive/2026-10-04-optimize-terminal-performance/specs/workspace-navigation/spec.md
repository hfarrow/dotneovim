# Spec Delta

## ADDED Requirements

### Requirement: Warm dashboard startup budget
Warmed median process-launch-to-useful-attached-redraw latency SHALL be at most 150 ms for empty, directory and explicit dashboard launches on the tested Mac, with the Hyper header/actions visible and tree hidden. At least ten samples per scenario and median/p95 SHALL be published.

#### Scenario: Dashboard readiness
- **WHEN** each dashboard invocation is measured after provisioning and cache warmup
- **THEN** a flushed grid containing the usable dashboard is observed within the median budget, not inferred from VimEnter or process exit

### Requirement: Deferred first operations are measured
Acceptance SHALL measure actual first tree, picker, completion-menu and terminal readiness in separate fresh editor processes, retaining working first actions rather than hiding their latency through deferral. Routine startup SHALL perform no update/download work.

#### Scenario: First action after startup
- **WHEN** the first requested operation is invoked through real input
- **THEN** its useful UI/results or shell output appears and latency/sample definitions are reported separately from startup
