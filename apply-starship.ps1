param(
    [Parameter(Mandatory = $true)]
    [string]$Theme
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $root "lib\paths.ps1")

Assert-ThemeName -Root $root -Theme $Theme

$source = (Get-ThemeAssets -Root $root -Theme $Theme).starship
$targetDir = Get-PowerShellConfigDir
$target = Join-Path $targetDir "starship.toml"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Starship preset not found: $source"
}

New-Item -Path $targetDir -ItemType Directory -Force | Out-Null

# 目标可能是用户自己手调过的 starship.toml —— 覆盖它是这个仓库里唯一
# 不可逆的操作，所以先备份。与某份预设相同时不备份（那是上次 apply 留下的，
# 重复备份只会在用户目录里堆一串一样的文件）。
$presets = Get-AvailableThemes -Root $root | ForEach-Object {
    Join-Path $root ("starship\" + $_ + ".toml")
}
$backup = Backup-IfUserModified -Target $target -KnownPresets $presets

Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host ("Applied Starship preset: " + $Theme)
Write-Host ("Target: " + $target)
if ($backup) {
    Write-Host ("Backed up your previous config: " + $backup)
}
Write-Host "Target resolution order: YAZI_THEME_PRESETS_PWSH_DIR -> STARSHIP_CONFIG directory -> PROFILE directory"
Write-Host ""
Write-Warning "Open a new PowerShell session, or run: . `$PROFILE"
