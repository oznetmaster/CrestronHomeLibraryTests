# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param([string] $Package = 'KasaClient.ProcessorTests')
$ErrorActionPreference = 'Stop'
switch ($Package) {
    'KasaClient.ProcessorTests' {
        foreach ($framework in @('net472', 'net10.0')) {
            dotnet test "$PSScriptRoot/sources/KasaClient/KasaClient.Tests/KasaClient.Tests.csproj" -c Release -f $framework --filter 'TestCategory!=Live'
            if ($LASTEXITCODE -ne 0) { throw "Client desktop tests failed for $framework." }
        }
    }
    default { throw 'Add deterministic desktop validation before releasing this package.' }
}
