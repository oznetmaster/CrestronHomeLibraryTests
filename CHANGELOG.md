# Changelog

## TeslaPowerwallLibrary.ProcessorTests v1.0.1 - 2026-09-15

Published processor test package on GitHub. This is a test-package release only; no driver or library NuGet package is published. See the matching package release notes for changes and validation.

## 2026-09-15 - Collection source and Test Explorer integration

- Add Test Explorer workflow projects for all seven library processor packages, with offline discovery checks and excluded local solution views. Private plans control hardware execution and cleanup.
- Refresh TeslaPowerwallLibrary to 1.2.5 and expand its processor suite from 99 to 118 deterministic tests, including Fleet refresh and automatic region discovery.

- Add pull-request and main-branch validation for all seven processor packages using pinned source revisions. Build real packages, run ordinary desktop tests, verify packaged discovery and run each automatic packaged suite twice. Live tests remain opt-in.
- Update the shared host to the released 1.2.1 tooling source, including processor coordination between desktop tools, deployment and standalone test tiles.
- Refresh Apple TV, Tesla and Kasa source pins to their validated CI updates. No library or NuGet release is created by these collection checks; individual processor package releases remain separate manual operations.


Individual processor package versions are published separately on GitHub. These dated source changes do not announce a package release.