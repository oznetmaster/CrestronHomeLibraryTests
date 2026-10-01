# Test package 1.1.0 - NUnit 5

Independent test-tooling update to NUnit 5.0.0 and CrestronHomeNUnit SDK 2.2.0. Async assertions are awaited and discarded tasks fail compilation. Production library versions and APIs are unchanged. New versioned test artifacts are published with the existing product release; original assets remain available.

# TeslaPowerwallLibrary Tests v1.0.1

Refresh the processor package to TeslaPowerwallLibrary 1.2.5. The suite now contains 118 deterministic NUnit tests, including Fleet token refresh and automatic region discovery. These tests use controlled responses and require no Tesla account or live credentials.

Add **Utility → Neil Colvin → TeslaPowerwallLibrary Tests** in Crestron Home Configure. Run its standalone tile, use the Windows runner, or configure the collection's new Test Explorer workflow project. The workflow can build, install, run and remove the temporary test instance.

Validation covers the same 118 tests on Windows net472 and .NET 10, packaged discovery and repeated packaged execution. Hardware results are recorded separately against the exact tested package.

The release contains the test `.pkg`, pinned source revisions, documentation and SHA-256 checksums. No library or NuGet release accompanies this test-package release. The processor project targets net472 only.