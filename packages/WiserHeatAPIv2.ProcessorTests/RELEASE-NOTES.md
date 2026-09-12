# WiserHeatAPIv2 Tests v1.0.0

- Runs the shared WiserHeatAPIv2 fixtures on net472 inside Crestron Home.
- Separate suites for 138 offline tests, seven read-only live tests and two opt-in room-control tests.
- Utility category, standalone unit-test tile, automatically assigned TCP port and mDNS discovery.
- Live settings supplied privately by the Windows runner; no credentials or local settings embedded.
- Control tests capture, restore and verify the selected room's state.

Desktop fixtures have been validated on both target frameworks. The finished package discovers all 147 tests, and all 138 automatic tests passed twice in the same desktop process. Processor validation reported 138 unit tests, six read-only live tests and both room-control tests passed, with the expected unavailable OpenTherm result. Use Windows runner 1.0.2 or later to retain test inputs when switching suites. Room-control tests support Run all in their dedicated manual suite and restore the selected room settings. This package is distributed through GitHub releases only, not NuGet.