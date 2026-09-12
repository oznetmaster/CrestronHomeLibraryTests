# WeatherLinkLiveLibrary processor tests

Runs the shared [WeatherLink Live Library NUnit fixtures](https://github.com/oznetmaster/WeatherLinkLiveLibrary) inside Crestron Home. This package targets **net472 only**, uses official NUnit 4.6.1 and includes its own host. The source pin is library **v1.0.3**; library and fixture source remain in their independent repository.

## Build and deploy

Open **CrestronHomeLibraryTests.sln**, or the locally excluded **WeatherLink Live Library.Local.slnx** beside the original library solution. Build **WeatherLinkLiveLibrary.ProcessorTests** in **Debug**. With private `.csproj.user` settings configured, Visual Studio builds automatically deploy through SFTP. The original tracked library solution stays independent of Crestron.

The package is written to `packages/WeatherLinkLiveLibrary.ProcessorTests/bin/Debug/net472/WeatherLinkLiveLibrary.ProcessorTests.pkg`. Command-line `./Build.ps1 -Package WeatherLinkLiveLibrary.ProcessorTests` builds and validates without deployment.

For another checkout, run `Initialize-Sources.ps1 -UseLocalSources`. If a local source folder has a different name, supply the private `-LocalSourcePaths` hashtable mapping `WeatherLinkLiveLibrary` to its checkout path. Then create the optional local solution:

```powershell
./New-LocalLibrarySolution.ps1 -Source WeatherLinkLiveLibrary -SolutionFile 'WeatherLink Live Library.sln' -Package WeatherLinkLiveLibrary.ProcessorTests
```

Add **Utility → Neil Colvin → WeatherLinkLiveLibrary Tests** in Configure. The standalone tile discovers and runs the unit suite and displays the current port and test status. The port is automatically assigned and advertised through mDNS; no separate NUnit self-test package is required.

## Suites

| Suite | Tests | Behavior |
|---|---:|---|
| Unit Tests | 127 | All readings and conversions, HTTP and JSON errors, polling/cache timing, cancellation, concurrency, disposal, sensor ordering and settings validation. No device or network access needed. |
| Live Tests | 3 | Read current conditions, check cached metric conversions and refresh after a ten-second polling interval. |

Live Tests are manual-only and run through the Windows runner. They make read-only requests to the WeatherLink device; they do not modify any device settings. The standalone tile and release validation run only Unit Tests. The processor must be able to reach the WeatherLink device's local HTTP endpoint. No cloud account, API key or device credentials are required.

## Live inputs

In the Windows runner, use **Find packages**, select **WeatherLinkLiveLibrary Tests** and authenticate to the processor. Select **Live Tests**, then use **Test inputs…** to supply the private `LiveTestSettings.json` used for desktop WeatherLink tests. Locally, this file is beside `WeatherLinkLive.Tests.csproj`. A placeholder example is included in release documentation and [the library repository](https://github.com/oznetmaster/WeatherLinkLiveLibrary/blob/v1.0.3/WeatherLinkLive.Tests/LiveTestSettings.example.json).

The settings contain `ipAddress` and `enabled`. The runner supplies `TestDataDirectory` and `EnableLiveTests=true`, so `enabled` may stay false in the file for normal desktop testing. Use **Run all** in the Live Tests suite, or discover and select individual tests. Runner v1.0.2 or later shares inputs between suites in this package.

The actual IP settings are supplied at run time, never compiled, merged or copied into the package. Deployment credentials, machine paths, `.csproj.user`, private JSON and the local solution use `.git/info/exclude`, not tracked ignore rules. `PrepareRunner.ps1` can import private processor credentials into the runner's Windows-protected local storage.

## Validation and release

Discovery must find **130 tests**. Pre-release validation runs **127 automatic tests twice** from the merged package. The built package discovered all 130 tests, and all 127 automatic tests passed twice from the extracted, merged assembly on Windows. The desktop unit and live fixtures also passed on net472 and net10.0. On 12 September 2026, all **127 unit tests and 3 live tests passed on a Crestron Home processor**.

The package's initial version is **1.0.0**, independent of library version 1.0.3. Distribution is through **GitHub releases only**, never NuGet. See [release notes](RELEASE-NOTES.md) and [download v1.0.0](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases/tag/WeatherLinkLiveLibrary.ProcessorTests-v1.0.0).

## License and disclaimer

Copyright © 2026 Neil Colvin. Collection infrastructure is licensed under MIT with Commons Clause. WeatherLinkLiveLibrary and its tests retain their MIT license. See [third-party notices](THIRD-PARTY-NOTICES.md) and bundled licenses.

Crestron and Crestron Home are trademarks of Crestron Electronics, Inc. WeatherLink Live is a trademark of Davis Instruments. This independent package is not affiliated with, endorsed by or supported by Crestron or Davis Instruments. Crestron SDK licensing applies separately.
