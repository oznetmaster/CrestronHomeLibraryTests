# Crestron Home library tests

One Visual Studio solution for processor test packages for platform-independent libraries. Each library owns its original NUnit fixtures. This repository owns only Crestron package projects, suite manifests and package-specific UI. The runner, host and packaging tools remain in CrestronHomeNUnit. Crestron driver repositories can keep their own processor test projects in their driver solutions.

## Local Visual Studio setup

With the existing KasaClient and CrestronHomeNUnit checkouts beside this repository, run in PowerShell 7:

```powershell
./Initialize-Sources.ps1 -UseLocalSources
```

Use `-LocalProjectsRoot` if those checkouts are elsewhere. Setup creates Windows directory junctions under `sources`; these are links to the original repositories, not fixture copies. Setup never replaces an existing source directory. Each repository retains its own Git history and working changes. Source links and fetched source trees are excluded from the collection's Git contents.

Open **CrestronHomeLibraryTests.sln**. The solution includes the Kasa library, its NUnit test project, the Windows runner and the Kasa processor package. Editing a linked project edits its original checkout. Test Explorer runs the normal desktop tests. The Kasa library's own solution has no processor package reference.

Build **KasaClient.ProcessorTests** to make the self-contained processor package. Build **CrestronHomeNUnit.Runner** to update the Windows application. Set the runner as the startup project to launch it with F5. There is no separate host package to deploy for Kasa.

The package is at `packages/KasaClient.ProcessorTests/bin/Debug/net472/KasaClient.ProcessorTests.pkg`. Existing package identity and version numbering are preserved. Debug package builds increment the build number. Release version increments remain limited to CI. SFTP deployment still uses the package's local `.csproj.user`, and runs only for Debug builds inside Visual Studio when enabled there. Local settings and credentials belong in `.git/info/exclude`; setup installs those exclusions, with no private-settings entries in tracked `.gitignore`.

Required build tools are Visual Studio with .NET desktop development and .NET Framework 4.7.2 targeting support, .NET SDK as specified in global.json, PowerShell 7, Crestron Driver SDK, and dotnet-ilrepack 2.0.45. Use the shared host's packaging instructions for SDK installation and path overrides.

For a command-line package build without deployment:

```powershell
./Build.ps1
```

## Private library solution view

Run `./New-LocalLibrarySolution.ps1` to create `KasaClient.Local.slnx` beside the original Kasa solution. It contains the existing Kasa projects plus the external processor package. The file is excluded in that library repository using `.git/info/exclude` before it is written; the tracked solution remains untouched. Open the local view and build KasaClient.ProcessorTests to build and deploy with the same local settings as the collection solution. Regenerate with `-Force` after changing the original solution. Parameters support other source names, .slnx solution filenames and package names.

## Public and reproducible source builds

`sources.lock.json` records the public URL and exact source commit for each dependency. A fresh release checkout uses real clones at those commits in the same `sources` locations; the solution and project paths do not change. No tests are copied into this repository or published as a separate test-only NuGet package.

The lock file pins the published NUnit test sources and Crestron Home NUnit SDK. To update a package, commit and push its library tests first, then record the clean source revisions:

```powershell
./Update-SourceLock.ps1 -Name KasaClient
./Update-SourceLock.ps1 -Name CrestronHomeNUnit -Repository https://github.com/oznetmaster/CrestronHomeNUnit.git
```

Commit the lock file in this repository. From a fresh checkout, run:

```powershell
./Initialize-Sources.ps1
./Build.ps1 -Configuration Release -LockedSources
```

Locked setup refuses missing pins, local junctions, changed source revisions and dirty checkouts. It leaves existing sources untouched on mismatch. Use a separate checkout for releases rather than changing the links used by an open Visual Studio solution. CI should use this same locked build on a Windows machine with the required Crestron SDK and tooling. Build.ps1 writes a `.sources.json` beside the package identifying the input revisions and whether local changes were present. Release the `.pkg` and source record from this collection repository. Each package retains its own manifest version. Processor packages are GitHub release assets, not NuGet packages; the processor and test projects remain non-packable.

## Adding a library

1. Add an entry to `sources.lock.json` with its local checkout directory name, public repository URL, required test project and, when ready, source commit.
2. Run local source setup, then use `sources/CrestronHomeNUnit/New-ProcessorTestProject.ps1` with the test project under `sources`, an output directory under `packages`, and `-Solution ./CrestronHomeLibraryTests.sln`.
3. Add the original library and test projects under the solution's Libraries folder using Visual Studio's **Add Existing Project**, or `dotnet sln add --solution-folder Libraries`. Keep their paths under `sources`.
4. Configure suite filters and test counts in the new package's ProcessorTests.json. Build and validate the package before recording its source revisions for release.

The tests may use ordinary NUnit categories and parameters such as `TestDataDirectory` and `EnableLiveTests`. Their source code, messages and documentation stay independent of Crestron. Device settings are supplied through the Windows runner's **Test inputs**. Live tests run only when explicitly selected in that runner; the supplied parameter overrides the JSON enable flag for that operation without changing the input file.


Prefer stable device IDs or unique discovery aliases in private Kasa live settings; the fixtures resolve current addresses at execution time. Never publish real configuration or live-test output. The runner's **Use at next restart** option saves the current package, suite and test selection outside the repositories and restores it without running tests. Credentials stay in the existing protected store.

The Kasa package includes 97 unit tests and seven live test placeholders. Live discovery is shared within each run and starts fresh for the next run. Progress reports discovery, connection, action and restoration timings. Private settings can use "observationDelayMilliseconds": 0 to omit observation pauses. Configure the hub's temperatureChildDeviceId for the read-only T310/T315 temperature test; its Unattended category allows selecting it separately from tests that operate devices.

Processor test packages declare the supported Utility device type so they can be found under that category in Crestron Home Setup. New packages generated by the shared SDK use the same category.


## Download and run

Download a `.pkg` from [GitHub Releases](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases) and the Windows runner from [Crestron Home NUnit](https://github.com/oznetmaster/CrestronHomeNUnit/releases). Each package contains its own NUnit host; installing the separate NUnit self-test package is optional.

All processor test packages appear in **Utility → Neil Colvin → package name** in Crestron Home Configure. The first package is **KasaTapoClient Tests**. Add it to a room, then use **Find packages** in the Windows runner and select it. The standalone Home tile runs the automatic unit suite and reports results and the assigned port. Live suites are available only through explicit selection in the Windows runner. See the [KasaTapoClient package guide](packages/KasaClient.ProcessorTests/README.md) for private inputs and live-device setup.

## GitHub releases

Run the **Release processor tests** workflow on `main`, choosing the package and its independent version, such as `1.0.0`. Tags use `KasaClient.ProcessorTests-v1.0.0`; future packages use their own project name and version. CI prepares the package version, builds from the locked sources, validates discovery and deterministic desktop tests, and publishes the `.pkg`, source revision record, documentation and SHA-256 checksums. No NuGet publishing occurs. Live hardware tests never run in CI. Processor execution remains a separate validation step on real hardware.

The library's NuGet version is independent of the processor test package version. Updating fixtures does not require publishing the library again. Keep each package's release notes in its project folder. Before publishing a new package, add its supported project name to the workflow choices and provide its desktop validation command in `Validate-Tests.ps1`.

## License and non-association

Copyright © 2026 Neil Colvin. Collection code is licensed under MIT with Commons Clause; see [LICENSE](LICENSE). Referenced libraries, NUnit and the test host retain their own licenses; see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

Crestron, Crestron Home and related marks are trademarks of Crestron Electronics, Inc. This is an independent, unofficial project built against publicly available Crestron Home Entity V2 SDK components. It is not affiliated with, endorsed by, or sponsored by Crestron Electronics, Inc. Crestron's SDK license governs its SDK libraries independently of this repository's license.

TP-Link, Kasa and Tapo are trademarks of their respective owners. This project is not affiliated with, endorsed by, or sponsored by TP-Link. NUnit is an independent project and does not endorse these processor packages.
