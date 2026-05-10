# 理解 shell、terminal、命令工具、主题和启动配置的分层关系

这篇文档不教你装某个具体工具，而是解释一个更底层的问题：

为什么你改了一个地方，另一个地方却没有变化？

如果你已经开始同时使用下面几层东西：

- terminal：Windows Terminal
- shell：PowerShell、`cmd`
- 用户直接调用的工具：`eza`、`yazi`
- 被 shell 嵌入调用的辅助工具：`starship`

那你迟早会遇到这个问题。

原因通常不是工具坏了，而是你改的是**另一层**。

## 一句话先讲清楚

命令行环境不是一个东西，而是几层叠在一起：

1. terminal
2. shell
3. command-line tool
4. theme / color system
5. startup / profile configuration

这几层不是同一个东西，也不会自动彼此同步。

可以先用一张最简单的层级图来理解：

```text
Terminal
├─ Windows Terminal
└─ WezTerm

Shell
├─ PowerShell
├─ cmd
├─ nushell
├─ bash
├─ zsh
└─ fish

Tools
├─ eza
├─ yazi
├─ git
└─ starship
```

运行关系通常是：

```text
Windows Terminal / WezTerm
    -> PowerShell / cmd / nushell / bash / zsh / fish
        -> eza / yazi / git / starship
```

这意味着：

- `Windows Terminal` 和 `WezTerm` 是同级
- `PowerShell`、`cmd`、`nushell`、`bash`、`zsh`、`fish` 是同级
- `eza`、`yazi`、`git`、`starship` 是被 shell 调用的工具

## 第 1 层：terminal

在 Windows 11 里，你现在最常见的 terminal 是：

- Windows Terminal

terminal 负责的是：

- 窗口
- 标签页
- 字体
- 光标
- 背景色
- 16 色调色板
- ANSI 颜色显示

terminal **不负责**：

- `ls` 是什么命令
- prompt 怎么拼出来
- `y` 为什么能打开 `yazi`

所以如果你改的是 Windows Terminal 的 `settings.json`，你改到的是“显示容器”这一层。

## 第 2 层：shell

常见的 shell 包括：

- PowerShell
- `cmd`
- `nushell`
- `bash`
- `zsh`
- `fish`

shell 负责的是：

- 解析命令
- 处理别名、函数、宏
- 管理环境变量
- 决定启动时加载哪些配置

例如：

- PowerShell 里的 `$PROFILE`
- `cmd` 里的 `doskey`

这些都属于 shell 层。

最重要的一点：

- PowerShell、`cmd`、`nushell`、`bash`、`zsh`、`fish` 都是不同的 shell
- 它们不会自动共享别名和函数

所以：

- 你在 PowerShell 里把 `ls` 接到 `eza`
- 不代表 `cmd` 里也会自动这样做

## 第 3 层：command-line tool

这层是由 shell 调用的外部工具，但它内部还可以再分两类：

### 3.1 用户直接调用的工具

- `eza`
- `yazi`
- `git`
- `rg`
- `fd`

这些工具通常是你主动输入命令来运行的。

例如：

- `eza` 负责目录列表
- `yazi` 负责交互式文件管理
- `git` 负责版本管理

### 3.2 被 shell 嵌入调用的辅助工具

- `starship`

这类工具通常也是独立可执行程序，但它们更常见的运行方式不是“你主动敲命令来完成业务动作”，而是被 shell 或启动配置拿来做某个局部能力。

对 `starship` 来说，这个能力就是：

- 生成 prompt

所以：

- `starship` 也是外部工具
- 但它的角色更像“被 shell 使用的提示符生成器”
- 而不是你日常主动调用来处理文件或目录的工具

例如：

- `starship` 负责 prompt 渲染

它们之间也不会自动同步主题或行为。

## 第 4 层：theme / color system

这是最容易混淆的一层。

你现在这套环境里，至少有这些配色来源：

- Windows Terminal color scheme
- `starship.toml`
- `yazi theme.toml`
- `LS_COLORS`
- `eza theme.yml`
- PowerShell `$PSStyle.FileInfo.*`

它们分别控制不同区域：

- terminal scheme：背景、前景、ANSI 16 色
- `starship.toml`：prompt
- `yazi theme.toml`：Yazi 界面
- `LS_COLORS`：文件类型色
- `eza theme.yml`：`eza` 的日期、大小、权限、表头等元数据
- `$PSStyle.FileInfo.*`：PowerShell 原生文件列表 fallback

所以你不能期待：

- 改了 `starship.toml`，`ls` 颜色也自动变
- 改了 `LS_COLORS`，prompt 也自动变

它们控制的是不同区域。

## 第 5 层：startup / profile configuration

这一层负责“把上面几层串起来”。

在你现在的环境里，这一层包括：

- PowerShell `$PROFILE`
- `cmd` 的 `doskey`
- Windows Terminal profile 配置

这层的职责是：

- shell 启动时加载什么
- 设置哪些环境变量
- 建哪些别名和函数
- 把主题文件接到实际工具上

比如你现在的 PowerShell profile 做了这些事：

- 把 `ls` / `ll` / `la` 接到 `eza`
- 把 `y` 接到 `yazi`
- 加载 `starship`
- 加载 `LS_COLORS`
- 设置 `EZA_CONFIG_DIR`

这些都不属于 terminal，也不属于 `eza` 自己，而是“启动配置层”在做接线。

## 一个实际例子：为什么 PowerShell 里 `ls` 和 `cmd` 里 `ls` 不一样

原因是它们经过的层不同。

### 在 PowerShell 里

流程大概是：

1. 你输入 `ls`
2. PowerShell 查 alias / function
3. `ls` 被映射到 `Invoke-EzaLs`
4. `Invoke-EzaLs` 再去调用 `eza`
5. `eza` 读取：
   - `LS_COLORS`
   - `EZA_CONFIG_DIR`
6. Windows Terminal 负责把颜色显示出来

### 在 `cmd` 里

默认流程是：

1. 你输入 `ls`
2. `cmd` 没有 PowerShell 的 alias/function
3. 如果没有额外配置，`ls` 不一定存在

如果你给 `cmd` 配了：

```cmd
doskey ls=eza --icons=auto --group-directories-first $*
```

那流程才会变成：

1. 你输入 `ls`
2. `cmd` 用 `doskey` 展开成 `eza ...`
3. `eza` 再按自己的主题和环境变量渲染

这时候它才会接近 PowerShell 的效果。

## 为什么“同一个主题”往往需要每个工具都各配一份

这是因为每个工具理解主题的方式不同。

例如 `tokyo-night` 在你当前仓库里就分成多份：

- `themes/tokyo-night/theme.toml`
- `starship/tokyo-night.toml`
- `ls-colors/tokyo-night-ls-colors.ps1`
- `eza/tokyo-night-theme.yml`
- `powershell/tokyo-night-fileinfo.ps1`

它们共同表达的是“同一套视觉风格”，但不是同一个文件。

所以更准确的说法不是：

- 一个主题文件给所有工具用

而是：

- 一个主题风格，需要按工具分别实现

## 怎么判断一个问题属于哪一层

你可以这样排查：

### 1. 看起来不对，是不是 terminal 层？

例如：

- 背景色不对
- 字体不对
- 光标样式不对

先看 Windows Terminal。

### 2. 命令行为不对，是不是 shell 层？

例如：

- `ls` 没走 `eza`
- `y` 找不到
- 新 shell 没有加载配置

先看 PowerShell profile 或 `cmd` 宏。

### 3. 输出内容不对，是不是工具层？

例如：

- `eza` 没有 long listing
- `yazi` 无法预览
- `git` 子命令不工作

先看对应工具本身。

### 4. 颜色不对，是不是 theme 层？

例如：

- prompt 时间颜色奇怪
- `ll` 的日期颜色和整体风格不匹配
- Yazi 的目录色不一致

先看对应的主题文件，不要先改 shell。

### 5. 配置明明写了，但不生效，是不是 startup 层？

例如：

- 文件改了，但新终端没变
- 环境变量应该有，但实际没有

先看 profile / autorun / shell 启动逻辑。

## 你现在这套环境的实际分工

按当前仓库的约定，大致可以拆成这样：

- terminal 层
  - Windows Terminal
  - 负责终端窗口和底层 ANSI 颜色表现
- shell 层
  - PowerShell
  - `cmd`
  - 负责启动、别名、函数、宏、环境变量
- tool 层
  - `eza`
  - `yazi`
  - `starship`
  - 其中 `eza` / `yazi` 更偏向用户主动调用
  - `starship` 更偏向被 shell 嵌入调用
- theme 层
  - `LS_COLORS`
  - `eza theme.yml`
  - PowerShell file info theme
  - 分别负责文件类型颜色、元数据颜色和 fallback 颜色

## 最后一个核心判断

如果你以后再遇到“为什么没变化”，先不要马上怀疑工具坏了。

先问自己两个问题：

1. 我改的是哪一层？
2. 我看到的问题属于哪一层？

只要这两个问题答清楚，大多数命令行配置问题都会简单很多。
