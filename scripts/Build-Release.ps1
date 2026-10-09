#requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$version = '0.3.0'
$packageName = "Tiggy-Mother-Launcher-v$version-Windows"
$distPath = Join-Path $repoRoot 'dist'
$zipPath = Join-Path $distPath "$packageName.zip"
$checksumsPath = Join-Path $distPath 'SHA256SUMS.txt'
# Explicit public allowlist: never package a working folder recursively.
$publicFiles = @(
    'Start-Launcher.cmd',
    'scripts\Build-Release.ps1',
    'src\ChatGPT-Codex-Selector-v0.3.ps1',
    'README.md',
    'LICENSE',
    'CHANGELOG.md',
    'docs\CUSTOMIZATION.md',
    'docs\SECURITY.md',
    'docs\LICENSE-CHOICE.md',
    'docs\releases\v0.3.0.md',
    'docs\screenshots\launcher.png',
    'docs\screenshots\settings.png'
)
foreach ($relativePath in $publicFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $relativePath) -PathType Leaf)) {
        throw "Required release file is missing: $relativePath"
    }
}
$parseTokens = $null
$parseErrors = $null
[void][Management.Automation.Language.Parser]::ParseFile(
    (Join-Path $repoRoot 'src\ChatGPT-Codex-Selector-v0.3.ps1'),
    [ref]$parseTokens, [ref]$parseErrors)
if ($parseErrors.Count -gt 0) { throw 'Launcher PowerShell syntax validation failed.' }
if ((Test-Path -LiteralPath $zipPath) -or (Test-Path -LiteralPath $checksumsPath)) {
    throw 'Release outputs already exist. Move the existing dist folder aside before rebuilding.'
}
New-Item -ItemType Directory -Path $distPath -Force | Out-Null
$buildRoot = [IO.Path]::GetFullPath((Join-Path $repoRoot '.local'))
$stagingRoot = Join-Path $buildRoot ([Guid]::NewGuid().ToString('N'))
$packagePath = Join-Path $stagingRoot $packageName
New-Item -ItemType Directory -Path $packagePath -Force | Out-Null
try {
    foreach ($relativePath in $publicFiles) {
        $destination = Join-Path $packagePath $relativePath
        New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot $relativePath) -Destination $destination
    }
    Compress-Archive -LiteralPath $packagePath -DestinationPath $zipPath -CompressionLevel Optimal
    $hash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
    "$hash  $packageName.zip" | Set-Content -LiteralPath $checksumsPath -Encoding ASCII
    Write-Output "Created $zipPath"
    Write-Output "SHA256: $hash"
} finally {
    # Delete only the unique staging directory inside this repository's .local folder.
    $resolvedStage = [IO.Path]::GetFullPath($stagingRoot)
    if (-not $resolvedStage.StartsWith($buildRoot + [IO.Path]::DirectorySeparatorChar,
        [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe staging cleanup path.' }
    if (Test-Path -LiteralPath $resolvedStage) {
        Remove-Item -LiteralPath $resolvedStage -Recurse -Force
    }
}
