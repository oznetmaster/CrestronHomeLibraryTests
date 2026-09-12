# OverkizClient Tests

A self-contained Crestron Home test package using the original `OverKizApi.Tests` project. It has **233 offline tests** and **6 opt-in local API live tests**, targeting only **net472**. No separate NUnit self-test host is required.

## Build and deploy

Open `CrestronHomeLibraryTests.sln` and build **OverkizClient.ProcessorTests** in Debug. Private `.csproj.user` settings control automatic deployment from Visual Studio. Debug builds increment the build number; release versions are assigned only in CI. The package is `bin/Debug/net472/OverkizClient.ProcessorTests.pkg`.

For a local solution view beside the original library solution, run:

```powershell
./New-LocalLibrarySolution.ps1 -Source OverkizClient -SolutionFile OverkizClient.slnx -Package OverkizClient.ProcessorTests
```

This creates an excluded `OverkizClient.Local.slnx`. The published library solution remains independent of Crestron. Command-line package builds use `./Build.ps1 -Package OverkizClient.ProcessorTests` and do not deploy.

In Configure, add **Utility → Neil Colvin → OverkizClient Tests** to a room. Its standalone tile discovers and runs Unit Tests and displays results and the current runner port. Multiple packages can coexist; mDNS advertises an automatically assigned port.

## Windows runner

Find packages, select **OverkizClient Tests**, and authenticate using the processor's credentials. Choose either **Unit Tests** or **Live Tests**. Unit tests require no accounts or devices; temporary configuration files are synthetic and cleaned up. Live tests are manual-only and are not run by the standalone tile.

For Live Tests, use **Test inputs…** to select the console's shared `%LOCALAPPDATA%/OverkizClient/LiveTestSettings.json`. The runner supplies this private file separately from the package. Selecting the Live suite passes `EnableLiveTests=true` for the current run, even if the file's `enabled` is false; the ordinary suite excludes category `Live`. The library reads inputs from the supplied `TestDataDirectory`.

The six live checks authenticate with the saved local token, read gateways, setup, devices and states, and register/fetch/unregister their own event listener. They do not generate/revoke tokens or operate devices. The gateway must be reachable from the processor. No devices means the device-specific test is skipped. All six live checks passed on the validation processor on 2026-09-12; live results depend on the configured gateway and local network.

## Sources and release status

Version **1.0.1** uses the released **OverkizClient v1.2.0** source commit `1adfd371003a0c0b85330cf0a14ed63c117e807b` and the CrestronHomeNUnit **v1.0.1** SDK at `d93527c2d5c3a39a59dc9ce897005c9e5eb06892`. `sources.lock.json` and the release provenance asset record the exact build inputs. Library and processor-package versions are independent.

Download the `.pkg` from [OverkizClient Tests v1.0.1](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases/tag/OverkizClient.ProcessorTests-v1.0.1). The release manifest version is **1.0.001.0000**; local Debug builds use increasing build numbers. Package releases use independent tags `OverkizClient.ProcessorTests-v<version>` and are not published to NuGet. The library itself is available separately as OverkizClient 1.2.0 on NuGet.

Deployment credentials, real live settings and machine paths are private and excluded through `.git/info/exclude`. They are not included in packages or release assets. See the collection README for Crestron trademark/non-association notices and [third-party notices](THIRD-PARTY-NOTICES.md) for retained dependency licenses.

## Local validation

The actual package was extracted and all 233 offline tests passed twice in one process. Packaged discovery found all 239 cases, with Live remaining manual-only. Release validation repeats the offline execution check against the shipped assembly. The shared merger now isolates private `System.SR` helpers per dependency so JSON error paths use the correct resource strings; this fixed 16 packaging-only failures. Processor execution is now validated for both the offline and live suites.

Processor validation identified 27 failures caused by ILRepack combining unrelated anonymous types from different assemblies. The shared merger now isolates these types per input assembly and verifies their property names after merging. Local package version `1.0.000.0004` passed all 233 offline tests twice after this correction; processor package `1.0.000.0005` subsequently passed all 233 offline tests, with zero failures or skips, on 2026-09-12. All six manual live checks also passed on the processor using package `1.0.000.0005` on 2026-09-12, with zero failures or skips.
