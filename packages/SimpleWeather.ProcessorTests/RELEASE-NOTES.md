# SimpleWeatherClient Tests — v1.0.0 — 2026-09-12

- Runs the SimpleWeatherClient v1.0.3 NUnit fixtures on net472 inside Crestron Home.
- Separate suites for 117 offline unit tests and four opt-in, read-only live OpenWeather tests.
- Utility category, standalone unit-test tile, automatic TCP port and mDNS discovery.
- Live account settings supplied privately by the Windows runner; no API keys or deployment credentials embedded.
- Existing Visual Studio build/deploy pattern, including a locally excluded SimpleWeather.Local.slnx view.
- Full SimpleWeatherClient, NUnit and dependency licensing included.

Local validation discovered all 121 cases and passed the 117 automatic tests twice from the extracted package. The desktop suite passed on both target frameworks, including live account checks. Processor validation passed: **117 unit tests and all four live OpenWeather tests**. Distribution is through GitHub releases only; no processor package is published to NuGet.