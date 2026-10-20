param(
    [Parameter(Mandatory = $true)]
    [string]$SourceModPath
)

$ErrorActionPreference = "Stop"
$compiler = Join-Path $SourceModPath "scripting\spcomp64.exe"
if (-not (Test-Path -LiteralPath $compiler)) {
    $compiler = Join-Path $SourceModPath "scripting\spcomp.exe"
}
if (-not (Test-Path -LiteralPath $compiler)) {
    throw "Could not find spcomp64.exe or spcomp.exe under $SourceModPath\scripting"
}

$source = Join-Path $PSScriptRoot "scripting\tf2c_custom_schema_download.sp"
$include = Join-Path $SourceModPath "scripting\include"
$outputDir = Join-Path $PSScriptRoot "build"
$output = Join-Path $outputDir "tf2c_custom_schema_download.smx"

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
& $compiler $source -i $include -o $output
if ($LASTEXITCODE -ne 0) {
    throw "SourcePawn compilation failed with exit code $LASTEXITCODE"
}

Write-Host "Built $output"
