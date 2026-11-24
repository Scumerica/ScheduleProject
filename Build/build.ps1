# Builds "SWIFT Sync.exe" in the project folder: the launcher with scheduler.html and the banner packed inside.
# Run it again after changing the app to pack the new version. Needs only Windows' own .NET Framework compiler.
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$csc = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
if (-not (Test-Path $csc)) { $csc = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe' }

$icon = Join-Path $PSScriptRoot 'swift-sync.ico'
if (-not (Test-Path $icon)) { & (Join-Path $PSScriptRoot 'make-icon.ps1') | Out-Null }

$out = Join-Path $root 'SWIFT Sync.exe'
& $csc /nologo /target:winexe /optimize+ "/out:$out" "/win32icon:$icon" `
    /reference:System.Windows.Forms.dll `
    "/resource:$(Join-Path $root 'Data\scheduler.html'),scheduler.html" `
    "/resource:$(Join-Path $root 'Data\swift-banner.jpg'),swift-banner.jpg" `
    (Join-Path $PSScriptRoot 'SwiftSync.cs')
if ($LASTEXITCODE -ne 0) { throw "The compiler reported errors." }
"built $out ($([math]::Round((Get-Item $out).Length / 1KB)) KB)"
