# WeatherLinkLiveLibrary Tests v1.0.0

Initial Crestron Home processor test package, released 12 September 2026.

- Shared WeatherLinkLiveLibrary v1.0.3 NUnit fixtures, packaged for net472 with the official NUnit framework.
- Separate suites for 127 offline tests and three opt-in, read-only live device tests.
- Utility category, standalone unit-test tile, automatic TCP port and mDNS discovery.
- IP-only live JSON settings supplied privately through the Windows runner.
- Visual Studio Debug build/deploy support and an excluded local library solution view.
- Dependency notices, licenses, source revision record and SHA-256 checksums included.

All **127 unit tests and 3 live tests passed on a Crestron Home processor**. The merged package also passed all automatic tests twice on Windows, and desktop fixtures passed on both net472 and net10.0.

Install **Utility → Neil Colvin → WeatherLinkLiveLibrary Tests** in Configure. The tile runs unit tests. For live tests, select the package's Live Tests suite in the Windows runner and supply private `LiveTestSettings.json` through **Test inputs…**. Only the WeatherLink device IP address is required; the processor must be able to reach its local HTTP endpoint.

Download the `.pkg` for installation and the documentation archive for setup instructions and example settings. Distribution is through GitHub releases only; this processor package is not published to NuGet. Private IP settings and deployment credentials are excluded from release assets.
