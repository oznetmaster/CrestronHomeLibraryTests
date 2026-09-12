# OverkizClient Tests v1.0.1

Updates the processor test package to the released **OverkizClient v1.2.0** source, targeting **net472** and using official NUnit **4.6.1**.

## Included suites

- **Unit Tests:** 233 offline tests covering the API, response models, error handling and test configuration. These require no gateway or credentials and can also run from the standalone Home tile.
- **Live Tests:** six separately selected local API checks using an existing gateway token. They authenticate, read gateways/setup/devices/states and register, fetch and unregister their own event listener. They do not generate or revoke tokens or operate devices.

## Install and use

Upload **OverkizClient.ProcessorTests.pkg** to the processor's `/user/ThirdPartyDrivers/Import` folder and add **Utility → Neil Colvin → OverkizClient Tests** in Configure. Release manifest version: **1.0.001.0000**.

The package is self-contained; no separate NUnit Test Host is needed. Its standalone tile exposes offline testing and the current TCP port. The Windows runner discovers the package through mDNS and provides separate Unit and Live suites. Use the current runner, **v1.0.1**, for automatic reconnection after endpoint changes.

For live checks, select the Live suite and use **Test inputs…** to supply the console's shared `%LOCALAPPDATA%/OverkizClient/LiveTestSettings.json`. Selecting that suite enables live tests for the current run even if the private JSON has `enabled: false`. The documentation archive contains only a placeholder example; real gateway credentials and deployment settings are excluded from source and release assets.

## Sources and validation

- OverkizClient **v1.2.0** source: `1adfd371003a0c0b85330cf0a14ed63c117e807b`, containing the response models and live tests. Compared with processor package v1.0.0, the library version metadata and pinned revision are updated; fixture behavior is unchanged.
- Shared processor SDK: CrestronHomeNUnit v1.0.1, `d93527c2d5c3a39a59dc9ce897005c9e5eb06892`. Includes private resource-helper and anonymous-type merge corrections.
- 233 offline tests passed on both desktop target frameworks. The packaged assembly passed all 233 offline tests twice locally.
- On 2026-09-12, development processor package 1.0.000.0005 passed **233 offline tests and all six live checks**, with zero failures or skips. Live checks depend on the configured gateway and local network.
- Release CI validates pinned sources, desktop tests, all 239 discovered cases and repeated execution of the 233 packaged automatic tests. CI does not run live gateway tests.

Assets include the installable `.pkg`, documentation/licenses, exact source provenance and SHA-256 checksums. The processor package is released only on GitHub. OverkizClient v1.2.0 is released separately on GitHub and NuGet; this workflow does not publish another NuGet package.
