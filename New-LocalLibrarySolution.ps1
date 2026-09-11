# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [string] $Source = 'KasaClient',
    [string] $SolutionFile = 'KasaClient.slnx',
    [string] $Package = 'KasaClient.ProcessorTests',
    [switch] $Force
)
$ErrorActionPreference = 'Stop'
if ($Source -notmatch '^[A-Za-z][A-Za-z0-9]*$' -or $Package -notmatch '^[A-Za-z][A-Za-z0-9.]*$' -or $SolutionFile -notmatch '^[A-Za-z][A-Za-z0-9.]*\.slnx$') {
    throw 'Use a source name, package name and a solution filename without directory components.'
}
$sourceLink = Get-Item -LiteralPath (Join-Path $PSScriptRoot "sources\$Source") -Force
if ($sourceLink.LinkType -ne 'Junction') { throw 'This helper is for local development. Run Initialize-Sources.ps1 -UseLocalSources first.' }
$libraryRoot = [IO.Path]::GetFullPath([string]$sourceLink.Target)
$original = Join-Path $libraryRoot $SolutionFile
$destinationName = [IO.Path]::GetFileNameWithoutExtension($SolutionFile) + '.Local.slnx'
$destination = Join-Path $libraryRoot $destinationName
if ((Test-Path -LiteralPath $destination) -and !$Force) { throw "Local solution already exists. Use -Force to regenerate it from $SolutionFile." }
$packageProject = Join-Path $PSScriptRoot "packages\$Package\$Package.csproj"
if (!(Test-Path -LiteralPath $packageProject)) { throw 'Package project does not exist.' }
$xml = [xml]::new()
$xml.PreserveWhitespace = $true
$xml.Load($original)
# Use the same logical paths as the package's project references. Otherwise MSBuild
# can build the original and junction aliases concurrently into identical outputs.
foreach ($project in $xml.SelectNodes('//Project[@Path]')) {
    $path = [IO.Path]::GetFullPath((Join-Path $libraryRoot $project.GetAttribute('Path')))
    if ($path.StartsWith($libraryRoot + '\', [StringComparison]::OrdinalIgnoreCase)) {
        $path = Join-Path $sourceLink.FullName ([IO.Path]::GetRelativePath($libraryRoot, $path))
    }
    $project.SetAttribute('Path', [IO.Path]::GetRelativePath($libraryRoot, $path).Replace('\', '/'))
}
$packageEntry = $xml.CreateElement('Project')
$packageEntry.SetAttribute('Path', [IO.Path]::GetRelativePath($libraryRoot, $packageProject).Replace('\', '/'))
$xml.DocumentElement.AppendChild($packageEntry) | Out-Null
$exclude = & git -C $libraryRoot rev-parse --path-format=absolute --git-path info/exclude
if ($LASTEXITCODE -ne 0) { throw 'Cannot find the library repository exclusions.' }
$rules = if (Test-Path -LiteralPath $exclude) { [IO.File]::ReadAllText($exclude) } else { '' }
if ($rules -split '\r?\n' -notcontains "/$destinationName") { $rules += "`r`n/$destinationName`r`n" }
$utf8 = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($exclude, $rules, $utf8)
[IO.File]::WriteAllText($destination, ($xml.OuterXml -replace '\r?\n', "`r`n"), $utf8)
& git -C $libraryRoot check-ignore --quiet -- $destinationName
if ($LASTEXITCODE -ne 0) { throw 'The private solution is not excluded from Git.' }
Write-Host "Open $destination. Build $Package to package and deploy using its existing local settings."
