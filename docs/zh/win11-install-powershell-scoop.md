# Win11 安装 PowerShell 7.6.1 与 Scoop

本文面向 Windows 11，目标是：

1. 安装 PowerShell 7.6.1
2. 安装 Scoop
3. 验证 `pwsh` 和 `scoop` 可以正常使用

## 先说明两个事实

- Windows 11 自带的是 Windows PowerShell 5.1，不是 PowerShell 7
- 安装 PowerShell 7 后，PowerShell 5.1 不会被替换，二者会并存

也就是说，你完全可以先用系统自带的 PowerShell 5.1 来安装 PowerShell 7.6.1 和 Scoop。

## 第 1 步：打开终端

任选一种：

- 开始菜单搜索 `PowerShell`
- 开始菜单搜索 `Windows Terminal`
- `Win + X` 后打开终端

如果你现在还没有 `pwsh` 命令，这是正常的，因为 PowerShell 7 还没装。

## 第 2 步：安装 PowerShell 7.6.1

### 方案 A：安装“精确版本” 7.6.1

如果你的目标是明确安装 `7.6.1`，最稳的方式是直接使用官方 MSI 安装包。

打开 PowerShell 5.1，执行：

```powershell
winget install --id Microsoft.PowerShell --version 7.6.1.0 --source winget
```

如果你的 `winget` 没有提供这个精确版本，改用官方发布页下载 MSI：

1. 打开官方发布页
2. 找到 `v7.6.1`
3. 下载对应架构的安装包：
   - 大多数 Win11 电脑选 `PowerShell-7.6.1-win-x64.msi`
   - ARM 设备选 `PowerShell-7.6.1-win-arm64.msi`
4. 双击安装

安装完成后，重新打开一个终端。

### 方案 B：安装最新稳定版

如果你不要求必须是 `7.6.1`，微软在 Windows 客户端上推荐用 `winget` 安装最新稳定版：

```powershell
winget install --id Microsoft.PowerShell --source winget
```

注意：这个命令装的是“当前最新稳定版”，不保证永远是 `7.6.1`。

## 第 3 步：验证 PowerShell 7

重新打开终端，执行：

```powershell
pwsh
```

再执行：

```powershell
$PSVersionTable.PSVersion
```

如果你安装的是本文目标版本，应该看到主版本为 `7`，并且版本号为 `7.6.1`。

也可以直接执行：

```powershell
pwsh -v
```

预期输出类似：

```text
PowerShell 7.6.1
```

## 第 4 步：先规划 Scoop 安装路径

这一步很重要。

如果你直接运行 Scoop 安装脚本，而不提前指定路径，Scoop 默认会装到当前用户目录，通常就是：

```text
C:\Users\<你的用户名>\scoop
```

如果你不希望开发工具默认堆在 `C:`，就应该在安装前先把路径定好。

一个更常见也更干净的做法是：

- 用户级程序：放到 `D:\Applications\Scoop`
- 全局程序：放到 `D:\Applications\ScoopGlobal`

你可以按自己的习惯改，但**必须在安装前设置**。

先执行：

```powershell
$env:SCOOP = 'D:\Applications\Scoop'
$env:SCOOP_GLOBAL = 'D:\Applications\ScoopGlobal'
```

为了让这两个路径以后也一直生效，再执行：

```powershell
[Environment]::SetEnvironmentVariable('SCOOP', 'D:\Applications\Scoop', 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', 'D:\Applications\ScoopGlobal', 'User')
```

如果目录还不存在，可以先创建：

```powershell
New-Item -ItemType Directory -Force -Path 'D:\Applications\Scoop' | Out-Null
New-Item -ItemType Directory -Force -Path 'D:\Applications\ScoopGlobal' | Out-Null
```

## 第 5 步：安装 Scoop

建议在普通用户权限的 PowerShell 里安装，不要先用管理员终端。

如果你已经进入 `pwsh`，就直接在 PowerShell 7 里执行下面两条命令：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

更短的写法也可以：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

安装成功后，关闭当前终端，再重新打开一个新终端。

## 第 6 步：验证 Scoop

执行：

```powershell
scoop --version
```

再执行：

```powershell
scoop help
```

如果都能正常输出，说明 Scoop 已经装好了。

先确认安装目录是不是你指定的路径：

```powershell
$env:SCOOP
$env:SCOOP_GLOBAL
```

预期类似：

```text
D:\Applications\Scoop
D:\Applications\ScoopGlobal
```

再检查实际目录：

```powershell
Get-ChildItem D:\Applications\Scoop
```

## 第 7 步：做一个最小可用测试

你可以用 Scoop 装一个常见工具测试，例如：

```powershell
scoop install git
```

或者：

```powershell
scoop install eza
```

安装后验证：

```powershell
git --version
eza --version
```

## 常见问题

### 1. `pwsh` 找不到

先关掉当前终端，再新开一个。

如果还是不行，确认 PowerShell 7 安装是否完成，再检查：

```powershell
where.exe pwsh
```

### 2. `scoop` 找不到

同样先重开终端。

如果还是不行，检查用户目录下是否生成了 Scoop：

```powershell
Test-Path "$HOME\scoop"
```

如果你是自定义路径安装，更应该检查你指定的目录，例如：

```powershell
Test-Path 'D:\Applications\Scoop'
```

### 3. 执行策略报错

如果看到脚本执行被禁止，重新执行：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

这会只修改当前用户范围，不会改全局机器策略。

### 4. `winget` 找不到

Windows 11 通常自带 `winget`。如果没有，先检查 Microsoft App Installer 是否可用，再考虑从微软渠道补装。

如果你只是想装精确版本 `7.6.1`，也可以直接走 PowerShell 官方 GitHub 发布页下载 MSI。

### 5. Scoop 被装到了 `C:` 盘

这通常是因为你在运行安装脚本之前，没有先设置：

```powershell
$env:SCOOP
$env:SCOOP_GLOBAL
```

也没有把它们写入用户环境变量。

正确顺序是：

1. 先确定路径
2. 先设置 `SCOOP` 和 `SCOOP_GLOBAL`
3. 再执行 Scoop 安装脚本

## 推荐顺序

如果你想少折腾，推荐顺序是：

1. 用系统自带 PowerShell 打开终端
2. 用 `winget` 或官方 MSI 安装 PowerShell 7.6.1
3. 进入 `pwsh`
4. 先设置 Scoop 安装路径
5. 在 `pwsh` 里安装 Scoop
6. 用 Scoop 装后续工具

## 官方来源

- PowerShell Windows 安装文档（Microsoft Learn）  
  https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.6
- PowerShell `v7.6.1` 官方发布页（GitHub）  
  https://github.com/PowerShell/PowerShell/releases/tag/v7.6.1
- Scoop 官方仓库（GitHub）  
  https://github.com/ScoopInstaller/Scoop
- Scoop 安装器仓库（GitHub）  
  https://github.com/ScoopInstaller/Install

## 校验时间

本文中的版本和安装方式已按 `2026-05-10` 核对。
