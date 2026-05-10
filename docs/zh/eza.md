# eza

职责：

- 作为 `ls`、`ll`、`la` 的渲染器
- 在普通 shell 列表输出中显示图标和配色

配色来源：

- `current\ls-colors.ps1`
- `current\eza\theme.yml`
- 这份 loader 会设置 `LS_COLORS`
- `eza` 会直接读取 `LS_COLORS`
- `theme.yml` 用来控制 `eza` 的元数据样式，例如日期、大小、表头和权限

当前 shell 映射：

- `ls` -> `eza --icons=auto --group-directories-first`
- `ll` -> `eza --icons=auto --group-directories-first --long --all`
- `la` -> `eza --icons=auto --group-directories-first --all`

说明：

- 这套方案已经替代了之前的 `Terminal-Icons`
- 现在图标来自 `eza`，不是 PowerShell 的格式化层
- 如果切换主题后颜色没有变化，重新打开 shell，或者执行 `. $PROFILE`

关联文档：

- [PowerShell Profile](./powershell-profile.md)
- [主题预设仓库](./theme-presets.md)
