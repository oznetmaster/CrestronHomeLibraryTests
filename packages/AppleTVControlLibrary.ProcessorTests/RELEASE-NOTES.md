# AppleTVControlLibrary Tests v1.0.0

Initial processor package with 229 NUnit unit tests and a separate optional suite of five simulated-device socket discovery tests. Includes a standalone Crestron Home tile in the Utility category and Windows runner support through automatic mDNS discovery.

The same fixtures pass on Windows net472 and .NET 10. Release automation validates the merged package independently. Processor runtime testing is a separate validation step; desktop results do not assert Mono compatibility.

This release packages tests only. Apple TV library versions and NuGet packages are unchanged. Credentials and local deployment settings are not included.
