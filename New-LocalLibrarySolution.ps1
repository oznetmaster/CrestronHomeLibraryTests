# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param(
    [string] $Source = 'KasaClient',
    [string] $SolutionFile = 'KasaClient.slnx',
    [string] $Package = 'KasaClient.ProcessorTests',
    [switch] $Force
)
$ErrorActionPreference = 'Stop'
if ($Source -notmatch '^[A-Za-z][A-Za-z0-9]*$' -or $Package -notmatch '^[A-Za-z][A-Za-z0-9.]*$' -or $SolutionFile -notmatch '^[A-Za-z][A-Za-z0-9. _-]*\.slnx?$') {
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
if ([IO.Path]::GetExtension($original) -eq '.sln') {
    # Convert a temporary copy so the library's tracked solution stays unchanged.
    $conversionDirectory = Join-Path ([IO.Path]::GetTempPath()) ('processor-local-solution-' + [Guid]::NewGuid().ToString('N'))
    [IO.Directory]::CreateDirectory($conversionDirectory) | Out-Null
    $temporarySolution = Join-Path $conversionDirectory $SolutionFile
    $convertedSolution = [IO.Path]::ChangeExtension($temporarySolution, '.slnx')
    try {
        Copy-Item -LiteralPath $original -Destination $temporarySolution
        & dotnet sln $temporarySolution migrate
        if ($LASTEXITCODE -ne 0) { throw 'Cannot convert the original solution to a local solution view.' }
        $xml.Load($convertedSolution)
    } finally {
        foreach ($temporaryFile in @($temporarySolution, $convertedSolution)) {
            if (Test-Path -LiteralPath $temporaryFile) { Remove-Item -LiteralPath $temporaryFile }
        }
        Remove-Item -LiteralPath $conversionDirectory
    }
} else {
    $xml.Load($original)
}
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
$workflowName = $Package.Replace('.ProcessorTests', '.WorkflowTests')
$workflowProject = Join-Path $PSScriptRoot "workflows/$workflowName/$workflowName.csproj"
if (Test-Path -LiteralPath $workflowProject) {
    $workflowEntry = $xml.CreateElement('Project')
    $workflowEntry.SetAttribute('Path', [IO.Path]::GetRelativePath($libraryRoot, $workflowProject).Replace('\', '/'))
    $xml.DocumentElement.AppendChild($workflowEntry) | Out-Null
}

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
