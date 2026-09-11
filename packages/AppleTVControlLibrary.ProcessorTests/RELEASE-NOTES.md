# AppleTVControlLibrary Tests v1.0.0

Initial processor package with 229 NUnit unit tests and a separate optional suite of five simulated-device socket discovery tests. Includes a standalone Crestron Home tile in the Utility category and Windows runner support through automatic mDNS discovery.

Validation: all 229 unit tests and all 5 optional socket discovery tests passed on the development Crestron Home processor. The same fixtures also pass on Windows net472 and .NET 10, and the merged unit suite passed twice in one process. Release automation independently rebuilds and validates the package from pinned sources.

This release packages tests only. Apple TV library versions and NuGet packages are unchanged. Credentials and local deployment settings are not included.
