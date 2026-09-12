# SimpleWeatherClient processor tests

Runs the shared [SimpleWeatherClient NUnit suite](https://github.com/oznetmaster/SimpleWeatherClient) inside a Crestron Home processor. This package targets **net472 only**, uses official NUnit 4.6.1, and includes its own test host. Library and fixture source stay in their independent repository; the initial source pin is **v1.0.3**.

## Build and deploy in Visual Studio

At this collection's root, run:

```powershell
./Initialize-Sources.ps1 -UseLocalSources
./New-LocalLibrarySolution.ps1 -Source SimpleWeather -SolutionFile SimpleWeather.sln -Package SimpleWeather.ProcessorTests
```

Open **SimpleWeather.Local.slnx** beside the library's original solution, or open **CrestronHomeLibraryTests.sln** in this collection. Build **SimpleWeather.ProcessorTests** in **Debug**. With private `.csproj.user` deployment settings configured, Debug builds inside Visual Studio automatically deploy the package. The original library solution stays unchanged; the local solution is excluded through the library's `.git/info/exclude`.

The output is `packages/SimpleWeather.ProcessorTests/bin/Debug/net472/SimpleWeather.ProcessorTests.pkg`. Command-line `./Build.ps1 -Package SimpleWeather.ProcessorTests` builds and validates without deployment.

After deployment, add **Utility → Neil Colvin → SimpleWeatherClient Tests** in Configure. The standalone tile discovers and runs Unit Tests and displays the host status and its current TCP port. The port is automatically assigned and advertised through mDNS. No separate NUnit self-test driver is required.

## Suites

| Suite | Tests | Behavior |
|---|---:|---|
| Unit Tests | 117 | Offline HTTP, cancellation, disposal, geocoding, model parsing, regional formatting and settings validation. No account or Internet access required. |
| Live Tests | 4 | Actual current weather, forecast readings, reverse geocoding and configurable city search using an OpenWeather account. |

Live Tests are manual-only and run through the Windows runner. The Home tile and automated package validation run only the unit suite. Each live test performs read-only requests, which count against the account's applicable quota. The processor needs Internet/DNS access to OpenWeather. Current weather and forecast use the library's normal One Call requests and free endpoint fallback when One Call access is unavailable.

## Live settings and the Windows runner

Use **Find packages**, select **SimpleWeatherClient Tests**, and authenticate with the processor's SFTP credentials. Select **Live Tests** and use **Test inputs…** to supply the private `LiveTestSettings.json` used by the library's desktop tests. Locally this file is beside `SimpleWeather.Tests.csproj`; the tracked [example](https://github.com/oznetmaster/SimpleWeatherClient/blob/v1.0.3/SimpleWeather.Tests/LiveTestSettings.example.json) is also included in release documentation.

Settings are `apiKey`, `latitude`, `longitude`, `units` (`metric`, `imperial` or `standard`), and optional `cityName`/`countryCode`. Use coordinates near a populated place for reverse geocoding. Direct city search skips if `cityName` is absent. It does not assume a reverse-geocoded locality can be found in the direct search index.

The runner supplies `TestDataDirectory` and `EnableLiveTests=true`, so JSON `enabled` may stay false for normal desktop testing. With runner v1.0.2 or later, inputs are shared between suites in this package and survive suite changes. Then use **Run all** in the Live Tests suite, or discover and select individual tests.

The settings and API key are not compiled, merged, copied into the package or published. Supply them at run time through the runner. Deployment credentials, local paths, `.csproj.user` and private settings use `.git/info/exclude`, not tracked ignore rules. Only the empty example is distributed. `PrepareRunner.ps1` can import the existing private processor deployment credentials into the runner's Windows-protected local storage.

## Validation and releases

Build-time validation discovered **121 tests** across the two suites. Local validation executed **117 automatic tests twice** from the actual merged package, with all tests passing both times. Desktop live checks have passed on net472 and net10.0; hardware validation also passed all **117 unit tests and four live tests** on a Crestron Home processor.

The package has its own initial version **1.0.0**, independent of SimpleWeatherClient 1.0.3. It is distributed through **GitHub releases only**, never NuGet. See [release notes](RELEASE-NOTES.md), the [v1.0.0 release](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases/tag/SimpleWeather.ProcessorTests-v1.0.0), and the collection release workflow.

## License and disclaimer

Copyright © 2026 Neil Colvin. Collection infrastructure is licensed under MIT with Commons Clause. SimpleWeatherClient and its tests retain their MIT license, including Ivan Gechev's original attribution. See [third-party notices](THIRD-PARTY-NOTICES.md) and bundled licenses.

Crestron and Crestron Home are trademarks of Crestron Electronics, Inc. OpenWeather names and services belong to their respective owners. This independent package is not affiliated with, endorsed by or supported by Crestron or OpenWeather. Crestron SDK and OpenWeather account terms apply separately.