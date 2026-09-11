# TeslaPowerwallLibrary Tests

A self-contained NUnit test package for Crestron Home, built from the original library test project. It contains **99 deterministic tests**: facade guards and mode selection, token-cache persistence, JSON models, calendar-history parsing, validation helpers and enum/version contracts. It never operates a Powerwall and requires no Tesla account or live-device settings.

## Build and run

Open `CrestronHomeLibraryTests.sln` and build **TeslaPowerwallLibrary.ProcessorTests** in Debug. The processor project targets only **net472**. Debug builds increment its build number and deploy when enabled through its private `.csproj.user`. The library's own solution remains independent; `New-LocalLibrarySolution.ps1` can create an excluded local solution view containing this package.

The output is `bin/Debug/net472/TeslaPowerwallLibrary.ProcessorTests.pkg`. In Crestron Home Configure, add **Utility → Neil Colvin → TeslaPowerwallLibrary Tests** to a room. The standalone Home tile runs the unit suite and shows its result. In the Windows runner, choose **Find packages**, select the package, then discover or run its tests. Its TCP port is assigned automatically. The separate NUnit self-test host is not required.

Temporary token-cache files use NUnit's work directory and are deleted by the fixtures. The missing-token test has its own empty cache so it cannot use a developer's saved tokens. Test values are synthetic. Tests are rediscovered for each operation and can be run repeatedly.

## Source and releases

The fixtures stay in [TeslaPowerwallLibrary](https://github.com/oznetmaster/TeslaPowerwallLibrary); NUnit3TestAdapter runs the same 99 cases on net472 and .NET 10 in Visual Studio and CI. `sources.lock.json` pins the exact library and shared host SDK commits. This project's public releases use `TeslaPowerwallLibrary.ProcessorTests-v<version>` and never publish or change the library's NuGet package.

Use the collection's **Release processor tests** workflow and select this package. CI validates both desktop targets and packaged discovery. Processor execution is a separate hardware validation step. Private deployment credentials and machine paths belong in `.git/info/exclude` and are never release assets.

See [third-party notices](THIRD-PARTY-NOTICES.md) for dependencies and the collection README for common installation instructions and Crestron trademark/non-association notices. Tesla and Powerwall are trademarks of Tesla, Inc.; this is an independent, unofficial test package and is not affiliated with or endorsed by Tesla.
