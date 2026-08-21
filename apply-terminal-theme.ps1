param(
    [Parameter(Mandatory = $true)]
    [string]$Theme
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $root "lib\paths.ps1")

Assert-ThemeName -Root $root -Theme $Theme

$assets = Get-ThemeAssets -Root $root -Theme $Theme

$starshipTargetDir = Get-PowerShellConfigDir
$yaziTargetDir = Join-Path $env:APPDATA "yazi\config"
$currentDir = Join-Path $root "current"
$ezaTargetDir = Join-Path $currentDir "eza"

# 目标 -> 源。五份一起换，所以下面按这张表统一处理，不再五行一模一样的 Copy-Item。
$plan = [ordered]@{
    (Join-Path $starshipTargetDir "starship.toml") = $assets.starship
    (Join-Path $yaziTargetDir "theme.toml")        = $assets.yazi
    (Join-Path $ezaTargetDir "theme.yml")          = $assets.eza
    (Join-Path $currentDir "ls-colors.ps1")        = $assets.lsColors
    (Join-Path $currentDir "powershell.ps1")       = $assets.pwsh
}

foreach ($path in $assets.Values) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Theme asset not found: $path"
    }
}

foreach ($dir in @($starshipTargetDir, $yaziTargetDir, $currentDir, $ezaTargetDir)) {
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
}

$starshipTarget = Join-Path $starshipTargetDir "starship.toml"
$starshipPresets = Get-AvailableThemes -Root $root | ForEach-Object {
    Join-Path $root ("starship\" + $_ + ".toml")
}
$backup = Backup-IfUserModified -Target $starshipTarget -KnownPresets $starshipPresets

# 先全部落成 .tmp，五个都成了再逐个改名。
#
# 之前是连着五个 Copy-Item -Force。第三个失败（文件被占、目录突然不可写）时
# 前两个已经写进去了 —— starship 和 yazi 是新主题、eza 还是旧的，用户看到的
# 是配色对不上。改名这一步几乎不会失败，所以两段式能把「只换了一半」的
# 窗口压到可以忽略。
$staged = [ordered]@{}
try {
    foreach ($target in $plan.Keys) {
        $tmp = "$target.tmp"
        Copy-Item -LiteralPath $plan[$target] -Destination $tmp -Force
        $staged[$target] = $tmp
    }
}
catch {
    # 半套 .tmp 留在用户目录里没意义，清掉再把原错误抛出去。
    foreach ($tmp in $staged.Values) {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
    throw
}

foreach ($target in $staged.Keys) {
    Move-Item -LiteralPath $staged[$target] -Destination $target -Force
}

# 标记最后写：五份都换成了才算换了主题。
Set-Content -LiteralPath (Join-Path $currentDir "theme.txt") -Value $Theme

Write-Host ("Applied terminal theme: " + $Theme)
foreach ($target in $plan.Keys) {
    Write-Host ("  " + $target)
}
if ($backup) {
    Write-Host ("Backed up your previous Starship config: " + $backup)
}
Write-Host "Target resolution: repo assets use relative source paths; user config targets are resolved from YAZI_THEME_PRESETS_PWSH_DIR, STARSHIP_CONFIG, PROFILE, and APPDATA"
Write-Host ""
Write-Warning "Open a new PowerShell session, or run: . `$PROFILE"
