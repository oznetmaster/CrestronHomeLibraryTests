# Easee client processor validation

This independent test package lives in the existing library test collection. It references the original net472 internal and live test projects through `sources/EaseeChargerClient`. Windows DPAPI, console and WPF tests remain desktop suites. No production Easee driver is included.

The package imports the isolated `sources/EaseeProcessorSdk` snapshot of CrestronHomeNUnit at published 3.0.0 (`d268167a15df665acfb4506a53d238cea833a42f`). It restores `Crestron.DeviceDrivers.ManifestUtil` 29.0.10 through NuGet, using its generated package path; it does not depend on an installed ManifestUtil executable. Build with `dotnet build EaseeChargerClient.ProcessorTests.csproj -c Debug -p:BuildProcessorTestPackages=true -p:DeployAfterBuild=false`.

`ProcessorTests.json` has an automatic internal suite and a manual suite containing exactly the six required read-only live tests. The host's Explicit-fixture guardrail is preserved. The separately gated single-start control fixture is not included in either processor suite.

Use the established ProcessorAdmission helper from CrestronHomeHardwareCI and the pinned workflow engine. `Invoke-ProcessorTests.ps1` accepts their built paths and a private pool catalog; entries name protected templates under `CommonApplicationData/CrestronHomeHardwareCI/templates`. The catalog can include both shared processors. It checks availability and delegates atomic reservation, execution, temporary-instance cleanup and release to the existing workflow. A pre-existing or retained lease is never stolen. No reboot or production-driver update is requested.

For live execution, run the script as a blocking child of the Easee console's `with-live-profile --profile NAME -- pwsh -File ... -Live` command. Supply `-AdmissionDll`, `-WorkflowBin` and `-PoolCatalog` paths. That wrapper owns the encrypted profile until the workflow exits and provides only short-lived access-token inputs. Do not copy refresh tokens, passwords or decrypted profiles into test inputs. Processor credentials are read from the existing protected store and written only into this user's private LocalApplicationData for the lifetime of the child command; those settings are deleted afterwards.

Results are retained in the collection's ignored `artifacts/EaseeChargerClient` directory. A failure is not evidence of a clean processor: inspect the workflow, stop confirmation, instance cleanup and lease receipt before a retry. Pre-existing package archive paths remain protected by the shared workflow.

The companion `EaseeChargerClient.ProcessorLiveTests` project exposes the six required read-only checks by forwarding to the original live fixture, including its setup, teardown and assertions. Optional desktop role scenarios and charging control are excluded. Its discovered inventory is checked against the packaged manual suite. CI uses adapter 3.0.0 and either available shared processor, with an atomic workflow lease.
