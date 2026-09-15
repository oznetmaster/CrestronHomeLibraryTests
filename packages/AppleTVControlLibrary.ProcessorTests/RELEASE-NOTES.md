# AppleTVControlLibrary Tests

## 1.0.1

- Rebuild the existing suite with CrestronHomeNUnit 1.2.1 so processor execution participates in the shared reservation used by the runner, Test Explorer, CLI and hardware CI.
- Add the collection's Test Explorer workflow project for build, deployment, execution and optional temporary-instance cleanup. Independent library solutions can include it through an excluded local composite solution.
- Device-sensitive live suites remain optional. Credentials and local settings are supplied privately and are not included in this package.
- The processor package remains net472-only and appears in Configure's Utility category. This release contains GitHub assets only; it publishes no NuGet package or underlying library change.

Initial processor package with 229 NUnit unit tests and a separate optional suite of five simulated-device socket discovery tests. Includes a standalone Crestron Home tile in the Utility category and Windows runner support through automatic mDNS discovery.

Validation: all 229 unit tests and all 5 optional socket discovery tests passed on the development Crestron Home processor. The same fixtures also pass on Windows net472 and .NET 10, and the merged unit suite passed twice in one process. Release automation independently rebuilds and validates the package from pinned sources.

This release packages tests only. Apple TV library versions and NuGet packages are unchanged. Credentials and local deployment settings are not included.