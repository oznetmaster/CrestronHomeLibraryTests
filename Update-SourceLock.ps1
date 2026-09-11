# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [Parameter(Mandatory)][string] $Name,
    [string] $Checkout,
    [string] $Repository
)
$ErrorActionPreference = 'Stop'
$lockPath = Join-Path $PSScriptRoot 'sources.lock.json'
$lock = Get-Content -LiteralPath $lockPath -Raw | ConvertFrom-Json
$source = @($lock.sources | Where-Object name -EQ $Name)
if ($source.Count -ne 1) { throw 'Choose a source name already declared in sources.lock.json.' }
if (!$Checkout) { $Checkout = Join-Path $PSScriptRoot "sources\$Name" }
$changes = & git -C $Checkout status --porcelain --untracked-files=normal
if ($LASTEXITCODE -ne 0 -or $changes) { throw 'Commit the source changes before recording a release revision.' }
$revision = & git -C $Checkout rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or $revision -notmatch '^[0-9a-f]{40}$') { throw 'Could not determine source commit.' }
if (!$Repository) { $Repository = & git -C $Checkout remote get-url origin }
if ($Repository -notmatch '^https://[^/@]+/[^?#]+$') { throw 'Supply a public HTTPS repository URL without credentials.' }
if (!(Test-Path -LiteralPath (Join-Path $Checkout $source[0].requiredProject))) { throw 'The required project is missing.' }
$source[0].repository = $Repository
$source[0].revision = $revision
[IO.File]::WriteAllText($lockPath, (($lock | ConvertTo-Json -Depth 6) -replace '\r?\n', "`r`n"), [Text.UTF8Encoding]::new($false))
Write-Host "Recorded $Name at $revision. Publish that commit before using it from a fresh checkout."
