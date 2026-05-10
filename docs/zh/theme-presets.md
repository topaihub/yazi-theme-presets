# 主题预设仓库

职责：

- 作为当前工作区终端主题资产的统一来源

目录说明：

- `themes/`：Yazi 主题
- `starship/`：Starship 提示符预设
- `ls-colors/`：供 `eza` 使用的 `LS_COLORS` 预设
- `powershell/`：供 PowerShell 原生文件列表使用的 `$PSStyle.FileInfo.*` 预设
- `current/`：shell profile 读取的当前激活状态

脚本说明：

- `apply-theme.ps1`：只应用 Yazi 主题
- `apply-starship.ps1`：只应用 Starship 主题
- `apply-terminal-theme.ps1`：应用整套终端主题

当前激活文件：

- `current\theme.txt`
- `current\ls-colors.ps1`
- `current\powershell.ps1`

主题覆盖范围：

- 完整终端主题：
  - `tokyo-night`
  - `catppuccin-powerline`
- 当前仅 Yazi 主题：
  - `mac-terminal`

关联文档：

- [工具链总览](./toolchain-overview.md)
- [Yazi](../yazi.md)
- [eza](../eza.md)
- [PowerShell Profile](../powershell-profile.md)
