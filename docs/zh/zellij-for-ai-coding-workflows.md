# Zellij 使用教程：面向 AI 编程工作流的入门与使用场景

这篇文档面向一种很具体的使用场景：

你现在大量工作都在用 AI 编程，希望命令行工作区更稳、更好切换、更适合同时跑多个任务。

如果你以前几乎没用过 `zellij`，最容易遇到的问题不是“不会按快捷键”，而是：

- 不知道它解决什么问题
- 不知道什么时候值得开它
- 不知道它和 Windows Terminal / PowerShell / `eza` / `yazi` 的关系

这篇文档就按这个顺序来讲。

## 一句话先说清楚：zellij 是什么

`zellij` 是一个 **terminal multiplexer**，也就是“终端复用器”。

它不是：

- terminal
- shell
- 普通命令工具

它更像是 terminal 和 shell 之间的一层会话管理环境。

大致关系可以理解成：

```text
Windows Terminal / WezTerm / Ghostty
    -> zellij
        -> PowerShell / bash / nushell
            -> eza / yazi / git / starship / AI tools
```

## 它解决什么问题

如果你只是偶尔开一个终端跑一条命令，那 `zellij` 价值不大。

但在 AI 编程场景下，你很容易同时做这些事：

- 一个 pane 里跑项目服务
- 一个 pane 里跑测试
- 一个 pane 里跑 AI agent / codex / claude-code / 其他 CLI
- 一个 pane 里看日志
- 一个 pane 里做 Git 操作

这时候普通 terminal 的问题会很明显：

- 窗口太多
- 上下文容易乱
- 关错窗口就没了
- 长任务不容易保留
- 每次重新打开都要重新排版

`zellij` 解决的就是这些问题：

- 一个终端里拆多个 pane
- 会话可保留
- 工作区更稳定
- 更适合“多进程并行开发”

## 为什么 AI 编程场景特别适合它

AI 编程有一个特点：

你很少只做一件事。

典型工作区可能长这样：

- pane 1：代码目录 / shell
- pane 2：测试命令
- pane 3：本地 dev server
- pane 4：AI agent CLI
- pane 5：日志或 Git

如果不用 mux，你通常会：

- 多开标签页
- 多开窗口
- 来回切

能做，但很散。

如果用 `zellij`，你可以把这整套东西固定成一个 workspace。

对 AI 编程来说，最有价值的不是“它很酷”，而是：

- 并行任务更清楚
- 当前上下文不容易丢
- 很适合边跑边看边改

## 先别背快捷键，先建立正确心智模型

你可以先把 `zellij` 理解成：

- 一个“终端里的工作区管理器”

里面最核心的几个概念是：

### 1. session

一个 session 就是一整套工作区状态。

你可以把它理解成：

- 一个项目的命令行工作空间

例如：

- `blog-dev`
- `api-dev`
- `agent-lab`

每个 session 都可以包含自己的标签页和 pane。

### 2. tab

tab 类似“同一个 session 里的不同页面”。

例如一个项目里，你可以有：

- `editor`
- `server`
- `tests`
- `ops`

### 3. pane

pane 就是一个 tab 里的分屏区域。

例如：

- 左边 shell
- 右边日志
- 下方测试

### 4. mode

`zellij` 默认是“模式化”的。

这意味着很多操作不是直接一个快捷键，而是：

1. 先进入某种模式
2. 再执行对应动作

这是新手最容易不适应的地方，但它的好处是快捷键更系统。

官方文档也明确说明了：

- 默认 preset 里，通常从普通模式进入 `Pane`、`Tab`、`Session` 等模式
- 还有另一套 `unlock-first` 预设，适合避免快捷键冲突

来源：
- Zellij keybinding presets  
  https://zellij.dev/documentation/keybinding-presets

## 先学哪些操作最值

如果你第一次用，不要试图一天学完整套操作。  
先学这几件事就够了：

### 1. 启动 zellij

直接执行：

```powershell
zellij
```

这会启动一个新的 session。

### 2. 新建 pane

在默认 preset 下，常见方式是：

- `Ctrl p`
- 然后 `n`

官方旧版文档里的示例就是这样：

1. `Ctrl + p`
2. `n`

来源：
- Zellij overview  
  https://zellij.dev/old-documentation/overview.html

### 3. 新建 tab

在默认 preset 下，常见方式是：

- `Ctrl t`
- 然后 `n`

### 4. 在 pane 之间切换

你不需要一开始记很多，先知道：

- `zellij` 本质上是围绕 pane / tab 在组织工作区
- pane 之间移动、tab 之间切换，是最常见动作

### 5. 退出和保留 session

最重要的不是“如何彻底关闭”，而是先理解：

- 你可以离开一个 session
- 之后再回来

这也是 mux 和普通 terminal 最大的区别之一。

## 推荐给 AI 编程用户的第一个工作区结构

如果你是做项目开发，建议第一个 `zellij` 工作区这样搭：

### Tab 1：主工作区

- pane 1：项目目录 shell
- pane 2：AI agent CLI

### Tab 2：运行与测试

- pane 1：dev server
- pane 2：测试命令

### Tab 3：Git / 日志

- pane 1：`git status`、提交、分支操作
- pane 2：日志输出

这套结构的好处是：

- 一个 tab 专注当前开发
- 一个 tab 专注运行状态
- 一个 tab 专注辅助操作

这样不会把所有东西硬塞进一个 pane 里。

## 一个实际例子：用 zellij 做 AI 编程

假设你正在开发一个 Web 项目。

可以这样：

### Pane A

运行：

```powershell
pnpm dev
```

### Pane B

运行：

```powershell
pnpm test --watch
```

### Pane C

运行你的 AI agent CLI，例如：

```powershell
codex
```

或者别的 agent 工具。

### Pane D

保留一个普通 shell，做：

- `git status`
- `rg`
- `eza`
- 手动检查文件

这样你就不需要在一个窗口里不断打断自己的上下文。

## session 对 AI 编程的真正价值

AI 编程特别怕“上下文碎掉”。

比如你在做这些事：

- agent 正在分析代码
- 本地服务正在跑
- 测试正在跑
- 你还要手动查文件

如果这些都散落在很多临时窗口里，你会不断丢失状态。

而 session 的价值就在于：

- 把一组相关工作固定在一起
- 你回来时，不需要重新搭一遍环境

这对高频切项目的人尤其有价值。

## 什么时候值得用 zellij

适合：

- 同时跑多个命令
- 经常切 pane / tab
- 做 AI 编程
- 做远程开发
- 跑长任务
- 想把命令行工作区固定下来

不太适合：

- 只是偶尔开 terminal 执行一两条命令
- 你的工作几乎都在 GUI IDE 里完成
- 你不需要并行维护多个命令上下文

## Windows 下怎么理解它和 Windows Terminal 的关系

要分清楚：

- Windows Terminal：terminal
- `zellij`：mux
- PowerShell：shell

也就是说：

```text
Windows Terminal
    -> zellij
        -> PowerShell
```

它们不是互相替代，而是叠在一起。

所以：

- 你换 terminal，可以从 Windows Terminal 换成 WezTerm 或 Ghostty
- 你换 shell，可以从 PowerShell 换成 nushell
- 你保留 `zellij`，它仍然是会话管理层

## 我建议新手先掌握的使用策略

如果你刚开始，不要从“配置狂热”开始。

建议顺序是：

1. 先直接运行 `zellij`
2. 先学会：
   - 新建 tab
   - 新建 pane
   - 在 pane 之间切换
3. 用它搭一个真实项目工作区
4. 连续用几天
5. 再考虑 layout、session 命名、自动化配置

这样最稳。

## 后面再学什么

等你把基础习惯养出来后，再学这三块最值：

### 1. session 管理

例如：

- 列出 session
- attach / reattach
- 为 session 命名

### 2. layout

这是 `zellij` 的强项之一。

官方文档说明，layout 可以用 KDL 描述 pane / tab 结构，并在启动时直接应用：

```powershell
zellij --layout /path/to/layout_file.kdl
```

来源：
- Layouts  
  https://zellij.dev/documentation/layouts.html

### 3. keybinding preset

如果你觉得默认快捷键和你的工具冲突，可以看看官方的 preset：

- `default`
- `unlock-first`

## 一句现实建议

如果你现在大量在做 AI 编程，`zellij` 最值得你的不是“花哨布局”，而是：

- 一个项目一个 session
- 一个 session 多个 pane / tab
- 把服务、测试、AI agent、Git 操作放进同一个工作区

这会明显降低上下文切换成本。

## 官方参考

- Zellij User Guide  
  https://zellij.dev/documentation/
- Keybinding Presets  
  https://zellij.dev/documentation/keybinding-presets
- Layouts  
  https://zellij.dev/documentation/layouts.html
- Overview  
  https://zellij.dev/old-documentation/overview.html

## 校验时间

本文按 `2026-05-10` 的官方文档和本机 `zellij 0.44.2` 编写。
