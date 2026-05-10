# 工具链总览

这个工作区的终端主题不是单一工具完成的，而是拆成几段协作：

- [Yazi](../yazi.md)：交互式文件管理器
- [eza](../eza.md)：`ls` / `ll` / `la` 列表渲染与图标
- [Starship](../starship.md)：提示符渲染
- [PowerShell Profile](../powershell-profile.md)：shell 启动、别名和 loader 接线
- [主题预设仓库](./theme-presets.md)：主题资产和应用脚本

主题生效链路：

1. `apply-theme.ps1` 只更新 Yazi 主题
2. `apply-starship.ps1` 只更新 Starship 提示符主题
3. `apply-terminal-theme.ps1` 更新整套终端主题：
   - Yazi
   - Starship
   - `eza` 使用的 `LS_COLORS`
   - PowerShell 原生文件列表 fallback 配色
4. `Microsoft.PowerShell_profile.ps1` 会 `dot-source` `current\` 下面的 active loader

当前命令约定：

- `y` -> `yazi`
- `ls` -> `eza --icons=auto --group-directories-first`
- `ll` -> `eza --icons=auto --group-directories-first --long --all`
- `la` -> `eza --icons=auto --group-directories-first --all`

当前完整终端主题：

- `tokyo-night`
- `catppuccin-powerline`

当前仅 Yazi 主题：

- `mac-terminal`
