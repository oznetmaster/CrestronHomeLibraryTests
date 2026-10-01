# AppleTVControlLibrary Tests

## NUnit 5 test package

Test package **1.1.0** uses **NUnit 5.0.0**. It is independent of the product version. [Download package](https://github.com/oznetmaster/AppleTVControlLibrary/releases/download/v2.2.6/AppleTVControlLibrary.ProcessorTests-1.1.0.pkg), [documentation](https://github.com/oznetmaster/AppleTVControlLibrary/releases/download/v2.2.6/AppleTVControlLibrary.ProcessorTests-1.1.0-Documentation.zip), [validation](https://github.com/oznetmaster/AppleTVControlLibrary/releases/download/v2.2.6/AppleTVControlLibrary.ProcessorTests-1.1.0.validation.json), [exact source revisions](https://github.com/oznetmaster/AppleTVControlLibrary/releases/download/v2.2.6/AppleTVControlLibrary.ProcessorTests-1.1.0.sources.json), and [SHA-256 checksums](https://github.com/oznetmaster/AppleTVControlLibrary/releases/download/v2.2.6/AppleTVControlLibrary.ProcessorTests-1.1.0-SHA256SUMS.txt) are attached to the existing product release. No product binary or NuGet version changed for this test update.

Validated on 1 October 2026: 237 offline cases passed in each of two runs from the packaged assembly on Windows. All suite identities were checked against source discovery. Live/manual tests and execution on the processor were not repeated during this migration; earlier hardware results do not certify this new package.

A self-contained NUnit package for Crestron Home using the original Apple TV library fixtures. It has **237 unit tests** and **5 optional socket discovery tests**. No real Apple TV, pairing credentials or device configuration is required.

## Suites

| Suite | Tests | Behavior |
| --- | ---: | --- |
| Unit Tests | 237 | Companion protocol and sample storage (109), shared HAP pairing/crypto (56), and MRP protocol (72). Uses synthetic data and simulated devices. |
| Socket Discovery | 5 | Explicitly selected in the Windows runner. Exercises multicast/unicast discovery, timeouts and cancellation with a simulated mDNS responder. Uses real network sockets but does not pair with or control an Apple TV. |

Socket Discovery depends on multicast support and permission to share UDP port 5353. Run one instance at a time on a given host. It is excluded from the default unit run and the Home tile's Run Tests command.

## Build and run

Open `CrestronHomeLibraryTests.sln` and build **AppleTVControlLibrary.ProcessorTests** in Debug. The package targets only **net472**. Debug builds increment the build number and deploy when enabled through the private `.csproj.user`. The excluded `AppleTVControlLibrary.Local.slnx` can provide the same build/deploy project alongside the library projects in Visual Studio.

Output: `bin/Debug/net472/AppleTVControlLibrary.ProcessorTests.pkg`. Add **Utility → Neil Colvin → AppleTVControlLibrary Tests** in Crestron Home Configure. The standalone tile runs all 237 unit tests, reports their result, and displays the connection port. Each package includes its own host; the separate NUnit self-test package is optional.

In the Windows runner, use **Find packages**, select this package and choose a suite. The port is assigned automatically and advertised through mDNS. Select **Socket Discovery** explicitly to run its five cases. Neither suite needs Test inputs. Processor SFTP credentials and local deployment paths stay in excluded local settings.

## Sources and releases

The fixtures remain in [AppleTVControlLibrary](https://github.com/oznetmaster/AppleTVControlLibrary) and also run through NUnit3TestAdapter on net472 and .NET 10. This project references all four original test projects; it does not copy fixtures or change the library's public solution.

`sources.lock.json` pins the library and shared host commits. Select this package in **Release processor tests** for an independent `AppleTVControlLibrary.ProcessorTests-v<version>` release. No library version or NuGet package is changed. CI runs the 237 unit tests on both desktop frameworks and validates all 242 cases in the merged assembly; processor execution remains a separate validation step.

See [third-party notices](THIRD-PARTY-NOTICES.md) and the collection README for licenses, installation instructions, and Crestron/Apple non-association notices.
