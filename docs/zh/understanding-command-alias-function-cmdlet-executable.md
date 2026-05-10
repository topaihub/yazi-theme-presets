# 理解命令名、alias、function、cmdlet、executable 分别是什么

这篇文档回答一个很常见的问题：

当你输入一个命令时，真正运行的到底是谁？

比如：

- `ls`
- `ll`
- `eza`
- `y`
- `starship`

它们看起来都像“命令”，但本质并不一样。

## 一句话先讲清楚

在命令行里，你输入的是**命令名**。  
但命令名背后，真正被执行的对象可能是：

- alias
- function
- cmdlet
- script
- executable

所以“你输入的名字”和“真正执行的本体”经常不是同一个东西。

## 第 1 层：命令名

你在终端里输入的：

```powershell
ls
ll
eza
y
git
```

这些首先只是“名字”。

shell 收到这个名字以后，才会去解析：

- 这是 alias 吗？
- 这是 function 吗？
- 这是 cmdlet 吗？
- 这是脚本吗？
- 这是 PATH 里的可执行文件吗？

所以命令名只是入口，不一定是本体。

## alias 是什么

alias 就是“别名”。

它不是程序本体，只是把一个短名字映射到另一个命令名。

例如在原生 PowerShell 里：

```powershell
ls
```

通常是：

```powershell
ls -> Get-ChildItem
```

也就是说：

- 你输入的是 `ls`
- 真正调用的是 `Get-ChildItem`

所以 `ls` 在 PowerShell 里通常不是程序，而是 alias。

你可以查看：

```powershell
Get-Command ls
```

## function 是什么

function 是 shell 里定义的一段命令逻辑。

它比 alias 更强，因为它可以：

- 带参数
- 写条件判断
- 写回退逻辑
- 组合多个命令

例如你现在这套环境里：

- `Invoke-EzaLs`
- `Invoke-EzaLl`
- `Invoke-EzaLa`

就是 function。

它们大致做的是：

- 如果有 `eza`，就调用 `eza`
- 如果没有 `eza`，就回退到 `Get-ChildItem`

然后你再用 alias 把：

- `ls` -> `Invoke-EzaLs`
- `ll` -> `Invoke-EzaLl`

所以这里的链路其实是：

```text
ls -> alias -> function -> eza
```

## cmdlet 是什么

cmdlet 是 PowerShell 内建或模块提供的“原生命令对象”。

例如：

```powershell
Get-ChildItem
Get-Command
Set-Alias
```

这些都属于 cmdlet。

它们和传统 shell 命令的最大区别是：

- cmdlet 处理的是对象
- 不是单纯的文本

例如 `Get-ChildItem` 返回的是文件对象，不只是打印一段文字。

所以在 PowerShell 里：

- `ls` 常常只是 alias
- `Get-ChildItem` 才是更底层的 PowerShell cmdlet

## executable 是什么

executable 就是真正的可执行程序，比如：

- `eza.exe`
- `yazi.exe`
- `git.exe`
- `starship.exe`

这类命令通常在 PATH 里，shell 找到它以后就直接启动程序。

例如：

```powershell
eza --version
yazi --version
git --version
starship --version
```

这些背后运行的就是实际的可执行文件。

你可以查看：

```powershell
Get-Command eza
Get-Command yazi
Get-Command git
Get-Command starship
```

## script 是什么

script 就是脚本文件。

比如：

- `.ps1`
- `.cmd`
- `.bat`

它们不是别名，也不是单个可执行程序，而是一段脚本内容。

例如你仓库里的这些：

- `apply-theme.ps1`
- `apply-starship.ps1`
- `apply-terminal-theme.ps1`

都属于脚本。

## 用你当前环境举例

### `ls`

在你当前 PowerShell 配置里：

```text
ls -> alias -> Invoke-EzaLs -> eza
```

所以：

- 输入名：`ls`
- 直接解析对象：alias
- 中间执行对象：function
- 最终程序本体：`eza`

如果你把映射去掉，原生 PowerShell 里通常会回到：

```text
ls -> alias -> Get-ChildItem
```

这时最终本体就不是 `eza`，而是 PowerShell cmdlet。

### `ll`

在很多原生 PowerShell 环境里：

- `ll` 默认可能根本不存在

在你当前环境里：

```text
ll -> alias -> Invoke-EzaLl -> eza
```

### `y`

现在通常是：

```text
y -> alias -> yazi
```

这里：

- `y` 是 alias
- `yazi` 是 executable

### `starship`

这里稍微特殊一点。

`starship` 也是 executable，但它在工作流里的角色和 `eza` / `yazi` 不太一样。

它通常不是你为了“处理目录”或“操作文件”主动运行的，而是：

- shell 启动时
- prompt 渲染时

由 shell 或 profile 间接调用。

所以它是：

- executable
- 但角色更像“被 shell 嵌入调用的辅助工具”

## 为什么这件事重要

因为很多配置问题，都是卡在“你以为改的是本体，其实改的是入口名”。

例如：

- 你改了 `ls`
  - 可能只是改了 alias
- 你改了 `Invoke-EzaLs`
  - 是改了 function
- 你升级了 `eza.exe`
  - 才是改了最终程序本体

如果你不区分这几层，就很容易误判问题在哪。

## 怎么查一个命令到底是什么

最常用的方法：

```powershell
Get-Command ls
Get-Command ll
Get-Command eza
Get-Command y
Get-Command starship
```

PowerShell 会告诉你它是什么类型，例如：

- Alias
- Function
- Cmdlet
- Application

这一步非常关键。

## 一个实用判断方法

当你看到一个命令时，按这个顺序问自己：

1. 这是我输入的名字吗？
2. 它是 alias 吗？
3. 它背后是不是 function？
4. 它最后落到 cmdlet 还是 executable？

只要你把这条链路想清楚，大多数“为什么这个命令行为和我想的不一样”的问题都会简单很多。
