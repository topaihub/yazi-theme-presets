# Yazi Theme Presets

本项目用于管理这个工作区里的 Yazi 主题以及相关终端配色预设。
同时也包含 Starship 预设，以及供 PowerShell 和 `eza` 使用的 loader 脚本。

[中文](./README.zh-CN.md) | [English](./README.md)

## 文档

- [中文总览](./docs/zh/toolchain-overview.md)
- [中文仓库说明](./docs/zh/theme-presets.md)
- [中文 Yazi 说明](./docs/zh/yazi.md)
- [中文 eza 说明](./docs/zh/eza.md)
- [中文 Starship 说明](./docs/zh/starship.md)
- [中文 PowerShell Profile 说明](./docs/zh/powershell-profile.md)
- [理解 shell、terminal、命令工具、主题和启动配置的分层关系](./docs/zh/understanding-shell-terminal-tool-theme-layers.md)
- [按操作系统理解 terminal、shell 和 tools 的对应关系](./docs/zh/terminal-shell-tool-by-os.md)
- [理解命令名、alias、function、cmdlet、executable 分别是什么](./docs/zh/understanding-command-alias-function-cmdlet-executable.md)
- [Zellij 使用教程：面向 AI 编程工作流的入门与使用场景](./docs/zh/zellij-for-ai-coding-workflows.md)
- [如何用 Zellij 提效 AI 编程：传统方式怎么做，有了 Zellij 之后怎么做](./docs/zh/how-zellij-improves-ai-coding.md)
- [Win11 上把 Zellij 默认 shell 配成 PowerShell 7](./docs/zh/win11-configure-zellij-default-shell-to-powershell.md)
- [Win11 安装 PowerShell 7.6.1 与 Scoop](./docs/zh/win11-install-powershell-scoop.md)
- [Win11 上用 Scoop 安装 git / eza / yazi / starship 的完整环境初始化教程](./docs/zh/win11-init-git-eza-yazi-starship-with-scoop.md)
- [Win11 上配置 PowerShell profile，把 ls/ll/la 接到 eza，把 y 接到 yazi，把 starship 接进 prompt](./docs/zh/win11-configure-powershell-profile-for-eza-yazi-starship.md)

## 已包含主题

完整终端主题：

- `themes/tokyo-night/theme.toml`
- `themes/catppuccin-powerline/theme.toml`
- `themes/mac-terminal/theme.toml`
- `ls-colors/tokyo-night-ls-colors.ps1`
- `ls-colors/catppuccin-powerline-ls-colors.ps1`
- `ls-colors/mac-terminal-ls-colors.ps1`
- `eza/tokyo-night-theme.yml`
- `eza/catppuccin-powerline-theme.yml`
- `eza/mac-terminal-theme.yml`
- `powershell/tokyo-night-fileinfo.ps1`
- `powershell/catppuccin-powerline-fileinfo.ps1`
- `powershell/mac-terminal-fileinfo.ps1`
- `starship/tokyo-night.toml`
- `starship/catppuccin-powerline.toml`
- `starship/mac-terminal.toml`

当前激活状态：

- `current\theme.txt`
- `apply-terminal-theme.ps1`

## 应用单独主题

在当前目录中执行：

```powershell
pwsh -File .\apply-theme.ps1 tokyo-night
pwsh -File .\apply-theme.ps1 mac-terminal
pwsh -File .\apply-theme.ps1 catppuccin-powerline
```

脚本会把所选预设复制到：

```text
%AppData%\yazi\config\theme.toml
```

应用完成后，重启 `yazi`。

## 应用 Starship 预设

在当前目录中执行：

```powershell
pwsh -File .\apply-starship.ps1 tokyo-night
pwsh -File .\apply-starship.ps1 catppuccin-powerline
pwsh -File .\apply-starship.ps1 mac-terminal
```

脚本会把所选预设复制到：

```text
YAZI_THEME_PRESETS_PWSH_DIR\starship.toml
or
STARSHIP_CONFIG directory\starship.toml
or
$PROFILE directory\starship.toml
```

**目标是你自己手调过的 `starship.toml` 时会先备份**成 `starship.toml.bak-<时间戳>`。
覆盖它是这个仓库里唯一不可逆的操作。内容与某份预设相同时不备份 —— 那是上次
apply 留下的，重复备份只会在你的配置目录里堆一串一样的文件。

切换后，重新打开一个 PowerShell 会话，或者执行 `. $PROFILE`。

如果你想强制把 PowerShell 配置目录指向自定义位置：

```powershell
$env:YAZI_THEME_PRESETS_PWSH_DIR = 'D:\Your\PowerShell\Config'
```

如果希望长期生效，把这行加入你的 PowerShell profile。

脚本会按下面的顺序解析目标目录：

1. `YAZI_THEME_PRESETS_PWSH_DIR`
2. `STARSHIP_CONFIG` 所在目录
3. `$PROFILE` 所在目录

仓库中的源文件路径是相对脚本位置解析的；真正写入的用户配置路径则取决于你的本地环境。

## 应用整套终端主题

这会一起切换以下内容：

- Starship
- `eza` 使用的 `LS_COLORS`
- PowerShell `dir` / `Get-ChildItem` fallback 配色
- `yazi`

在当前目录中执行：

```powershell
pwsh -File .\apply-terminal-theme.ps1 tokyo-night
pwsh -File .\apply-terminal-theme.ps1 catppuccin-powerline
pwsh -File .\apply-terminal-theme.ps1 mac-terminal
```

当前激活的 PowerShell 和 `LS_COLORS` loader 保存在：

```text
<repo>\current
```

整套应用是**两段式**的：五份资产先全部落成 `.tmp`，都成了再逐个改名。
中途失败（文件被占、目录突然不可写）时不会留下「starship 和 yazi 换了、
eza 还是旧的」这种配色对不上的半套状态。

`current/` 不进版本库，它是运行时状态。

## 当前 Shell 接线

- `current\ls-colors.ps1` 会设置 `LS_COLORS`（供 `eza` 使用）**以及 `EZA_CONFIG_DIR`**
- `current\eza\theme.yml` 会设置 `eza` 的元数据样式，例如日期、大小、表头和权限 ——
  它只在 `EZA_CONFIG_DIR` 指过来时才生效，所以那个变量由上面那个 loader 一起设
- `current\powershell.ps1` 会设置 `$PSStyle.FileInfo.*`，作为 PowerShell 原生文件列表的配色
- 如果你希望新开的 shell 自动生效，需要在 PowerShell profile 里 `dot-source` 这两个 loader

## 检查

改完跑一次：

```powershell
pwsh -File .\test.ps1
```

它检查每个主题的五份资产齐不齐、主题清单有没有被写死回脚本里、每个 loader
有没有设 `EZA_CONFIG_DIR`、`current/` 有没有被追踪、文档里提到的主题名是否真实存在。
CI 也跑这个（见 `.github/workflows/check.yml`）。

## 主题覆盖范围

- `tokyo-night`：完整终端主题
- `catppuccin-powerline`：完整终端主题
- `mac-terminal`：完整终端主题

切换后，重新打开一个 PowerShell 会话，或者执行 `. $PROFILE`。
