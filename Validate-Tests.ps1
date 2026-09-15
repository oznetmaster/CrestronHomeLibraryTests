# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param([string] $Package = 'KasaClient.ProcessorTests', [string] $ResultsDirectory)
$ErrorActionPreference = 'Stop'
$config = & "$PSScriptRoot/Get-ReleasePackage.ps1" -Package $Package
if (!$ResultsDirectory) { $ResultsDirectory = "$PSScriptRoot/artifacts/test-results/$Package" }
& "$PSScriptRoot/tools/Test-DiscoveredCoverageGuards.ps1"
foreach ($test in $config.tests) {
    foreach ($framework in $test.frameworks) {
        $project = Join-Path $PSScriptRoot "sources/$($test.source)/$($test.project)"
        $discoveryOnly = $test.ContainsKey('discoveryOnly') -and [bool]$test.discoveryOnly
        $required = if ($discoveryOnly) { 'live' } else { 'unit' }
        & "$PSScriptRoot/tools/Test-DiscoveredCoverage.ps1" -Stage Desktop -Project $project -Framework $framework -RequiredCategories $required -DiscoveryOnly:$discoveryOnly -ResultsDirectory "$ResultsDirectory/$framework"
    }
}