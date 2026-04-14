param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("tokyo-night", "mac-terminal", "catppuccin-powerline")]
    [string]$Theme
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root ("themes\" + $Theme + "\theme.toml")
$targetDir = Join-Path $env:APPDATA "yazi\config"
$target = Join-Path $targetDir "theme.toml"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Theme file not found: $source"
}

New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host ("Applied theme: " + $Theme)
Write-Host ("Target: " + $target)
