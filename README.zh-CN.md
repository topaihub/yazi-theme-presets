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
- [Win11 安装 PowerShell 7.6.1 与 Scoop](./docs/zh/win11-install-powershell-scoop.md)
- [Win11 上用 Scoop 安装 git / eza / yazi / starship 的完整环境初始化教程](./docs/zh/win11-init-git-eza-yazi-starship-with-scoop.md)
- [Win11 上配置 PowerShell profile，把 ls/ll/la 接到 eza，把 y 接到 yazi，把 starship 接进 prompt](./docs/zh/win11-configure-powershell-profile-for-eza-yazi-starship.md)
- [Theme Presets Repo](./docs/theme-presets.md)

## 已包含主题

完整终端主题：

- `themes/tokyo-night/theme.toml`
- `themes/catppuccin-powerline/theme.toml`
- `ls-colors/tokyo-night-ls-colors.ps1`
- `ls-colors/catppuccin-powerline-ls-colors.ps1`
- `powershell/tokyo-night-fileinfo.ps1`
- `powershell/catppuccin-powerline-fileinfo.ps1`
- `starship/tokyo-night.toml`
- `starship/catppuccin-powerline.toml`

仅 Yazi 主题：

- `themes/mac-terminal/theme.toml`

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
```

脚本会把所选预设复制到：

```text
YAZI_THEME_PRESETS_PWSH_DIR\starship.toml
or
STARSHIP_CONFIG directory\starship.toml
or
$PROFILE directory\starship.toml
```

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
```

当前激活的 PowerShell 和 `LS_COLORS` loader 保存在：

```text
<repo>\current
```

## 当前 Shell 接线

- `current\ls-colors.ps1` 会设置 `LS_COLORS`，供 `eza` 使用
- `current\powershell.ps1` 会设置 `$PSStyle.FileInfo.*`，作为 PowerShell 原生文件列表的配色
- 如果你希望新开的 shell 自动生效，需要在 PowerShell profile 里 `dot-source` 这两个 loader

## 主题覆盖范围

- `tokyo-night`：完整终端主题
- `catppuccin-powerline`：完整终端主题
- `mac-terminal`：当前仅提供 Yazi 主题，还没有对应的 Starship、`LS_COLORS` 和 PowerShell file-info 资产

切换后，重新打开一个 PowerShell 会话，或者执行 `. $PROFILE`。
