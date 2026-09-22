# TeslaPowerwallLibrary Tests

A self-contained NUnit test package for Crestron Home, built from the original library test project. It contains **142 deterministic tests**: Fleet refresh and automatic region discovery, facade guards and mode selection, token-cache persistence, JSON models, calendar-history parsing, validation helpers and enum/version contracts, partial operation writes, numeric zero reserve, typed System.Text.Json mapping and caller-owned ILogger contexts. The automatic suite never operates a Powerwall and requires no Tesla account or live-device settings. The separate manual live suite contains three read-only tests and requires dedicated credentials.

## Build and run

Open `CrestronHomeLibraryTests.sln` and build **TeslaPowerwallLibrary.ProcessorTests** in Debug. The processor project targets only **net472**. Debug builds increment its build number and deploy when enabled through its private `.csproj.user`. The library's own solution remains independent; `New-LocalLibrarySolution.ps1` can create an excluded local solution view containing this package.

The output is `bin/Debug/net472/TeslaPowerwallLibrary.ProcessorTests.pkg`. In Crestron Home Configure, add **Utility → Neil Colvin → TeslaPowerwallLibrary Tests** to a room. The standalone Home tile runs the unit suite and shows its result. In the Windows runner, choose **Find packages**, select the package, then discover or run its tests. Its TCP port is assigned automatically. The separate NUnit self-test host is not required.

Temporary token-cache files use NUnit's work directory and are deleted by the fixtures. The missing-token test has its own empty cache so it cannot use a developer's saved tokens. Test values are synthetic. Tests are rediscovered for each operation and can be run repeatedly.

## Source and releases

The fixtures stay in [TeslaPowerwallLibrary](https://github.com/oznetmaster/TeslaPowerwallLibrary); NUnit3TestAdapter runs the same 142 cases on net472 and .NET 10 in Visual Studio and CI. `sources.lock.json` pins the exact library and shared host SDK commits. This project's public releases use `TeslaPowerwallLibrary.ProcessorTests-v<version>` and never publish or change the library's NuGet package.

Use the collection's **Release processor tests** workflow and select this package. CI validates both desktop targets and packaged discovery. Processor execution is a separate hardware validation step. Private deployment credentials and machine paths belong in `.git/info/exclude` and are never release assets.

See [third-party notices](THIRD-PARTY-NOTICES.md) for dependencies and the collection README for common installation instructions and Crestron trademark/non-association notices. Tesla and Powerwall are trademarks of Tesla, Inc.; this is an independent, unofficial test package and is not affiliated with or endorsed by Tesla.

## September 2026 migration validation

The embedded package uses System.Text.Json and Microsoft.Extensions.Logging.Abstractions. Desktop test hosts, adapters and their Newtonsoft.Json dependency are excluded from the merged processor assembly. The dependency regression checks accept both separate desktop assemblies and the merged processor assembly. Run the complete suite on the processor after rebuilding; desktop success alone does not establish Mono compatibility.

Validation on 22 September 2026: all 142 tests passed twice in the merged assembly on Windows and twice on the development processor. The workflow also passed 142 library tests on each desktop target and 59 credential/tool tests. Test identities matched across merged local and processor results. Test package 1.0.001.0004 was removed after the temporary instance was removed, and the processor reservation was released. No actual driver update, Tesla authentication, Powerwall operation or processor reboot was performed. These are local development results, not a package release.

## Explicit live API validation

The three read-only Live cases validate site selection, typed power/battery readings and refreshed operating configuration. Run this suite separately with dedicated Owner and Fleet credential-helper sessions: the APIs use distinct connections. EnableLiveTests must be true when using the helper-generated private LiveTestSettings.json input. Refresh tokens never enter the test host. The processor live suite is manual-only; the 142 deterministic cases remain credential-free.


Read-only live validation on 22 September 2026 passed separately against the Owner and Fleet APIs. In each credential session, all three direct library tests passed on net472, .NET 10 and the development processor; all three driver tests passed in the desktop SDK harness and on the processor. The 142 library and 81 driver offline cases also passed twice on the processor in each API run, with no failures or skips. Temporary test instances and package archives were removed and reservations released. No installed driver update, Powerwall setting changes or processor reboot was performed. The release preparation report records package hashes and full test counts.
