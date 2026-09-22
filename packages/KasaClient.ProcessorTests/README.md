# KasaTapoClient Tests processor package

Open `CrestronHomeLibraryTests.sln` at the collection repository root and build `KasaClient.ProcessorTests.csproj` in Visual Studio. Command-line builds skip packaging unless `-p:BuildProcessorTestPackages=true` is supplied. The package is written to `bin\Debug\net472\KasaClient.ProcessorTests.pkg`.

The project imports the shared host and build tools from `ProcessorTestSdkRoot`. Override that property in `KasaClient.ProcessorTests.Local.targets` if the SDK checkout is elsewhere. Source tests remain in the referenced test project; no fixture copies are maintained here. NUnit and all application dependencies are merged; Crestron SDK libraries remain platform dependencies.

The build stages the Home UI, validates discovery from the merged and patched assembly, constructs the package, and normalizes its ZIP entries. Debug builds increment the build version; Release version increments are reserved for CI. Auto-deployment uses the existing shared SFTP script and the local `.csproj.user` settings, only for Debug builds inside Visual Studio.

Driver name: **KasaTapoClient Tests**. Manufacturer: **Neil Colvin**. TCP port: **automatically assigned**. Use **Find packages** in the Windows runner; the Home tile shows the current port for manual connections.

The Windows runner discovers Unit Tests and Live Tests from the package. Unit Tests are selected by default. Live Tests require explicit selection and may operate physical devices.

Choose configuration files using **Test inputs…** in the Windows runner before discovery or execution. Inputs are kept outside the package and sent over an authenticated, encrypted configuration channel. Each suite has its own inputs. Tests locate files through `TestContext.Parameters.Get("TestDataDirectory", AppContext.BaseDirectory)`. The test suite must reload its configuration between operations rather than cache the first discovery indefinitely.

For this suite, supply `LiveTestSettings.json` to the Live Tests suite. The runner supplies the NUnit `EnableLiveTests` parameter for the selected live suite, overriding the JSON switch for this operation only. The JSON `Enabled` value can remain false. Secrets are never automatically embedded in the `.pkg`. Transferred files reside in the driver's private data directory and remain stored until replaced or cleared through the runner. Live runs cannot be started from the Home tile.

Build the latest Windows runner before connecting. After deployment and activation, `PrepareRunner.ps1` imports deployment credentials into Windows-protected local storage. Select **Find packages** and choose this package. It connects automatically when processor credentials are available; otherwise enter the SFTP username and password and use **Connect**. The suite list becomes available after connection.

The package validator discovers every suite, but its optional `--run-twice` check executes only suites whose `ManualOnly` property is false. Do not remove that property from hardware or other opt-in suites.

## Kasa-specific live validation

The package includes 123 deterministic unit tests and seven live test fixtures; configuration can expand live cases for multiple devices. Prefer stable device IDs or unique discovery aliases in private settings so the fixture resolves the current address at execution time.

Discovery results are shared within one run and reset for the next run. Progress reports discovery, connection, action and restoration timings. Tests that change a device capture its current state and restore it in `finally`, including after failed assertions. Restoration is refreshed and checked; a restoration failure fails the test.

Set `observationDelayMilliseconds` to `0` to omit deliberate observation pauses. Configure `temperatureChildDeviceId` on a hub entry for a read-only T310/T315 temperature check. The `Unattended` category allows selecting it separately from tests that operate devices. This refreshes the hub's reported reading; it does not prove the sensor transmitted a new sample between requests.

Use the public [sample settings](https://github.com/oznetmaster/KasaTapoClient/blob/main/KasaClient.Tests/LiveTestSettings.sample.json) to create your private `LiveTestSettings.json`. The library [test documentation](https://github.com/oznetmaster/KasaTapoClient#testing-and-benchmark-scaffolding) describes all device selectors and options. Never commit real settings or attach live results to a release.

Validation on 2026-09-22 passed all 123 offline and seven live tests on the processor against the KasaTapoClient 2.0 source. Desktop validation passed the same suites on net472 and net10.0. Desktop test adapters and runners are excluded from the merged processor package; NUnit remains included.
