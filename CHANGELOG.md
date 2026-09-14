# Changelog

## Unreleased

- Add pull-request and main-branch validation for all seven processor packages using pinned source revisions. Build real packages, run ordinary desktop tests, verify packaged discovery and run each automatic packaged suite twice. Live tests remain opt-in.
- Update the shared host to the released 1.2.0 tooling source plus its CI check fix, including processor coordination between desktop tools, deployment and standalone test tiles.
- Refresh Apple TV, Tesla and Kasa source pins to their validated CI updates. No library or NuGet release is created by these collection checks; individual processor package releases remain separate manual operations.
