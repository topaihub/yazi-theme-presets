param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("tokyo-night", "catppuccin-powerline", "mac-terminal")]
    [string]$Theme
)

function Get-PowerShellConfigDir {
    if ($env:YAZI_THEME_PRESETS_PWSH_DIR) {
        return $env:YAZI_THEME_PRESETS_PWSH_DIR
    }

    if ($env:STARSHIP_CONFIG) {
        return Split-Path -Parent $env:STARSHIP_CONFIG
    }

    return Split-Path -Parent $PROFILE
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$starshipSource = Join-Path $root ("starship\" + $Theme + ".toml")
$starshipTargetDir = Get-PowerShellConfigDir
$starshipTarget = Join-Path $starshipTargetDir "starship.toml"

$yaziSource = Join-Path $root ("themes\" + $Theme + "\theme.toml")
$yaziTargetDir = Join-Path $env:APPDATA "yazi\config"
$yaziTarget = Join-Path $yaziTargetDir "theme.toml"

$ezaSource = Join-Path $root ("eza\" + $Theme + "-theme.yml")
$ezaTargetDir = Join-Path $root "current\eza"
$ezaTarget = Join-Path $ezaTargetDir "theme.yml"

$lsColorsSource = Join-Path $root ("ls-colors\" + $Theme + "-ls-colors.ps1")
$lsColorsTarget = Join-Path $root "current\ls-colors.ps1"

$pwshSource = Join-Path $root ("powershell\" + $Theme + "-fileinfo.ps1")
$pwshTarget = Join-Path $root "current\powershell.ps1"

$themeMarker = Join-Path $root "current\theme.txt"

$required = @($starshipSource, $yaziSource, $ezaSource, $lsColorsSource, $pwshSource)
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Theme asset not found: $path"
    }
}

New-Item -Path (Split-Path -Parent $lsColorsTarget) -ItemType Directory -Force | Out-Null
New-Item -Path $ezaTargetDir -ItemType Directory -Force | Out-Null
New-Item -Path $starshipTargetDir -ItemType Directory -Force | Out-Null
New-Item -Path $yaziTargetDir -ItemType Directory -Force | Out-Null

Copy-Item -LiteralPath $starshipSource -Destination $starshipTarget -Force
Copy-Item -LiteralPath $yaziSource -Destination $yaziTarget -Force
Copy-Item -LiteralPath $ezaSource -Destination $ezaTarget -Force
Copy-Item -LiteralPath $lsColorsSource -Destination $lsColorsTarget -Force
Copy-Item -LiteralPath $pwshSource -Destination $pwshTarget -Force
Set-Content -LiteralPath $themeMarker -Value $Theme

Write-Host ("Applied terminal theme: " + $Theme)
Write-Host ("Starship: " + $starshipTarget)
Write-Host ("Yazi: " + $yaziTarget)
Write-Host ("eza theme: " + $ezaTarget)
Write-Host ("LS_COLORS loader: " + $lsColorsTarget)
Write-Host ("PowerShell file-info loader: " + $pwshTarget)
Write-Host "Target resolution: repo assets use relative source paths; user config targets are resolved from YAZI_THEME_PRESETS_PWSH_DIR, STARSHIP_CONFIG, PROFILE, and APPDATA"
Write-Host "Open a new PowerShell session or run . `$PROFILE"
