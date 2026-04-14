param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("tokyo-night", "catppuccin-powerline")]
    [string]$Theme
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$starshipSource = Join-Path $root ("starship\" + $Theme + ".toml")
$starshipTarget = "D:\Users\Documents\PowerShell\starship.toml"

$yaziSource = Join-Path $root ("themes\" + $Theme + "\theme.toml")
$yaziTargetDir = Join-Path $env:APPDATA "yazi\config"
$yaziTarget = Join-Path $yaziTargetDir "theme.toml"

$lsdSource = Join-Path $root ("lsd\" + $Theme + "-ls-colors.ps1")
$lsdTarget = Join-Path $root "current\lsd.ps1"

$pwshSource = Join-Path $root ("powershell\" + $Theme + "-fileinfo.ps1")
$pwshTarget = Join-Path $root "current\powershell.ps1"

$themeMarker = Join-Path $root "current\theme.txt"

$required = @($starshipSource, $yaziSource, $lsdSource, $pwshSource)
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Theme asset not found: $path"
    }
}

New-Item -Path (Split-Path -Parent $lsdTarget) -ItemType Directory -Force | Out-Null
New-Item -Path $yaziTargetDir -ItemType Directory -Force | Out-Null

Copy-Item -LiteralPath $starshipSource -Destination $starshipTarget -Force
Copy-Item -LiteralPath $yaziSource -Destination $yaziTarget -Force
Copy-Item -LiteralPath $lsdSource -Destination $lsdTarget -Force
Copy-Item -LiteralPath $pwshSource -Destination $pwshTarget -Force
Set-Content -LiteralPath $themeMarker -Value $Theme

Write-Host ("Applied terminal theme: " + $Theme)
Write-Host ("Starship: " + $starshipTarget)
Write-Host ("Yazi: " + $yaziTarget)
Write-Host ("LSD loader: " + $lsdTarget)
Write-Host ("PowerShell loader: " + $pwshTarget)
Write-Host "Open a new PowerShell session or run . `$PROFILE"
