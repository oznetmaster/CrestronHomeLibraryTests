# SimpleWeatherClient Tests

## 1.0.1

- Rebuild the existing suite with CrestronHomeNUnit 1.2.1 so processor execution participates in the shared reservation used by the runner, Test Explorer, CLI and hardware CI.
- Add the collection's Test Explorer workflow project for build, deployment, execution and optional temporary-instance cleanup. Independent library solutions can include it through an excluded local composite solution.
- Device-sensitive live suites remain optional. Credentials and local settings are supplied privately and are not included in this package.
- The processor package remains net472-only and appears in Configure's Utility category. This release contains GitHub assets only; it publishes no NuGet package or underlying library change.

## 1.0.0 - 2026-09-12

- Runs the SimpleWeatherClient v1.0.3 NUnit fixtures on net472 inside Crestron Home.
- Separate suites for 117 offline unit tests and four opt-in, read-only live OpenWeather tests.
- Utility category, standalone unit-test tile, automatic TCP port and mDNS discovery.
- Live account settings supplied privately by the Windows runner; no API keys or deployment credentials embedded.
- Existing Visual Studio build/deploy pattern, including a locally excluded SimpleWeather.Local.slnx view.
- Full SimpleWeatherClient, NUnit and dependency licensing included.

Local validation discovered all 121 cases and passed the 117 automatic tests twice from the extracted package. The desktop suite passed on both target frameworks, including live account checks. Processor validation passed: **117 unit tests and all four live OpenWeather tests**. Distribution is through GitHub releases only; no processor package is published to NuGet.