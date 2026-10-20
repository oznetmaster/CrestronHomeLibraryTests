param(
    [Parameter(Mandatory)][string]$AdmissionDll,
    [Parameter(Mandatory)][string]$PoolCatalog,
    [Parameter(Mandatory)][string]$WorkflowBin,
    [string]$ProtectedRoot='C:\ProgramData\CrestronHomeHardwareCI',
    [switch]$Live,
    [string]$ProcessorSdkRoot
)
$ErrorActionPreference='Stop'
$collection=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$work=Join-Path $collection 'artifacts\EaseeChargerClient'
[IO.Directory]::CreateDirectory($work)|Out-Null
$private=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) ('EaseeChargerClient\ProcessorRuns\'+[guid]::NewGuid().ToString('N'))
[IO.Directory]::CreateDirectory($private)|Out-Null
$root=$ProtectedRoot

$library=Join-Path $collection 'sources\EaseeChargerClient'
$sdk=if($ProcessorSdkRoot){[IO.Path]::GetFullPath($ProcessorSdkRoot)}else{"$collection\sources\EaseeProcessorSdk"}
$probe=[IO.Path]::GetFullPath($AdmissionDll)
$bin=[IO.Path]::GetFullPath($WorkflowBin)
$run=[guid]::NewGuid().ToString('N')
$planFile="$private\plan-$run.json"
$settingsFile="$private\settings-$run.json"
$results="$work\processor-results-$run"
try {
    $scan=(& dotnet $probe $root $PoolCatalog)|ConvertFrom-Json
    if($LASTEXITCODE -ne 0){throw 'Shared processor availability could not be verified.'}
    if($scan.AvailableTargets.Count -eq 0){throw 'Both shared processors are reserved; no deployment attempted.'}
    foreach($target in $scan.AvailableTargets){
        $identity=Get-Content -LiteralPath "$root\templates\$target.json" -Raw|ConvertFrom-Json
        $package="$collection\packages\EaseeChargerClient.ProcessorTests"
        $liveSuites=@()
        if($Live){
            $inputs=Join-Path $env:EASEE_LIVE_TEST_DATA_DIRECTORY 'LiveTestSettings.json'
            if(!(Test-Path -LiteralPath $inputs)){throw 'Prepared read-only live inputs are missing.'}
            $liveSuites=@(@{Id='easeechargerclient-live';MinimumPassed=6;Inputs=@($inputs)})
        }
        $plan=@{
            Host=$identity.Host;SshFingerprint=$identity.SshFingerprint;CertificateSha256=$identity.CertificateSha256
            SourceRoots=@($collection,$library,$sdk)
            LocalTests=@(@{Project="$library\EaseeChargerClient.Tests\EaseeChargerClient.Tests.csproj";MinimumPassed=902;Filter='TestCategory!=Live'})
            TestPackage=@{Project="$package\EaseeChargerClient.ProcessorTests.csproj";PackagePath="$package\bin\Debug\net472\EaseeChargerClient.ProcessorTests.pkg";InstanceName='Easee Client Validation';LocationId=$identity.LocationId}
            ProcessorSuites=@(@{Id='easeechargerclient';MinimumPassed=451;Inputs=@()})
            LiveSuites=$liveSuites;DeployedChecks=@()
            RemoveTestInstanceAfterRun=$true;RemoveTestPackageAfterSuccessfulRun=$true
            StageTimeoutSeconds=900;LeaseWaitSeconds=0;AllowProcessorReboot=$false
        }
        [IO.File]::WriteAllText($planFile,($plan|ConvertTo-Json -Depth 20))
        $credentials=Get-Content -LiteralPath "$root\processor.settings.json" -Raw|ConvertFrom-Json
        [IO.File]::WriteAllText($settingsFile,(@{PlanPath=$planFile;UserName=$credentials.UserName;Password=$credentials.Password}|ConvertTo-Json))
        & dotnet $probe execute $bin $settingsFile $results
        $outcome=$LASTEXITCODE
        if($outcome -ne 75){
            [pscustomobject]@{ExitCode=$outcome;Results=$results;Target=$target;Live=[bool]$Live}|ConvertTo-Json
            exit $outcome
        }
        $results="$work\processor-results-$([guid]::NewGuid().ToString('N'))"
    }
    throw 'Processors became reserved before acquisition; existing reservations were preserved.'
}
finally {
    if(Test-Path -LiteralPath $settingsFile){Remove-Item -LiteralPath $settingsFile}
    if(Test-Path -LiteralPath $planFile){Remove-Item -LiteralPath $planFile}
    if(Test-Path -LiteralPath $private){Remove-Item -LiteralPath $private}

}
