# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param([string] $Package = 'KasaClient.ProcessorTests')
$ErrorActionPreference = 'Stop'
$config = & "$PSScriptRoot/Get-ReleasePackage.ps1" -Package $Package
foreach ($test in $config.tests) {
    foreach ($framework in $test.frameworks) {
        $project = Join-Path $PSScriptRoot "sources/$($test.source)/$($test.project)"
        dotnet test $project -c Release -f $framework --filter 'TestCategory!=Live'
        if ($LASTEXITCODE -ne 0) { throw "Desktop tests failed: $($test.project) ($framework)." }
    }
}
