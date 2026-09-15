# WiserHeatAPIv2 Tests

## 1.0.1

- Rebuild the existing suite with CrestronHomeNUnit 1.2.1 so processor execution participates in the shared reservation used by the runner, Test Explorer, CLI and hardware CI.
- Add the collection's Test Explorer workflow project for build, deployment, execution and optional temporary-instance cleanup. Independent library solutions can include it through an excluded local composite solution.
- Device-sensitive live suites remain optional. Credentials and local settings are supplied privately and are not included in this package.
- The processor package remains net472-only and appears in Configure's Utility category. This release contains GitHub assets only; it publishes no NuGet package or underlying library change.

- Runs the shared WiserHeatAPIv2 fixtures on net472 inside Crestron Home.
- Separate suites for 138 offline tests, seven read-only live tests and two opt-in room-control tests.
- Utility category, standalone unit-test tile, automatically assigned TCP port and mDNS discovery.
- Live settings supplied privately by the Windows runner; no credentials or local settings embedded.
- Control tests capture, restore and verify the selected room's state.

Desktop fixtures have been validated on both target frameworks. The finished package discovers all 147 tests, and all 138 automatic tests passed twice in the same desktop process. Processor validation reported 138 unit tests, six read-only live tests and both room-control tests passed, with the expected unavailable OpenTherm result. Use Windows runner 1.0.2 or later to retain test inputs when switching suites. Room-control tests support Run all in their dedicated manual suite and restore the selected room settings. This package is distributed through GitHub releases only, not NuGet.