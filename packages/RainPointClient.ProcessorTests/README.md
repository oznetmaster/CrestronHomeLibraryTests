# RainPointClient processor tests

Independent test package 1.0.0, using NUnit 5.0.0 and the released CrestronHomeNUnit 2.2.0 SDK. Runs the portable net472 library fixtures on the processor. Desktop WPF and Android suites remain in the client repository and are not processor-compatible assemblies.

Build with `./Build.ps1 -Package RainPointClient.ProcessorTests`; release builds require locked sources. The tile runs offline unit tests only. Live suites are manual-only and can change account settings or operate valves; they require the explicit test settings and device/account permissions documented by RainPointClient. No live tests are part of automatic migration validation.

Source and fixture documentation: https://github.com/oznetmaster/RainPointClient
