# 主题预设仓库

职责：

- 作为当前工作区终端主题资产的统一来源

目录说明：

- `themes/`：Yazi 主题
- `starship/`：Starship 提示符预设
- `ls-colors/`：供 `eza` 使用的 `LS_COLORS` 预设
- `eza/`：`eza` 元数据主题，例如日期、大小、表头和权限
- `powershell/`：供 PowerShell 原生文件列表使用的 `$PSStyle.FileInfo.*` 预设
- `current/`：shell profile 读取的当前激活状态

脚本说明：

- `apply-theme.ps1`：只应用 Yazi 主题
- `apply-starship.ps1`：只应用 Starship 主题
- `apply-terminal-theme.ps1`：应用整套终端主题

当前激活文件：

- `current\theme.txt`
- `current\ls-colors.ps1`
- `current\eza\theme.yml`
- `current\powershell.ps1`

主题覆盖范围：

- 完整终端主题：
  - `tokyo-night`
  - `catppuccin-powerline`
  - `mac-terminal`

完整主题应包含的资产：

- `themes/<theme>/theme.toml`
- `starship/<theme>.toml`
- `ls-colors/<theme>-ls-colors.ps1`
- `eza/<theme>-theme.yml`
- `powershell/<theme>-fileinfo.ps1`

如果缺少其中某一项，这个主题就只能算局部主题，不应标记为完整终端主题。

`eza` 主题的配色映射规则：

`eza` 的 `theme.yml` 不应凭空猜色，而应从现有主题资产中映射出来。推荐按下面的规则处理：

- `date`
  - 优先参考 `starship` 中时间模块的前景色
  - 如果 `starship` 没有合适值，则退回到主题里的低饱和文本色或次级文本色
- `header`
  - 参考主题主强调色
  - 对 `tokyo-night` 一类主题，通常是目录色或标题色
- `size`
  - 数字部分优先参考积极信息色或常规文件强调色
  - 单位部分优先参考低饱和辅助色
- `perms.read`
  - 参考 Yazi 主题中的 `perm_read`
- `perms.write`
  - 参考 Yazi 主题中的 `perm_write`
- `perms.execute`
  - 参考 Yazi 主题中的 `perm_exec`
- `inode` / `blocks` / `links`
  - 优先使用低饱和辅助色，不应抢主内容注意力

推荐的来源优先级：

1. `starship/<theme>.toml`
2. `themes/<theme>/theme.toml`
3. `ls-colors/<theme>-ls-colors.ps1`

规则说明：

- `starship` 适合提供时间色、强调色和整体气质
- `yazi` 适合提供权限色、目录色、文本层级
- `ls-colors` 适合提供文件类型色，但不适合单独决定 `eza` 的日期和元数据色

实践要求：

- 不要直接照抄某一个文件里的所有颜色
- 也不要凭感觉重新发明一整套颜色
- 应先读取现有 `starship` / `yazi` / `ls-colors` 资产，再做字段映射

关联文档：

- [工具链总览](./toolchain-overview.md)
- [Yazi](../yazi.md)
- [eza](../eza.md)
- [PowerShell Profile](../powershell-profile.md)
