# Crestron Home library tests

Processor test packages for platform-independent .NET libraries, in one Visual Studio solution. Each library keeps its NUnit fixtures in its own repository. This repository contains only the Crestron Home package projects, suite definitions and package UI. Crestron-specific drivers can keep processor test projects in their own driver repositories.

The shared host, Windows runner and packaging SDK come from [Crestron Home NUnit](https://github.com/oznetmaster/CrestronHomeNUnit). All processor test projects target **net472** and use the official NUnit framework.

## Contents

- [Available packages](#available-packages)
- [Install and run](#install-and-run)
- [Build with Visual Studio](#build-with-visual-studio)
- [Private settings and library solution views](#private-settings-and-library-solution-views)
- [Reproducible builds and releases](#reproducible-builds-and-releases)
- [Add another package](#add-another-package)
- [License and non-association](#license-and-non-association)

## Available packages

| Package in Configure | Project | Suites and configuration |
| --- | --- | --- |
| **AppleTVControlLibrary Tests** | `AppleTVControlLibrary.ProcessorTests` | [Package guide](packages/AppleTVControlLibrary.ProcessorTests/README.md): 229 unit tests and 5 optional socket discovery tests |
| **OverkizClient Tests** | `OverkizClient.ProcessorTests` | [Package guide](packages/OverkizClient.ProcessorTests/README.md): 233 offline tests and 6 opt-in local API tests; [v1.0.0 release](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases/tag/OverkizClient.ProcessorTests-v1.0.0) |
| **TeslaPowerwallLibrary Tests** | `TeslaPowerwallLibrary.ProcessorTests` | [Package guide](packages/TeslaPowerwallLibrary.ProcessorTests/README.md): 99 deterministic unit tests |
| **KasaTapoClient Tests** | `KasaClient.ProcessorTests` | [Package guide](packages/KasaClient.ProcessorTests/README.md): unit tests and optional live-device tests |

Each package has its own guide, release notes, manifest identity and version. Add new packages to this table; their test counts, device requirements and settings belong in their package guides.

## Install and run

Download the chosen `.pkg` from [GitHub Releases](https://github.com/oznetmaster/CrestronHomeLibraryTests/releases) and the [Windows runner](https://github.com/oznetmaster/CrestronHomeNUnit/releases). Every package includes its own NUnit host; the separate NUnit framework self-test package is optional.

All processor test packages appear in **Utility → Neil Colvin → package name** in **Crestron Home Configure**. Add the package to a room. Multiple packages can coexist; each advertises its automatically assigned TCP port through mDNS.

In the Windows runner, use **Find packages**, select a package, authenticate with that processor's credentials, and choose a suite. You can discover tests, run all tests in the selected suite, or run a selection. The package's standalone Home tile exposes its automatic suites and reports results and its current port. Suites marked manual-only, including live-device tests, require explicit selection in the Windows runner.

Use **Test inputs…** to supply a suite's private configuration. The package guide identifies required filenames and supported NUnit parameters. The runner transfers inputs separately from the package; they are never compiled into release assets. **Use at next restart** restores selections without running tests. See the [host user guide](https://github.com/oznetmaster/CrestronHomeNUnit/blob/main/docs/UserGuide.md) for complete runner and tile behavior.

## Build with Visual Studio

Install Visual Studio with .NET desktop development and .NET Framework 4.7.2 targeting support, the SDK listed in `global.json`, PowerShell 7, the Crestron Driver SDK and dotnet-ilrepack 2.0.45. Follow the shared host's build instructions for SDK paths.

For local development, keep the source checkouts named in `sources.lock.json` and the `CrestronHomeNUnit` checkout beside this repository, then run:

```powershell
./Initialize-Sources.ps1 -UseLocalSources
```

Use `-LocalProjectsRoot` when they are elsewhere. Setup creates Windows directory junctions under `sources`, pointing to the original repositories. It never replaces existing source directories. Editing a linked project edits its original checkout; each repository retains its own Git history. Source checkouts and links are excluded from this repository.

Open **CrestronHomeLibraryTests.sln**. Build the desired processor test project in Debug, such as **KasaClient.ProcessorTests**. Its package is written to `packages/<project>/bin/Debug/net472/<project>.pkg`. Build **CrestronHomeNUnit.Runner** to update the Windows application, and select it as the startup project to launch it with F5. Test Explorer runs the libraries' ordinary desktop NUnit tests.

Debug package builds increment the build number and can automatically deploy through SFTP when enabled in that project's private settings. Release version increments occur only in CI. Command-line builds do not deploy:

```powershell
./Build.ps1 -Package KasaClient.ProcessorTests
```

## Private settings and library solution views

Deployment credentials, machine paths, `.csproj.user`, `*.Local.targets`, runner settings and real live-test configuration belong in local `.git/info/exclude`, not the tracked `.gitignore`. Source setup installs the standard local exclusions. Publish only placeholder samples. Never include private configuration or live-test output in commits or releases.

The original library solutions remain independent of Crestron. For an optional local solution that also builds a processor package, use the helper with the source name, original solution and package:

```powershell
./New-LocalLibrarySolution.ps1 -Source KasaClient -SolutionFile KasaClient.slnx -Package KasaClient.ProcessorTests
```

This example creates `KasaClient.Local.slnx` beside the library's original solution and excludes it before writing it. It includes the library projects and external processor test project. Regenerate with `-Force` after changing the original solution. Build the test package there using the same private deployment settings as the collection solution.

## Reproducible builds and releases

`sources.lock.json` records exact public repository URLs and commit IDs for the libraries and host SDK. Commit and push test changes in the original library first, then update the clean source pins in this repository:

```powershell
./Update-SourceLock.ps1 -Name KasaClient
./Update-SourceLock.ps1 -Name CrestronHomeNUnit
```

From a fresh checkout, fetch pinned sources and build a Release package:

```powershell
./Initialize-Sources.ps1
./Build.ps1 -Package KasaClient.ProcessorTests -Configuration Release -LockedSources
```

Locked builds require real source checkouts and reject local junctions, wrong commits or dirty sources. Use a separate checkout for releases; existing Visual Studio links are left untouched. Builds write a `.sources.json` beside the package describing their source revisions.

For publication, run **Release processor tests** on `main`, select a supported package and enter its independent version, such as `1.0.0`. Tags follow `<project>-v<version>`, for example `KasaClient.ProcessorTests-v1.0.0`. CI prepares that package's version, validates desktop tests and packaged discovery, and publishes its `.pkg`, source record, documentation and SHA-256 checksums. Live tests never execute in CI. Processor runtime validation is a separate hardware step.

Test packages are **GitHub release assets, not NuGet packages**. Their versions are independent of the libraries' NuGet versions. Updating tests does not require publishing a library again.

## Add another package

1. Keep or convert its shared fixtures to NUnit in the original library repository, with ordinary desktop validation. Commit and publish those changes there.
2. Add the library to `sources.lock.json`, including its checkout name, public URL, required test project and exact commit. Run source setup.
3. Use `sources/CrestronHomeNUnit/New-ProcessorTestProject.ps1` with the original test project under `sources`, an output directory under `packages`, and `-Solution ./CrestronHomeLibraryTests.sln`. Give the package a distinct identity and keep its **Utility** device type.
4. Add the library and test projects to the solution's Libraries folder, using their paths under `sources`. Configure suite filters, expected counts and manual-only suites in the package's `ProcessorTests.json`.
5. Write the package's `README.md`, `RELEASE-NOTES.md`, placeholder inputs and dependency notices. Add it to the available-packages table above. Keep all fixture source, messages and documentation in the library repository independent of Crestron.
6. Add the package to the release workflow choices and add an entry to `release-packages.json` with its desktop test projects/frameworks, expected discovery count and documentation assets. Each new package must have explicit release validation; adding a project alone does not enable its publication.
7. Build and run the package on a processor before its first release. Record updated source pins and release only that package, under its own version.

## License and non-association

Copyright © 2026 Neil Colvin. Collection code is licensed under MIT with Commons Clause; see [LICENSE](LICENSE). Referenced libraries, NUnit and the test host retain their own licenses; see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

Crestron, Crestron Home and related marks are trademarks of Crestron Electronics, Inc. This is an independent, unofficial project built against publicly available Crestron Home Entity V2 SDK components. It is not affiliated with, endorsed by, or sponsored by Crestron Electronics, Inc. Crestron's SDK license governs its SDK libraries independently of this repository's license.

TP-Link, Kasa and Tapo are trademarks of their respective owners. This project is not affiliated with, endorsed by, or sponsored by TP-Link. NUnit is an independent project and does not endorse these processor packages.
