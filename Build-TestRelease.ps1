# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [Parameter(Mandatory)][string] $Version,
    [Parameter(Mandatory)][string] $SdkRoot,
    [Parameter(Mandatory)][string] $ManifestUtilExe,
    [string] $Package = 'KasaClient.ProcessorTests'
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = $PSScriptRoot
$config = & "$root/Get-ReleasePackage.ps1" -Package $Package
$projectDirectory = Join-Path $root "packages/$Package"
& "$root/Build.ps1" -Configuration Release -Package $Package -LockedSources -ReleaseVersion $Version -ManifestUtilExe $ManifestUtilExe
& "$root/Validate-Tests.ps1" -Package $Package
$output = Join-Path $projectDirectory 'bin/Release/net472'
$release = Join-Path $root 'artifacts/release'
if (Test-Path -LiteralPath $release) { throw 'Use a fresh release staging directory.' }
[IO.Directory]::CreateDirectory($release) | Out-Null
$pkg = Join-Path $output "$Package.pkg"
# Inspect the actual shipped assembly, not just pre-package build output.
$extracted = Join-Path $root ('artifacts/verify-' + [Guid]::NewGuid().ToString('N'))
[IO.Compression.ZipFile]::ExtractToDirectory($pkg, $extracted)
& "$SdkRoot/ProcessorTestPackage.Validation/bin/Release/net472/ProcessorTestPackage.Validation.exe" "$extracted/$Package.dll" "$root/artifacts/validation" $config.expectedCount
if ($LASTEXITCODE -ne 0) { throw 'Packaged test discovery failed.' }
# Some packages exercise dependency behavior that can change during assembly merging.
# Run only automatic suites; PackageTestHost explicitly excludes manual/live suites.
if ($config.ContainsKey('expectedAutomaticCount')) {
    & "$SdkRoot/ProcessorTestPackage.Validation/bin/Release/net472/ProcessorTestPackage.Validation.exe" "$extracted/$Package.dll" "$root/artifacts/execution-validation" $config.expectedAutomaticCount --run-twice
    if ($LASTEXITCODE -ne 0) { throw 'Packaged automatic-suite execution failed.' }
}
$manifest = Get-Content "$projectDirectory/$Package.json" -Raw | ConvertFrom-Json
if ($manifest.GeneralInformation.DeviceType -ne 'Utility') { throw 'Processor test packages must use the Utility category.' }
$revision = git -C $root rev-parse HEAD
if ($LASTEXITCODE -ne 0) { throw 'Cannot record package revision.' }
$sdkRevision = git -C $SdkRoot rev-parse HEAD
if ($LASTEXITCODE -ne 0) { throw 'Cannot record SDK revision.' }
$record = Get-Content "$output/$Package.sources.json" -Raw | ConvertFrom-Json
$record | Add-Member packageRevision $revision
$record | Add-Member version $Version
[IO.File]::WriteAllText("$release/$Package.sources.json", ($record | ConvertTo-Json -Depth 6))
Copy-Item -LiteralPath $pkg -Destination $release
$docs = Join-Path $root 'artifacts/release-documentation'
[IO.Directory]::CreateDirectory($docs) | Out-Null
foreach ($file in @('README.md', 'LICENSE', 'CHANGELOG.md')) { Copy-Item -LiteralPath "$root/$file" -Destination $docs }
Copy-Item -LiteralPath "$projectDirectory/README.md" -Destination "$docs/Package-Guide.md"
Copy-Item -LiteralPath "$projectDirectory/RELEASE-NOTES.md" -Destination $docs
$licenses = Join-Path $docs 'licenses'
[IO.Directory]::CreateDirectory($licenses) | Out-Null
Get-ChildItem -LiteralPath "$extracted/Licenses" | Copy-Item -Destination $licenses -Recurse
Copy-Item -LiteralPath "$root/sources.lock.json" -Destination $docs
Copy-Item -LiteralPath "$root/release-packages.json" -Destination $docs
foreach ($file in $config.documentation) {
    Copy-Item -LiteralPath "$root/sources/$($file.source)/$($file.path)" -Destination "$docs/$($file.target)"
}
# Preserve paths used by the source READMEs inside the documentation archive.
$packageDocs = Join-Path $docs "packages/$Package"
[IO.Directory]::CreateDirectory($packageDocs) | Out-Null
foreach ($file in @('README.md', 'RELEASE-NOTES.md', 'THIRD-PARTY-NOTICES.md')) {
    if (Test-Path "$projectDirectory/$file") { Copy-Item -LiteralPath "$projectDirectory/$file" -Destination $packageDocs }
}
if (Test-Path "$projectDirectory/licenses") { Copy-Item -LiteralPath "$projectDirectory/licenses" -Destination $packageDocs -Recurse }
Copy-Item -LiteralPath "$root/THIRD-PARTY-NOTICES.md" -Destination $docs
Get-ChildItem -LiteralPath "$root/licenses" | Copy-Item -Destination $licenses -Recurse
[IO.Compression.ZipFile]::CreateFromDirectory($docs, "$release/$Package-Documentation.zip")
foreach ($archive in @(Get-ChildItem $release -File | Where-Object Extension -In '.pkg', '.zip')) {
    $zip = [IO.Compression.ZipFile]::OpenRead($archive.FullName)
    try {
        $private = @($zip.Entries | Where-Object FullName -Match '(?i)(\.local\.json$|\.csproj\.user$|\.Local\.targets$|(^|/)LiveTestSettings\.json$|ProcessorKeys\.dat$|(^|/)wiserkeys\.params$|\.pfx$|TestResults/)')
        if ($private.Count) { throw "Private file found in $($archive.Name)." }
    } finally { $zip.Dispose() }
}
$hashes = @(Get-ChildItem $release -File | Sort-Object Name | ForEach-Object { (Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant() + '  ' + $_.Name })
[IO.File]::WriteAllLines("$release/SHA256SUMS.txt", $hashes)
git -C $root diff --exit-code
if ($LASTEXITCODE -ne 0) { throw 'Build unexpectedly changed tracked files.' }