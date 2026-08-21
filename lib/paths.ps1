# 共用的路径解析。apply-starship.ps1 与 apply-terminal-theme.ps1 都 dot-source 它。
#
# 之前这两个脚本里各有一份逐字相同的 Get-PowerShellConfigDir。改解析顺序
# （比如想加一档回落）要改两处，漏一处的现象是「单独应用 starship」和
# 「整套应用」把 starship.toml 落到两个不同的目录。

# 用户的 PowerShell 配置目录，也就是 starship.toml 该落的地方。
#
# 顺序：显式指定 -> STARSHIP_CONFIG 所在目录 -> $PROFILE 所在目录。
function Get-PowerShellConfigDir {
    if ($env:YAZI_THEME_PRESETS_PWSH_DIR) {
        return $env:YAZI_THEME_PRESETS_PWSH_DIR
    }

    if ($env:STARSHIP_CONFIG) {
        return Split-Path -Parent $env:STARSHIP_CONFIG
    }

    return Split-Path -Parent $PROFILE
}

# themes\ 下面实际存在的主题名。
#
# 这是主题清单的**唯一来源**。之前三个脚本各写一份 ValidateSet，加一个主题
# 要改三处，而漏掉的那个脚本会把新主题当非法值拒掉。
function Get-AvailableThemes {
    param([Parameter(Mandatory = $true)][string]$Root)

    Get-ChildItem -LiteralPath (Join-Path $Root "themes") -Directory |
        Select-Object -ExpandProperty Name |
        Sort-Object
}

# 主题名合法吗，不合法就连可选项一起报出来。
#
# 不用 ValidateSet 是因为那个清单得跟着 themes\ 走（见 Get-AvailableThemes）。
# 代价是报错时机从参数绑定挪到了函数体，所以这里要自己把可选项列清楚 ——
# 光说「非法主题」不给清单，用户得去翻目录。
function Assert-ThemeName {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Theme
    )

    $available = Get-AvailableThemes -Root $Root
    if ($available -notcontains $Theme) {
        throw ("Unknown theme: {0}. Available: {1}" -f $Theme, ($available -join ", "))
    }
}

# 一个主题算「完整终端主题」要的五份资产。
#
# 键是给报错用的可读名字，值是相对仓库根的路径。
function Get-ThemeAssets {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Theme
    )

    [ordered]@{
        yazi     = Join-Path $Root ("themes\" + $Theme + "\theme.toml")
        starship = Join-Path $Root ("starship\" + $Theme + ".toml")
        eza      = Join-Path $Root ("eza\" + $Theme + "-theme.yml")
        lsColors = Join-Path $Root ("ls-colors\" + $Theme + "-ls-colors.ps1")
        pwsh     = Join-Path $Root ("powershell\" + $Theme + "-fileinfo.ps1")
    }
}

# 目标文件已经存在、而且不是我们任何一份预设时，先备份。
#
# 覆盖用户手调过的 starship.toml 是这个仓库里唯一不可逆的操作。判据是
# 「与所有预设都不同」—— 相同说明那是上次 apply 留下的，重复备份只会
# 在用户目录里堆一串一样的文件。
function Backup-IfUserModified {
    param(
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][string[]]$KnownPresets
    )

    if (-not (Test-Path -LiteralPath $Target)) {
        return $null
    }

    # 比哈希而不是逐行 Compare-Object：只要真假，不要差异明细。
    $targetHash = (Get-FileHash -LiteralPath $Target -Algorithm SHA256).Hash
    foreach ($preset in $KnownPresets) {
        if (-not (Test-Path -LiteralPath $preset)) {
            continue
        }
        if ((Get-FileHash -LiteralPath $preset -Algorithm SHA256).Hash -eq $targetHash) {
            return $null   # 就是某份预设，不用备份
        }
    }

    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$Target.bak-$stamp"
    Copy-Item -LiteralPath $Target -Destination $backup -Force
    return $backup
}
