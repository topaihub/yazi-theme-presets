# 仓库不变量检查。`pwsh -File .\test.ps1`
#
# 这里守的都是**已经破过一次**的东西：
#   - 文档说 mac-terminal 只是局部主题，实际五份资产全齐（三份文档里有一份没跟上）
#   - 主题清单曾经在三个脚本里各写一遍，加主题要改三处
#   - eza\theme.yml 复制过去了但没人设 EZA_CONFIG_DIR，那份资产是死的
#
# 不引 Pester：一个仓库检查不值得让 CI 先装个测试框架。

$ErrorActionPreference = 'Stop'

# 控制台默认按 ANSI 代码页解码，中文输出会是一串乱码 —— 而这个脚本的
# 失败信息全是中文，乱码等于没有失败信息。
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $root "lib\paths.ps1")

$failures = @()
function Check {
    param([string]$Name, [scriptblock]$Body)

    try {
        & $Body
        Write-Host "  ok   $Name"
    }
    catch {
        Write-Host "  FAIL $Name" -ForegroundColor Red
        Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
        $script:failures += $Name
    }
}

$themes = Get-AvailableThemes -Root $root
Write-Host "主题：$($themes -join ', ')"
Write-Host ""

Check "至少有一个主题" {
    if ($themes.Count -lt 1) { throw "themes\ 下面一个目录都没有" }
}

foreach ($theme in $themes) {
    Check "$theme 五份资产齐全" {
        $assets = Get-ThemeAssets -Root $root -Theme $theme
        $missing = $assets.Keys | Where-Object { -not (Test-Path -LiteralPath $assets[$_]) }
        if ($missing) {
            throw "缺 $($missing -join ', ')：不齐的主题只能算局部主题，不该标成完整终端主题"
        }
    }
}

Check "三个 apply 脚本都不再写死主题清单" {
    # 写死的现象是加一个主题要改三处，漏掉的那个脚本把新主题当非法值拒掉。
    #
    # 匹配 `[ValidateSet(` 而不是光匹配 `ValidateSet`：后者会被注释里
    # 「不写死在 ValidateSet 里」这句话触发，那是个假失败。
    foreach ($script in @("apply-theme.ps1", "apply-starship.ps1", "apply-terminal-theme.ps1")) {
        $text = Get-Content -LiteralPath (Join-Path $root $script) -Raw
        if ($text -match '\[\s*ValidateSet\s*\(') {
            throw "$script 里还有 ValidateSet，主题清单该从 themes\ 读"
        }
    }
}

Check "非法主题名会被拒，而且报错里带可选项" {
    try {
        Assert-ThemeName -Root $root -Theme "绝对不存在的主题"
        throw "非法主题名居然通过了"
    }
    catch {
        $message = $_.Exception.Message
        if ($message -notmatch [regex]::Escape($themes[0])) {
            throw "报错里没列出可选项，用户得自己去翻目录：$message"
        }
    }
}

Check "每个 ls-colors loader 都设了 EZA_CONFIG_DIR" {
    # 不设的话 eza\<theme>-theme.yml 是死的：复制过去了但 eza 不去那儿找。
    foreach ($theme in $themes) {
        $loader = Join-Path $root ("ls-colors\" + $theme + "-ls-colors.ps1")
        $text = Get-Content -LiteralPath $loader -Raw
        if ($text -notmatch 'EZA_CONFIG_DIR') {
            throw "$theme 的 loader 没设 EZA_CONFIG_DIR，它那份 theme.yml 不会生效"
        }
    }
}

Check "current\ 不被追踪" {
    # 追踪它的现象是 apply 一次主题工作区就脏，pull 时撞无意义冲突。
    $tracked = git -C $root ls-files current/
    if ($tracked) {
        throw "current\ 下面还有追踪的文件：$tracked"
    }
}

Check "文档里提到的主题名都真实存在" {
    $docs = Get-ChildItem -LiteralPath $root -Recurse -Filter *.md |
        Where-Object { $_.FullName -notlike "*\.git\*" }
    # 形如 themes/<name>/theme.toml 或 themes\<name>\theme.toml 的引用。
    foreach ($doc in $docs) {
        $text = Get-Content -LiteralPath $doc.FullName -Raw
        foreach ($match in [regex]::Matches($text, 'themes[\\/]([a-z0-9-]+)[\\/]theme\.toml')) {
            $name = $match.Groups[1].Value
            if ($themes -notcontains $name) {
                throw "$($doc.Name) 提到主题 $name，但 themes\ 下没有它"
            }
        }
    }
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "$($failures.Count) 项未通过：$($failures -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host "全部通过" -ForegroundColor Green
