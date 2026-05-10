# 按操作系统理解 terminal、shell 和 tools 的对应关系

这篇文档专门回答一个问题：

不同操作系统里，terminal、shell 和 tools 通常分别是什么？

很多人刚接触命令行时，会把这些概念混在一起：

- 以为 PowerShell 是 terminal
- 以为 WezTerm 是 shell
- 以为 `eza` 和 PowerShell 是同一层

其实这几类东西在不同操作系统里都分别存在，只是默认组合不同。

## 先讲通用分层

无论是 Windows、macOS 还是 Linux，通常都可以拆成四层：

1. terminal
2. mux
3. shell
4. tools

关系通常是：

```text
terminal
    -> mux
        -> shell
            -> tools
```

例如：

```text
Windows Terminal
    -> tmux / zellij
        -> PowerShell
            -> eza / yazi / git / starship
```

或者：

```text
WezTerm
    -> tmux / zellij
        -> zsh
            -> eza / yazi / git / starship
```

## 第 1 类：Windows

### 常见 terminal

- Windows Terminal
- WezTerm
- Ghostty
- Alacritty
- ConEmu
- 传统控制台窗口

### 常见 mux

- `tmux`
- `zellij`

### 常见 shell

- PowerShell
- `cmd`
- `nushell`
- Git Bash
- WSL 里的 bash / zsh / fish

### 常见 tools

- `eza`
- `yazi`
- `git`
- `starship`
- `rg`
- `fd`
- `bat`

### Windows 上最常见的关系

```text
Windows Terminal
    -> tmux / zellij
        -> PowerShell
            -> eza / yazi / git / starship
```

也可能是：

```text
Windows Terminal
    -> cmd
        -> eza / git
```

或者：

```text
WezTerm
    -> zellij
        -> nushell
            -> eza / yazi / git / starship
```

### Windows 的特点

- terminal 和 shell 通常是分开的
- terminal 和 mux 也不是一回事
- PowerShell 是 shell，不是 terminal
- `cmd` 也是 shell，不是 terminal
- Windows Terminal / WezTerm / Ghostty 只是承载 shell 的外壳
- `tmux` / `zellij` 更像 terminal 和 shell 之间的会话复用层
- 很多工具通过 Scoop、winget、MSI 或 GitHub release 安装

## 第 2 类：macOS

### 常见 terminal

- Terminal.app
- iTerm2
- WezTerm
- Ghostty
- Alacritty
- Kitty

### 常见 mux

- `tmux`
- `zellij`

### 常见 shell

- `zsh`
- `bash`
- `fish`
- `nushell`
- PowerShell

### 常见 tools

- `eza`
- `yazi`
- `git`
- `starship`
- `rg`
- `fd`
- `bat`

### macOS 上最常见的关系

```text
iTerm2
    -> tmux
        -> zsh
            -> eza / yazi / git / starship
```

或者：

```text
Terminal.app
    -> zsh
        -> git / rg / fd
```

### macOS 的特点

- `zsh` 是近年默认 shell
- iTerm2 是非常常见的 terminal
- Ghostty 近年也很受关注，本质上仍然是 terminal
- Homebrew 是最常见的工具安装方式
- terminal、mux、shell 也不是一回事，只是很多用户长期把它们连在一起使用，所以容易误以为是一体的

## 第 3 类：Linux

### 常见 terminal

- GNOME Terminal
- Konsole
- Alacritty
- Kitty
- WezTerm
- Ghostty
- xterm

### 常见 mux

- `tmux`
- `zellij`

### 常见 shell

- `bash`
- `zsh`
- `fish`
- `nushell`
- PowerShell

### 常见 tools

- `eza`
- `yazi`
- `git`
- `starship`
- `rg`
- `fd`
- `bat`

### Linux 上最常见的关系

```text
GNOME Terminal
    -> tmux
        -> bash
            -> eza / yazi / git / starship
```

或者：

```text
Kitty
    -> zellij
        -> zsh
            -> eza / yazi / git / starship
```

### Linux 的特点

- shell 选择很多
- terminal 选择也很多
- mux 选择也很多
- 组合非常自由
- 包管理方式会因发行版不同而不同

## 为什么同一个工具能跨系统出现

像这些工具：

- `eza`
- `yazi`
- `git`
- `starship`

本质上都是独立工具，只要它们支持对应平台，就可以被不同 shell 调用。

所以你会看到：

- Windows Terminal + PowerShell + `eza`
- iTerm2 + zsh + `eza`
- GNOME Terminal + bash + `eza`

它们的 tool 是同一个，但 terminal 和 shell 可以完全不同。

## 为什么很多人会混淆

因为在日常使用里，用户看到的是“一个黑窗口”，所以很容易把：

- terminal
- mux
- shell
- tool

都混成一个整体。

例如：

- 打开 iTerm2
- 里面默认就是 zsh
- 于是很多人会说“我在 zsh 里打开了 iTerm2”

其实更完整的关系是：

```text
iTerm2 -> tmux -> zsh -> tools
```

不是一层东西。

## 一个最简单的判断方法

如果你想判断某个东西属于哪一层，可以这样问：

### 1. 它负责“窗口、标签页、字体、颜色方案”吗？

如果是，通常是 terminal。

例如：

- Windows Terminal
- WezTerm
- iTerm2
- Ghostty

### 2. 它负责“session、pane、attach/detach、长任务保活”吗？

如果是，通常是 mux。

例如：

- `tmux`
- `zellij`

### 3. 它负责“解析命令、加载 profile、管理别名/函数/环境变量”吗？

如果是，通常是 shell。

例如：

- PowerShell
- `cmd`
- `bash`
- `zsh`

### 4. 它负责“完成具体任务”，比如列目录、管 Git、浏览文件吗？

如果是，通常是 tool。

例如：

- `eza`
- `yazi`
- `git`
- `rg`

## 结合你当前仓库的实际环境

你现在这个仓库主要对应的是 Windows 场景：

```text
Windows Terminal / WezTerm / Ghostty
    -> tmux / zellij
        -> PowerShell / cmd / nushell
            -> eza / yazi / git / starship
```

其中：

- terminal 层：Windows Terminal、WezTerm、Ghostty
- mux 层：`tmux`、`zellij`
- shell 层：PowerShell、`cmd`、`nushell`
- tool 层：`eza`、`yazi`、`git`、`starship`

所以后面你在整理主题、profile、命令映射时，就可以更清楚地知道自己改的是哪一层。
