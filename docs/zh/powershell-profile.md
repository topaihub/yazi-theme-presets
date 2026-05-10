# PowerShell Profile

职责：

- shell 启动入口
- 负责把 prompt、别名、函数和主题 loader 串起来

Profile 路径：

- 运行 `$PROFILE` 查看当前机器上的实际路径

当前职责：

- 加载 `posh-git`
- 在交互式 shell 里加载 `PSReadLine`
- 追加稳定的 PATH 条目
- 设置 `STARSHIP_CONFIG`
- `dot-source`：
  - `current\ls-colors.ps1`
  - `current\powershell.ps1`
- 定义：
  - `y`
  - `ls`
  - `ll`
  - `la`

主题接线：

- `current\ls-colors.ps1` 给 `eza` 提供配色
- `current\powershell.ps1` 给原生 `Get-ChildItem` 提供 fallback 配色

说明：

- 你修改 `current\` 下面的文件后，已经打开的 shell 不会自动更新
- 重新打开一个 PowerShell 会话，或者执行 `. $PROFILE`

关联文档：

- [eza](./eza.md)
- [Starship](./starship.md)
- [主题预设仓库](./theme-presets.md)
