# Copyright (c) 2026 Neil Colvin.
# Licensed under the MIT License with Commons Clause. See LICENSE in the repository root.

param([Parameter(Mandatory)][string] $Package)
$ErrorActionPreference = 'Stop'
$packages = Get-Content "$PSScriptRoot/release-packages.json" -Raw | ConvertFrom-Json -AsHashtable
if (!$packages.ContainsKey($Package) -or $Package -notmatch '^[A-Za-z][A-Za-z0-9.]*$') { throw 'Unsupported release package.' }
$config = $packages[$Package]
if (!$config.displayName -or !$config.suiteCategories.Count -or !$config.tests.Count) { throw 'Release validation configuration is incomplete.' }
return $config
