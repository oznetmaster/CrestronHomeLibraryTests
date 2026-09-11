# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [ValidateSet('Debug','Release')][string] $Configuration = 'Debug',
    [string] $Package = 'KasaClient.ProcessorTests',
    [switch] $LockedSources,
    [string] $ReleaseVersion,
    [string] $ManifestUtilExe
)
$ErrorActionPreference = 'Stop'
if ($Package -notmatch '^[A-Za-z][A-Za-z0-9.]*$') { throw 'Invalid package project name.' }
if ($Configuration -eq 'Release' -and !$LockedSources) { throw 'Release builds require -LockedSources and a fresh checkout with recorded source revisions.' }
if ($LockedSources) { & (Join-Path $PSScriptRoot 'Initialize-Sources.ps1') }
$project = Join-Path $PSScriptRoot "packages\$Package\$Package.csproj"
if (!(Test-Path -LiteralPath $project)) { throw "Package project not found: $Package" }
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$msbuild = & $vswhere -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild\**\Bin\MSBuild.exe' | Select-Object -First 1
if (!$msbuild) { throw 'Visual Studio MSBuild is required.' }
$buildArguments = @($project, '/restore', '/nologo', '/v:minimal', "/p:Configuration=$Configuration", '/p:BuildProcessorTestPackages=true', '/p:DeployAfterBuild=false')
if ($ReleaseVersion) { $buildArguments += "/p:ReleaseVersion=$ReleaseVersion" }
if ($ManifestUtilExe) { $buildArguments += "/p:ManifestUtilExe=$ManifestUtilExe", "/p:LocalCrestronSdkLibDir=$(Split-Path $ManifestUtilExe -Parent)" }
& $msbuild @buildArguments
if ($LASTEXITCODE -ne 0) { throw 'Package build failed.' }
$provenance = [ordered]@{ package=$Package; configuration=$Configuration; lockedSources=[bool]$LockedSources; sources=@() }
$lock = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'sources.lock.json') -Raw | ConvertFrom-Json
foreach ($source in $lock.sources) {
    $path = Join-Path $PSScriptRoot "sources\$($source.name)"
    $revision = & git -C $path rev-parse HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Could not record build source revision.' }
    $changes = & git -C $path status --porcelain --untracked-files=normal
    if ($LASTEXITCODE -ne 0) { throw 'Could not record build source status.' }
    $provenance.sources += [ordered]@{ name=$source.name; revision=$revision; modified=[bool]$changes }
}
$output = Join-Path $PSScriptRoot "packages\$Package\bin\$Configuration\net472\$Package.sources.json"
[IO.File]::WriteAllText($output, ($provenance | ConvertTo-Json -Depth 6), [Text.UTF8Encoding]::new($false))
