# KasaTapoClient Tests

Initial public processor test package, version 1.0.0. This is a test-package release; no library or production driver NuGet package is published.

- 97 deterministic NUnit unit tests, plus seven opt-in live test placeholders. Device-specific configuration can expand the live cases.
- Live tests support stable device selectors, discovery shared per run, state restoration and read-only T310/T315 hub temperature checks.

Install `KasaClient.ProcessorTests.pkg`, then add **Utility → Neil Colvin → KasaTapoClient Tests** in Crestron Home Configure. All processor test packages use the Utility category. The standalone Home tile runs automatic suites; the [Windows runner](https://github.com/oznetmaster/CrestronHomeNUnit/releases/tag/v1.0.0) provides discovery, selection and detailed results. Each package includes its own host; the NUnit self-test package is optional.

The `.sources.json` asset records the exact source revisions. The documentation ZIP includes license notices; SHA256SUMS.txt covers every other asset. Private settings, deployment credentials and live results are excluded. NUnit 4.6.1 is the official NuGet framework, not a private fork.

CI validates desktop tests and discovery from the packaged assembly. Processor runs are a separate hardware validation; the unit and configured live suites have passed during local processor testing. Live tests are never executed in CI.
