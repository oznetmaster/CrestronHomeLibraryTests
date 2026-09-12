# WiserHeatAPIv2 processor tests

This package runs the shared [WiserHeatAPIv2 NUnit fixtures](https://github.com/oznetmaster/WiserHeatAPIv2) inside a Crestron Home processor. The package targets **net472** and uses the official NUnit framework. Fixture source remains in the independent library repository.

## Build and deploy

Run `Initialize-Sources.ps1 -UseLocalSources` at the collection root and open **CrestronHomeLibraryTests.sln**. Build **WiserHeatAPIv2.ProcessorTests** in Debug. Private `.csproj.user` settings enable automatic deployment for Debug builds in Visual Studio. Command-line builds use `./Build.ps1 -Package WiserHeatAPIv2.ProcessorTests` and do not deploy.

For the same local solution view as the other libraries, run this at the collection root:

```powershell
./New-LocalLibrarySolution.ps1 -Source WiserHeatAPIv2 -SolutionFile WiserHeatAPIv2.sln -Package WiserHeatAPIv2.ProcessorTests
```

Open **WiserHeatAPIv2.Local.slnx** beside the original library solution, then build **WiserHeatAPIv2.ProcessorTests** in Debug. This local solution is excluded through the library's `.git/info/exclude` and references the package in this collection. The original library solution stays unchanged.

The output is `packages/WiserHeatAPIv2.ProcessorTests/bin/Debug/net472/WiserHeatAPIv2.ProcessorTests.pkg`. In Configure, add **Utility → Neil Colvin → WiserHeatAPIv2 Tests**. This package includes its own host; no separate NUnit self-test driver is required. Its port is automatically assigned and advertised through mDNS.

## Suites

| Runner suite | Tests | Behavior |
|---|---:|---|
| Unit Tests | 138 | Offline fixtures, including HTTP, models, schedules, lifecycle, configuration, and restoration guards. |
| Read-only Live Tests | 7 | Reads a configured Wiser hub; optional OpenTherm or unavailable collections may skip. |
| Room Control Tests | 2 | Runs the control fixture for the room named in private settings. Toggles/restores window detection and briefly lowers/restores a scheduled temperature setpoint. |

The standalone tile discovers and runs only Unit Tests. Both live suites are manual-only and require the Windows runner. The control suite selects its fixture by name and supports **Run all** without an additional NUnit explicit-test selection. CI and packaged automatic validation never execute either live suite.

## Private test inputs

Use **Find packages** in the Windows runner and connect with the processor's SFTP credentials. Select the desired live suite, then use **Test inputs…** to supply `LiveTestSettings.json`. With Windows runner 1.0.2 or later, inputs are shared across all suites in this processor package; select the file once and retain it when switching between read-only and control tests. Runner 1.0.1 and earlier stored inputs separately for each suite.

Start with the library's [empty example](https://github.com/oznetmaster/WiserHeatAPIv2/blob/master/WiserHeatAPIv2.Tests/LiveTestSettings.example.json). Set `hubHost` and `secret` for a hub reachable from the processor. For control tests, also set `controlRoomName` to exactly one room. `timeoutSeconds` is 1–120, default 60. The runner supplies `TestDataDirectory` and `EnableLiveTests=true` for the selected live suite, so the JSON `enabled` value may remain false. The processor tests use JSON, not the console's `wiserkeys.params` file.

Keep the real file outside source checkouts. It is not compiled, merged, copied into the package, or published. Deployment credentials, local paths and `.csproj.user` files are excluded using `.git/info/exclude`. Only a blank example is distributed with release documentation.

## Room restoration

Run control tests from only one runner/framework at a time. Each test reads the original setting and restores it in `finally` with an independent cleanup timeout, then reads back the result. The temperature test requires Auto mode following a schedule, with no existing override, boost or timer; otherwise it skips. It lowers the setpoint by 0.5°C using a one-minute override, then cancels the override and verifies schedule control. It does not change the schedule assignment or room mode. Interrupted processes or loss of hub connectivity can prevent cleanup; the temperature override expires, but window detection may need manual restoration.

## Validation and release

Validation of the finished `.pkg` discovered **147** tests across all suites. All **138** automatic tests passed twice in the same desktop process using the merged package assembly. Desktop live validation passed on net472 and net10.0: six read-only tests passed, optional OpenTherm skipped, and both room-control tests passed with restoration confirmed. Processor validation was reported by the user: 138 unit tests, six read-only live tests and both room-control tests passed; OpenTherm was unavailable as expected. Processor result XML was not collected for this report.

This package is a GitHub release asset, **not a NuGet package**. Its independent initial release version is 1.0.0. This initial version has completed processor validation.

## License and attribution

Copyright © 2026 Neil Colvin. Package infrastructure uses this collection's MIT with Commons Clause license. WiserHeatAPIv2 and its tests retain their MIT license. See [third-party notices](THIRD-PARTY-NOTICES.md) and the included licenses. Crestron, Drayton, Wiser and Schneider Electric trademarks belong to their owners; this independent package is not affiliated with or endorsed by them.