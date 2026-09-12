# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [switch] $UseLocalSources,
    [string] $LocalProjectsRoot = (Split-Path -Parent $PSScriptRoot),
    [hashtable] $LocalSourcePaths = @{}
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$lock = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'sources.lock.json') -Raw | ConvertFrom-Json
$sourceDirectory = Join-Path $PSScriptRoot 'sources'
function Get-LocalSourcePath([string] $Name) {
    if ($LocalSourcePaths.ContainsKey($Name)) { return [IO.Path]::GetFullPath([string]$LocalSourcePaths[$Name]) }
    $existing = Join-Path $sourceDirectory $Name
    if (Test-Path -LiteralPath $existing) {
        $item = Get-Item -LiteralPath $existing -Force
        if ($item.LinkType -eq 'Junction') { return [IO.Path]::GetFullPath([string]$item.Target) }
    }
    return Join-Path $LocalProjectsRoot $Name
}

# Private settings are excluded locally, never added to the tracked ignore file.
$exclude = & git -C $PSScriptRoot rev-parse --path-format=absolute --git-path info/exclude
if ($LASTEXITCODE -ne 0) { throw 'Initialize this directory as a Git repository before setting up sources.' }
$rules = if (Test-Path -LiteralPath $exclude) { [IO.File]::ReadAllText($exclude) } else { '' }
foreach ($pattern in @('**/*.csproj.user', '**/*.Local.targets', '**/Runner.local.json', '**/Runner.inputs.local.json', '**/LiveTestSettings.json')) {
    if ($rules -split '\r?\n' -notcontains $pattern) { $rules += "`r`n$pattern" }
}
[IO.File]::WriteAllText($exclude, $rules, [Text.UTF8Encoding]::new($false))

# Validate every entry before creating any checkout or link.
foreach ($source in $lock.sources) {
    if ($source.name -notmatch '^[A-Za-z][A-Za-z0-9]*$') { throw 'Invalid source directory name in sources.lock.json.' }
    if ($UseLocalSources) {
        $localPath = Get-LocalSourcePath $source.name
        if (!(Test-Path -LiteralPath (Join-Path $localPath $source.requiredProject))) { throw "Required project is missing in $localPath." }
    } elseif ($source.revision -notmatch '^[0-9a-f]{40}$' -or $source.repository -notmatch '^https://[^/@]+/[^?#]+$') {
        throw "Source '$($source.name)' is not pinned for public builds. Commit and publish its required changes, then run Update-SourceLock.ps1. For existing local checkouts, use -UseLocalSources."
    }
}
[IO.Directory]::CreateDirectory($sourceDirectory) | Out-Null
foreach ($source in $lock.sources) {
    $destination = Join-Path $sourceDirectory $source.name
    if ($UseLocalSources) {
        $localPath = [IO.Path]::GetFullPath((Get-LocalSourcePath $source.name))
        if (Test-Path -LiteralPath $destination) {
            $item = Get-Item -LiteralPath $destination -Force
            if ($item.LinkType -ne 'Junction' -or [IO.Path]::GetFullPath([string]$item.Target) -ne $localPath) {
                throw "Existing source at $destination is not the requested local link. It has been left untouched."
            }
        } else {
            New-Item -ItemType Junction -Path $destination -Target $localPath | Out-Null
        }
        Write-Host "Linked $($source.name) to its existing local checkout."
    } else {
        if (!(Test-Path -LiteralPath $destination)) {
            & git clone --no-checkout -- $source.repository $destination
            if ($LASTEXITCODE -ne 0) { throw "Could not clone $($source.name)." }
            & git -C $destination checkout --detach $source.revision
            if ($LASTEXITCODE -ne 0) { throw "Could not check out the recorded commit for $($source.name)." }
        }
        if ((Get-Item -LiteralPath $destination -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "Locked builds require real source checkouts, not local links: $destination. Use a fresh collection checkout for releases."
        }
        $head = & git -C $destination rev-parse HEAD
        if ($LASTEXITCODE -ne 0 -or $head -ne $source.revision) { throw "Source revision mismatch: $($source.name). Existing files were left untouched." }
        $changes = & git -C $destination status --porcelain --untracked-files=normal
        if ($LASTEXITCODE -ne 0 -or $changes) { throw "Locked source must be clean: $($source.name)." }
        if (!(Test-Path -LiteralPath (Join-Path $destination $source.requiredProject))) { throw "Required project is missing from the pinned revision of $($source.name)." }
        Write-Host "Verified pinned source: $($source.name) at $head."
    }
}
Write-Host 'Open CrestronHomeLibraryTests.sln in Visual Studio.'
