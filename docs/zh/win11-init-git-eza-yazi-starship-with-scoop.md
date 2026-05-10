# Win11 上用 Scoop 安装 git / eza / yazi / starship 的完整环境初始化教程

本文面向 Windows 11，目标是用 Scoop 快速搭一套可用的命令行环境，包括：

- `git`
- `eza`
- `yazi`
- `starship`

默认前提：

- 你已经装好了 PowerShell 7
- 你已经装好了 Scoop
- 你已经提前规划好了 Scoop 安装路径

如果还没做这些，先看前一篇：

- [Win11 安装 PowerShell 7.6.1 与 Scoop](./win11-install-powershell-scoop.md)

## 这套工具分别做什么

- `git`：版本管理
- `eza`：替代传统 `ls`
- `yazi`：交互式终端文件管理器
- `starship`：提示符渲染器

这几个工具职责很清楚，不要混在一起理解：

- `eza` 负责目录列表
- `yazi` 负责文件浏览和操作
- `starship` 负责 prompt

## 第 1 步：确认 Scoop 可用

先执行：

```powershell
scoop --version
```

再确认安装路径是不是你预期的：

```powershell
$env:SCOOP
$env:SCOOP_GLOBAL
```

如果这里还是空的，或者指向了 `C:` 盘用户目录，先回去修 Scoop 安装路径，不建议继续往下装。

## 第 2 步：了解 bucket

Scoop 的包来自 bucket。

根据 Scoop 官方说明：

- `main` 是默认 bucket，装 Scoop 时就会带上
- `extras` 是可选 bucket，需要手动添加

对你这次要装的工具，通常可以这样理解：

- `git`：通常在 `main`
- `eza`：通常在 `main`
- `starship`：通常在 `main`
- `yazi`：很多时候在 `extras`

先看你当前有哪些 bucket：

```powershell
scoop bucket list
```

如果还没有 `extras`，先加上：

```powershell
scoop bucket add extras
```

## 第 3 步：可选，先搜索包

如果你想先确认包名，可以这样查：

```powershell
scoop search git
scoop search eza
scoop search yazi
scoop search starship
```

你关心的是这几个最终安装名：

- `git`
- `eza`
- `yazi`
- `starship`

## 第 4 步：安装 git

执行：

```powershell
scoop install git
```

验证：

```powershell
git --version
```

最小初始化建议：

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

如果你只是先把环境搭起来，用户名和邮箱后面再配也可以。

## 第 5 步：安装 eza

执行：

```powershell
scoop install eza
```

验证：

```powershell
eza --version
```

最小试用：

```powershell
eza
eza -la
```

如果你后面要把 `ls` / `ll` 接到 `eza`，通常是在 PowerShell profile 里做函数或别名映射，而不是直接改系统命令。

## 第 6 步：安装 yazi

执行：

```powershell
scoop install yazi
```

如果安装器提示找不到包，通常是因为你还没加 `extras` bucket。

验证：

```powershell
yazi --version
```

最小试用：

```powershell
yazi
```

如果你需要文件预览能力，后续通常还会补一些外围工具，但这不影响 `yazi` 先跑起来。

## 第 7 步：安装 starship

执行：

```powershell
scoop install starship
```

验证：

```powershell
starship --version
```

## 第 8 步：把 starship 接入 PowerShell

先确认 PowerShell profile 路径：

```powershell
$PROFILE
```

如果 profile 所在目录不存在，先创建：

```powershell
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $PROFILE) | Out-Null
```

如果 profile 文件不存在，先创建：

```powershell
New-Item -ItemType File -Force -Path $PROFILE | Out-Null
```

然后把下面两行加到 profile：

```powershell
$env:STARSHIP_CONFIG = Join-Path (Split-Path $PROFILE -Parent) "starship.toml"
Invoke-Expression (&starship init powershell)
```

如果你暂时没有自定义 `starship.toml`，`starship` 也能先按默认配置工作。

重新打开一个 PowerShell，或者执行：

```powershell
. $PROFILE
```

## 第 9 步：做一轮整体验证

逐个验证：

```powershell
git --version
eza --version
yazi --version
starship --version
```

再做一个实际检查：

```powershell
eza -la
yazi
```

如果你已经把 `starship` 接入 profile，新开的 shell 里应该能看到 prompt 样式变化。

## 推荐的安装顺序

建议顺序如下：

1. `git`
2. `eza`
3. `yazi`
4. `starship`

原因很简单：

- `git` 是很多后续操作的基础
- `eza` 和 `yazi` 是目录与文件工作流
- `starship` 是最后做 UI 层收尾

## 常见问题

### 1. `scoop install yazi` 找不到包

先检查：

```powershell
scoop bucket list
```

如果没有 `extras`，执行：

```powershell
scoop bucket add extras
```

再重试安装。

### 2. 命令装完了，但新终端里找不到

先关掉当前终端，再新开一个。

如果还是不行，检查：

```powershell
where.exe git
where.exe eza
where.exe yazi
where.exe starship
```

### 3. `starship` 装好了，但 prompt 没变化

通常是 profile 没有加载。

检查：

```powershell
$PROFILE
Get-Content $PROFILE
```

确认里面有：

```powershell
Invoke-Expression (&starship init powershell)
```

### 4. `yazi` 能打开，但预览功能不完整

这通常不是 `yazi` 主程序没装好，而是你还没补外围依赖。  
先确认 `yazi --version` 正常，再决定是否补图片、压缩包、语法高亮等预览支持。

## 一个常见的初始化命令序列

如果你的 Scoop 已经装好，而且路径已经规划好，通常可以这样做：

```powershell
scoop bucket add extras
scoop install git
scoop install eza
scoop install yazi
scoop install starship
```

然后再配置 profile。

## 官方来源

- Scoop 官方仓库  
  https://github.com/ScoopInstaller/Scoop
- Scoop Main bucket  
  https://github.com/ScoopInstaller/Main
- Scoop Extras bucket  
  https://github.com/ScoopInstaller/Extras
- Scoop bucket 说明  
  https://github.com/ScoopInstaller/Scoop/wiki/Buckets

## 校验时间

本文中的安装方式已按 `2026-05-10` 核对。
