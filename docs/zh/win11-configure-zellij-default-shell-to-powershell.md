# Win11 上把 Zellij 默认 shell 配成 PowerShell 7

这篇文档解决一个很实际的问题：

你已经装好了 `zellij`，但打开以后发现默认进去的是 `cmd`，而不是 PowerShell 7。

如果你现在的工作流主要建立在 PowerShell 上，这个设置最好尽快改掉。

## 为什么建议改成 PowerShell 7

因为你当前很多工作流能力都在 PowerShell 层：

- `ls / ll / la -> eza`
- `y -> yazi`
- `STARSHIP_CONFIG`
- `LS_COLORS`
- `EZA_CONFIG_DIR`
- `$PROFILE` 里的别名、函数和接线逻辑

如果 `zellij` 默认进去的是 `cmd`，那你会发现：

- `ls` 不一定是你想要的行为
- `ll` 可能不存在
- `y` 也不一定存在
- `starship` 的 PowerShell 接线用不上

所以如果你的主工作 shell 是 PowerShell，`zellij` 的默认 shell 也应该改成 PowerShell。

## 先理解一下关系

大致关系是：

```text
Windows Terminal / WezTerm / Ghostty
    -> zellij
        -> PowerShell
```

这里：

- terminal：负责窗口和显示
- `zellij`：负责会话和 pane / tab 组织
- PowerShell：负责真正的 shell 行为

所以你现在要改的，不是 terminal，也不是 PowerShell 本身，而是：

- `zellij` 默认启动哪个 shell

## 配置文件在哪

在 Windows 上，你当前机器的 `zellij` 配置文件是：

```text
C:\Users\Administrator\AppData\Roaming\Zellij\config\config.kdl
```

更通用一点的写法是：

```text
%AppData%\Zellij\config\config.kdl
```

你可以在 PowerShell 里直接打开目录：

```powershell
explorer "$env:APPDATA\Zellij\config"
```

## 要改哪一项

`zellij` 官方提供了 `default_shell` 这个选项，用来指定：

- 新 pane 默认打开哪个 shell

最稳的写法是直接指定 PowerShell 7 的绝对路径。

例如：

```kdl
default_shell "E:\\Program Files\\PowerShell\\7\\pwsh.exe"
```

## 为什么推荐绝对路径

虽然你也可以写：

```kdl
default_shell "pwsh"
```

但在 Windows 上更稳的方式还是绝对路径，因为它避免这些问题：

- PATH 解析歧义
- 多版本 PowerShell 并存
- 某些环境下 `pwsh` 没有正确进 PATH

所以推荐用：

```kdl
default_shell "E:\\Program Files\\PowerShell\\7\\pwsh.exe"
```

## 具体修改步骤

### 第 1 步：打开配置文件

你可以用任意编辑器打开：

```powershell
notepad "$env:APPDATA\Zellij\config\config.kdl"
```

### 第 2 步：找到 `default_shell`

很多默认配置里，这一行可能是注释状态，例如：

```kdl
// default_shell "fish"
```

把它改成：

```kdl
default_shell "E:\\Program Files\\PowerShell\\7\\pwsh.exe"
```

### 第 3 步：保存文件

保存后退出编辑器。

## 怎么验证是否生效

### 方法 1：重新打开 zellij

完全退出当前 `zellij`，然后重新执行：

```powershell
zellij
```

再新建一个 pane。

如果新 pane 直接进入 PowerShell，就说明已经生效。

### 方法 2：直接看 PowerShell 版本

在新 pane 里执行：

```powershell
$PSVersionTable.PSVersion
```

如果能正常输出版本对象，就说明当前 shell 已经是 PowerShell。

### 方法 3：确认可执行路径

你也可以执行：

```powershell
Get-Command pwsh
```

确认当前系统里的 PowerShell 7 路径是不是你配置的那一个。

## 如果还是进 `cmd` 怎么办

先排查这几件事：

### 1. 你是不是没有完全重开 zellij

有些旧 pane 会保留旧环境。  
先彻底退出，再重新执行：

```powershell
zellij
```

### 2. 配置文件是不是改错位置了

确认你改的是：

```text
%AppData%\Zellij\config\config.kdl
```

而不是别的同名文件。

### 3. PowerShell 7 路径是不是写错了

先执行：

```powershell
Get-Command pwsh | Select-Object -ExpandProperty Source
```

把真实路径和 `config.kdl` 里的路径对一下。

## 这一步配置完成后，你能得到什么

配置完成以后，`zellij` 里的新 pane 会默认进入 PowerShell 7。

这意味着你当前这些能力会自然接上：

- `ls / ll / la`
- `y`
- `starship`
- `LS_COLORS`
- `EZA_CONFIG_DIR`
- `$PROFILE`

也就是说，`zellij` 不再是“开出来一个和你平时工作流脱节的环境”，而是你当前 PowerShell 环境的自然延伸。
