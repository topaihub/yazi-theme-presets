param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("tokyo-night", "catppuccin-powerline")]
    [string]$Theme
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root ("starship\" + $Theme + ".toml")
$target = "D:\Users\Documents\PowerShell\starship.toml"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Starship preset not found: $source"
}

Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host ("Applied Starship preset: " + $Theme)
Write-Host ("Target: " + $target)
