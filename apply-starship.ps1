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
$source = Join-Path $root ("starship\" + $Theme + ".toml")
$targetDir = Get-PowerShellConfigDir
$target = Join-Path $targetDir "starship.toml"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Starship preset not found: $source"
}

New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host ("Applied Starship preset: " + $Theme)
Write-Host ("Target: " + $target)
Write-Host "Target resolution order: YAZI_THEME_PRESETS_PWSH_DIR -> STARSHIP_CONFIG directory -> PROFILE directory"
