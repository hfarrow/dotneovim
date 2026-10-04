# Spec Delta

## ADDED Requirements

### Requirement: Warm file startup budget
On the tested Mac with provisioned dependencies, warmed median process-launch-to-useful-attached-redraw latency SHALL be at most 100 ms for text, code and Markdown fixtures. Evidence SHALL separately report VimEnter and process lifetime, at least ten samples/scenario, median/p95, environment/revisions and first empty-cache launches without claiming OS-cold measurements.

#### Scenario: File-launch acceptance
- **WHEN** representative text, code and Markdown fixtures launch repeatedly with a warm editor cache
- **THEN** each useful content redraw meets the median budget and its full sample distribution is published
- **AND** minimal and runnable original reference comparisons use the same metric; failures are reported rather than counted as successful baseline timings
