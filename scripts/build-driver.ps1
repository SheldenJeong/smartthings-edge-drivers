param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+(?:-[a-z0-9]+)*$')]
    [string]$Driver
)

$ErrorActionPreference = 'Stop'

$driverPath = Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'drivers') $Driver
$configPath = Join-Path $driverPath 'config.yaml'

if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw "Driver package not found or missing config.yaml: $driverPath"
}

if (-not (Get-Command smartthings -ErrorAction SilentlyContinue)) {
    throw 'SmartThings CLI was not found. Install it and ensure it is available on PATH.'
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$outputDirectory = Join-Path $repositoryRoot 'dist'
$outputPackage = Join-Path $outputDirectory "$Driver.zip"

New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

& smartthings edge:drivers:package --build-only $outputPackage $driverPath
if ($LASTEXITCODE -ne 0) {
    throw "SmartThings package build failed with exit code $LASTEXITCODE."
}

Write-Output "Built driver package: $outputPackage"
