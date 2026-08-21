param(
    [Parameter(Mandatory = $true)]
    [string]$Theme
)

# 任何一步出错就停。默认的 Continue 会让脚本带着半套状态跑到底，
# 最后照样打印 "Applied theme"。
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $root "lib\paths.ps1")

# 主题清单从 themes\ 读，不写死在 ValidateSet 里 —— 加主题只加一个目录。
Assert-ThemeName -Root $root -Theme $Theme

$source = (Get-ThemeAssets -Root $root -Theme $Theme).yazi
$targetDir = Join-Path $env:APPDATA "yazi\config"
$target = Join-Path $targetDir "theme.toml"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Theme file not found: $source"
}

New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host ("Applied theme: " + $Theme)
Write-Host ("Target: " + $target)
Write-Host ""
# 用 Write-Warning 而不是 Write-Host：这是用户唯一必须做的手动动作，
# 排在几行普通输出后面最容易被当成收尾噪音划过去。
Write-Warning "Restart yazi to pick up the new theme."
