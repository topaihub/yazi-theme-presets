# Win11 上配置 PowerShell profile，把 ls/ll/la 接到 eza，把 y 接到 yazi，把 starship 接进 prompt

本文面向 Windows 11，目标是把 PowerShell 7 配成一套顺手的日常终端环境：

- `ls` / `ll` / `la` 走 `eza`
- `y` 走 `yazi`
- `starship` 接管 prompt

这篇只讲 **profile 配置**，默认前提是你已经装好了：

- PowerShell 7
- Scoop
- `git`
- `eza`
- `yazi`
- `starship`

如果这些还没装，先看前两篇：

- [Win11 安装 PowerShell 7.6.1 与 Scoop](./win11-install-powershell-scoop.md)
- [Win11 上用 Scoop 安装 git / eza / yazi / starship 的完整环境初始化教程](./win11-init-git-eza-yazi-starship-with-scoop.md)

## 这篇最终会得到什么

配置完成后，你会得到下面这套习惯：

```powershell
ls
ll
la
y
```

对应行为：

- `ls`：走 `eza`
- `ll`：走 `eza --long --all`
- `la`：走 `eza --all`
- `y`：直接打开 `yazi`

同时：

- PowerShell prompt 由 `starship` 渲染
- 如果你已经有 `yazi-theme-presets` 仓库，还可以把 `LS_COLORS` 和 PowerShell fallback 配色一起接进来

## 第 1 步：确认 profile 路径

先执行：

```powershell
$PROFILE
```

常见结果类似：

```text
C:\Users\<你的用户名>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

如果目录不存在，先创建：

```powershell
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $PROFILE) | Out-Null
```

如果文件不存在，也先创建：

```powershell
New-Item -ItemType File -Force -Path $PROFILE | Out-Null
```

## 第 2 步：把 starship 接进 prompt

先编辑你的 profile：

```powershell
notepad $PROFILE
```

加入下面这段：

```powershell
$env:STARSHIP_CONFIG = Join-Path (Split-Path $PROFILE -Parent) "starship.toml"

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
```

说明：

- `STARSHIP_CONFIG` 指向 `starship.toml`
- `Get-Command starship` 先做存在性判断，避免未安装时启动报错

如果你还没有自己的 `starship.toml`，也可以先保留这段，`starship` 会先按默认配置工作。

## 第 3 步：把 y 接到 yazi

继续在 profile 里加：

```powershell
Set-Alias y yazi
```

这样以后直接输入：

```powershell
y
```

就会进入 `yazi`。

## 第 4 步：把 ls / ll / la 接到 eza

继续在 profile 里加：

```powershell
function Invoke-EzaLs {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first @args
    } else {
        Get-ChildItem @args
    }
}

function Invoke-EzaLl {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first --long --all @args
    } else {
        Get-ChildItem -Force @args
    }
}

function Invoke-EzaLa {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first --all @args
    } else {
        Get-ChildItem -Force @args
    }
}

Set-Alias ls Invoke-EzaLs
Set-Alias ll Invoke-EzaLl
Set-Alias la Invoke-EzaLa
```

这里为什么不用简单的：

```powershell
Set-Alias ls eza
```

原因是你通常还想给 `ll` 和 `la` 固定默认参数，而且需要在 `eza` 不存在时优雅回退到 PowerShell 原生命令。

## 第 5 步：可选，把主题仓库的 loader 接进 profile

如果你已经有这个仓库：

```text
D:\workspace-ai\cli-dev\yazi-theme-presets
```

并且希望 `eza` 使用这套主题里的 `LS_COLORS`，同时让原生 PowerShell 文件列表也有 fallback 配色，就在 profile 里加：

```powershell
$yaziThemePresetsRoot = "D:\workspace-ai\cli-dev\yazi-theme-presets"
$yaziThemeLsColorsLoader = Join-Path $yaziThemePresetsRoot "current\ls-colors.ps1"
$yaziThemePwshLoader = Join-Path $yaziThemePresetsRoot "current\powershell.ps1"

if (Test-Path $yaziThemeLsColorsLoader) {
    . $yaziThemeLsColorsLoader
}

if (Test-Path $yaziThemePwshLoader) {
    . $yaziThemePwshLoader
}
```

作用分别是：

- `current\ls-colors.ps1`：设置 `LS_COLORS`，供 `eza` 使用
- `current\powershell.ps1`：设置 `$PSStyle.FileInfo.*`，作为原生 `Get-ChildItem` 的 fallback 配色

## 第 6 步：应用 profile

保存 profile 后，执行：

```powershell
. $PROFILE
```

或者直接关闭当前终端，再新开一个 PowerShell。

## 第 7 步：验证效果

先验证命令是否都能解析：

```powershell
Get-Command ls
Get-Command ll
Get-Command la
Get-Command y
Get-Command starship
```

再试一下：

```powershell
ls
ll
y
```

你应该能看到：

- `ls` 输出来自 `eza`
- `ll` 是长列表
- `y` 会打开 `yazi`
- prompt 变成 `starship` 风格

## 一个最小可用 profile 示例

如果你想先快速跑起来，可以直接用下面这个最小版本：

```powershell
$env:STARSHIP_CONFIG = Join-Path (Split-Path $PROFILE -Parent) "starship.toml"

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

Set-Alias y yazi

function Invoke-EzaLs {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first @args
    } else {
        Get-ChildItem @args
    }
}

function Invoke-EzaLl {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first --long --all @args
    } else {
        Get-ChildItem -Force @args
    }
}

function Invoke-EzaLa {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        & eza --icons=auto --group-directories-first --all @args
    } else {
        Get-ChildItem -Force @args
    }
}

Set-Alias ls Invoke-EzaLs
Set-Alias ll Invoke-EzaLl
Set-Alias la Invoke-EzaLa
```

## 常见问题

### 1. `ls` 还是 PowerShell 原生输出

检查：

```powershell
Get-Command ls
```

如果没有指向你自己的 alias 或函数，说明 profile 没有正确加载。

先执行：

```powershell
. $PROFILE
```

### 2. `starship` 装了但 prompt 没变

检查：

```powershell
Get-Command starship
Get-Content $PROFILE
```

确认 profile 里有：

```powershell
Invoke-Expression (&starship init powershell)
```

### 3. `y` 找不到

检查：

```powershell
Get-Command yazi
Get-Command y
```

如果 `yazi` 本身存在，但 `y` 不存在，说明 `Set-Alias y yazi` 没被加载。

### 4. `ls` 没图标或者配色不对

先确认：

```powershell
eza --version
```

如果你用了 `yazi-theme-presets` 里的 loader，再检查：

```powershell
$env:LS_COLORS
```

如果切换主题后颜色没变，通常是因为你没有重新开 shell，或者没有重新执行：

```powershell
. $PROFILE
```

## 推荐做法

如果你只是要一个稳的日常终端环境，推荐顺序是：

1. 先把 `starship` 接进 prompt
2. 再把 `y` 接到 `yazi`
3. 再把 `ls/ll/la` 接到 `eza`
4. 最后再接主题仓库里的 loader

这样即使某一步没配好，也容易定位问题。
