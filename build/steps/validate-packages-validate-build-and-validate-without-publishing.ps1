$directory = Join-Path $env:GITHUB_WORKSPACE "packages/$env:TEST_PACKAGE"
[xml]$project = Get-Content "$directory/$env:TEST_PACKAGE.csproj" -Raw
$versions = @($project.Project.PropertyGroup.Version | Where-Object { $_ })
if ($versions.Count -ne 1 -or $versions[0] -notmatch '^\d+\.\d+\.\d+$') { throw 'A single three-part package version is required.' }
$version = [string]$versions[0]
$sdk = Join-Path $env:GITHUB_WORKSPACE 'sources/CrestronHomeNUnit'
& "$sdk/CrestronHomeNUnit.Driver/BumpDriverVersion.ps1" -ManifestPath "$directory/$env:TEST_PACKAGE.json" -Configuration Release -ReleaseVersion $version
# Establish only the expected version normalization as the local validation baseline.
# Nothing in this job pushes commits, creates tags, publishes packages or contacts hardware.
git add -- "packages/$env:TEST_PACKAGE/$env:TEST_PACKAGE.json"
if ($LASTEXITCODE -ne 0) { throw 'Could not prepare the validation baseline.' }
./Build-TestRelease.ps1 -Version $version -Package $env:TEST_PACKAGE -SdkRoot $sdk -ManifestUtilExe $env:MANIFEST_UTIL_EXE
