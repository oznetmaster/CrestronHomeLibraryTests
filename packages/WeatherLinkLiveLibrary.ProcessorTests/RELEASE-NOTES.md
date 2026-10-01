# WeatherLinkLiveLibrary processor tests 1.1.0

This package runs WeatherLinkLiveLibrary 2.1.0 test sources with the released CrestronHomeNUnit 2.0.0 SDK and NUnit 5.0.0. It includes the client recovery regression tests and the existing opt-in live tests. The normal unit suite contains 135 cases. Live tests remain manual and require private inputs.

WeatherLink uses its own pinned NUnit 5 SDK source. Other library packages retain their existing SDK pins and source revisions. This test-only Utility package does not install a production weather driver.
