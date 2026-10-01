# RainPointClient processor tests

## NUnit 5 test package

Test package **1.0.0** uses **NUnit 5.0.0**. It is independent of the product version. [Download package](https://github.com/oznetmaster/RainPointClient/releases/download/v1.2.1/RainPointClient.ProcessorTests-1.0.0.pkg), [documentation](https://github.com/oznetmaster/RainPointClient/releases/download/v1.2.1/RainPointClient.ProcessorTests-1.0.0-Documentation.zip), [validation](https://github.com/oznetmaster/RainPointClient/releases/download/v1.2.1/RainPointClient.ProcessorTests-1.0.0.validation.json), [exact source revisions](https://github.com/oznetmaster/RainPointClient/releases/download/v1.2.1/RainPointClient.ProcessorTests-1.0.0.sources.json), and [SHA-256 checksums](https://github.com/oznetmaster/RainPointClient/releases/download/v1.2.1/RainPointClient.ProcessorTests-1.0.0-SHA256SUMS.txt) are attached to the existing product release. No product binary or NuGet version changed for this test update.

Validated on 1 October 2026: 1399 offline cases passed in each of two runs from the packaged assembly on Windows. All suite identities were checked against source discovery. Live/manual tests and execution on the processor were not repeated during this migration; earlier hardware results do not certify this new package.

Independent test package 1.0.0, using NUnit 5.0.0 and the CrestronHomeNUnit 2.2.0 SDK with the source-pinned packaging resolver correction recorded in provenance. Runs the portable net472 library fixtures on the processor. Desktop WPF and Android suites remain in the client repository and are not processor-compatible assemblies.

Build with `./Build.ps1 -Package RainPointClient.ProcessorTests`; release builds require locked sources. The tile runs offline unit tests only. Live suites are manual-only and can change account settings or operate valves; they require the explicit test settings and device/account permissions documented by RainPointClient. No live tests are part of automatic migration validation.

Source and fixture documentation: https://github.com/oznetmaster/RainPointClient
