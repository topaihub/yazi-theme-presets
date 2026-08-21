# eza 的元数据配色（日期、大小、表头、权限）来自 $EZA_CONFIG_DIR\theme.yml。
# 没有这一行的话 eza\<theme>-theme.yml 是**死的** —— apply 脚本把它复制到
# current\eza\theme.yml，但 eza 不知道去那儿找，那几份映射过的颜色一个都不生效。
#
# 放在这个 loader 里而不是 profile 里：它已经被 dot-source 了，profile 不用改。
# $PSScriptRoot 在被 dot-source 时也有值，指向 current\。
$ezaConfigDir = Join-Path $PSScriptRoot "eza"
if (Test-Path -LiteralPath $ezaConfigDir) {
    $env:EZA_CONFIG_DIR = $ezaConfigDir
}

$env:LS_COLORS = @(
    'di=01;38;5;117'
    'ln=38;5;81'
    'ex=38;5;114'
    '*.md=38;5;150'
    '*.json=38;5;114'
    '*.yaml=38;5;114'
    '*.yml=38;5;114'
    '*.toml=38;5;114'
    '*.png=38;5;177'
    '*.jpg=38;5;177'
    '*.jpeg=38;5;177'
    '*.gif=38;5;177'
    '*.svg=38;5;177'
    '*.mp4=38;5;215'
    '*.mp3=38;5;215'
) -join ':'
