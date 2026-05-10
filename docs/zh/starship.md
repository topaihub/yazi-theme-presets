# Starship

职责：

- 渲染 shell prompt
- 控制分隔符、提示符符号和 prompt 配色

主题来源：

- `starship/<theme>.toml`

应用命令：

```powershell
pwsh -File .\apply-starship.ps1 tokyo-night
pwsh -File .\apply-starship.ps1 catppuccin-powerline
```

目标解析顺序：

1. `YAZI_THEME_PRESETS_PWSH_DIR\starship.toml`
2. `STARSHIP_CONFIG` 所在目录
3. `$PROFILE` 所在目录

说明：

- 这只影响 prompt
- 它不控制 `ls` 配色，也不控制 Yazi 主题
- 仓库里的预设源文件是相对仓库解析的
- 最终写入位置则取决于当前用户本机环境

关联文档：

- [工具链总览](./toolchain-overview.md)
- [PowerShell Profile](./powershell-profile.md)
