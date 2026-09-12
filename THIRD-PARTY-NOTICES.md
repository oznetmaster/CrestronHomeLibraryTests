# Processor test package third-party notices

Copyright and license terms for dependencies remain independent of this repository's MIT with Commons Clause license. Merging assemblies and renaming compatibility types does not change those terms.

- **WiserHeatAPIv2 and its tests** — Copyright © 2026 Neil Colvin, MIT. See [package notices](packages/WiserHeatAPIv2.ProcessorTests/THIRD-PARTY-NOTICES.md) and its `licenses` directory for WiserHeatAPIv2, YamlDotNet, libyaml and additional dependency licenses.
- **TeslaPowerwallLibrary and AppleTVControlLibrary** — see their package-specific `THIRD-PARTY-NOTICES.md` and `licenses` directories for library licenses and additional dependencies.
- **KasaTapoClient and its tests** — Copyright © 2026 Neil Colvin, MIT. The library package uses the exact source revision in `sources.lock.json`; the driver test package references the published KasaTapoClient 1.8.1 package. Full license: `licenses/KasaTapoClient-LICENSE.txt`.
- **NUnit 4.6.1** — Copyright (c) 2024 Charlie Poole, Rob Prouse, MIT. Uses the official NuGet framework, not a private fork. Test fixtures belong to their respective library projects; these packages do not include the NUnit framework self-test suite. NUnit3TestAdapter is development tooling, not the processor runner.
- **Crestron Home NUnit** — Copyright © 2026 Neil Colvin, MIT. The pinned host and its complete dependency notices and license texts are bundled under `Licenses/CrestronHomeNUnit` inside the `.pkg`. This includes NUnit, Bouncy Castle, Makaretu DNS, Common.Logging, IPNetwork2, SimpleBase, Hafner compatibility code and Microsoft runtime support libraries. Some host notices describe components used by its Windows runner or self-test package, which are not part of these test packages.
- **Newtonsoft.Json** — Copyright (c) 2007 James Newton-King, MIT; see `licenses/Newtonsoft.Json-LICENSE.md`.
- **Apache log4net 3.4.0** — Copyright © 2004–2026 The Apache Software Foundation, Apache-2.0; see `licenses/log4net-LICENSE.txt` and `licenses/log4net-NOTICE.txt`.
- **Crestron DeviceDrivers DevKit 27.0.24** — Crestron Electronics, Inc. SDK terms apply independently. The processor's SDK assemblies remain platform dependencies and are not merged into the test assembly.

Exact application source revisions are supplied with each release in its `.sources.json` file. Host license texts are preserved from the pinned SDK source. No private device settings, credentials or live-test results are distributed.
