# 如何用 Zellij 提效 AI 编程：传统方式怎么做，有了 Zellij 之后怎么做

这篇文档不只是讲 `zellij` 怎么按，而是讲一个更实际的问题：

在 AI 编程场景里，为什么值得用 `zellij`？

我会用一种对照方式来讲：

1. 传统方式怎么做
2. 有了 `zellij` 之后怎么做
3. 哪些场景收益最大

## 先讲结论

`zellij` 不是让某一条命令变快。

它真正提升的是：

- 多任务并行时的组织能力
- 项目工作区的稳定性
- 终端上下文的连续性
- AI CLI、测试、服务、日志并行时的切换成本

所以它提升的不是“单条命令性能”，而是**工作流效率**。

## 典型 AI 编程场景

如果你大量使用 AI 编程，常见工作流通常不是只做一件事，而是同时做这些事：

- 运行 AI CLI
- 看项目目录
- 跑本地服务
- 跑测试
- 看日志
- 做 Git 操作

也就是说，你同时会有多个活跃上下文。

这正是 `zellij` 最有价值的地方。

## 一、传统方式怎么做

先看不使用 `zellij` 时，很多人是怎么工作的。

### 场景：你在开发一个项目

你可能会这样开终端：

### Terminal Tab 1

```powershell
codex
```

### Terminal Tab 2

```powershell
pnpm dev
```

### Terminal Tab 3

```powershell
pnpm test --watch
```

### Terminal Tab 4

```powershell
git status
```

### Terminal Tab 5

```powershell
eza -la
```

这当然可以工作，但问题很快就会出现。

## 传统方式的问题

### 1. 上下文分散

你的项目工作流被拆在多个 tab / 窗口里。

你虽然“都开着”，但它们之间没有被组织成一个工作区。

### 2. 很容易切乱

你会经常出现：

- 忘了哪个 tab 在跑测试
- 忘了哪个 tab 在跑 dev server
- 想回 AI CLI，结果切错了

### 3. 关掉窗口就散了

你关闭 terminal 后，下次回来要重新开：

- AI CLI
- dev server
- test watcher
- Git shell

也就是说，你保留的是“几个独立命令”，不是“一个项目工作区”。

### 4. 并行任务越来越多时，terminal 会变得很吵

AI 编程通常会扩大并行度。

以前你可能只需要：

- 一个编辑器
- 一个 shell

现在你还会多出：

- 一个 agent CLI
- 一个辅助 shell
- 一个测试 shell
- 一个日志 shell

传统多 tab 工作流会越来越松散。

## 二、有了 Zellij 之后怎么做

`zellij` 的核心思路不是多开 tab，而是：

**把一组相关命令收成一个 session。**

这个 session 就对应一个项目工作区。

## 推荐的 AI 编程工作区结构

下面是一套很适合 AI 编程的布局。

### Tab 1：主工作区

- Pane A：AI CLI
- Pane B：普通项目 shell

例如：

Pane A

```powershell
codex
```

Pane B

```powershell
eza -la
```

或者直接在这里做：

- `git status`
- `rg`
- `fd`
- 打开辅助命令

### Tab 2：运行区

- Pane A：dev server
- Pane B：test watcher

例如：

Pane A

```powershell
pnpm dev
```

Pane B

```powershell
pnpm test --watch
```

### Tab 3：日志 / Git 区

- Pane A：日志
- Pane B：Git 操作

这样你的项目工作流就变成了一个有结构的 session，而不是五个散乱的 tab。

## Zellij 带来的变化到底是什么

### 传统方式

你拥有的是：

- 很多独立 terminal tab
- 很多独立命令
- 很多独立上下文

### 用了 Zellij

你拥有的是：

- 一个项目级 session
- session 里有多个 tab
- tab 里有多个 pane
- 每个 pane 分工明确

这两个差别非常大。

## 三、AI CLI 在其中的位置

很多人第一次接触 `zellij` 时，会误以为它是为“远程断线恢复”准备的。

这当然是它的重要场景，但对 AI 编程来说，更重要的是：

**把 AI CLI 放进一个稳定工作区里。**

例如：

- 左边 pane 跑 `codex`
- 右边 pane 做代码检查
- 下方 tab 跑测试

这样你和 AI 交互时，不需要频繁切出项目上下文。

你会明显感觉到：

- AI 在一个固定 pane 里
- 项目 shell 在另一个固定 pane 里
- 服务和测试也有自己固定位置

这比不停切 tab 更像真正的工作台。

## 四、传统方式和 Zellij 方式的对照

### 传统方式

```text
Windows Terminal
├─ Tab 1: codex
├─ Tab 2: pnpm dev
├─ Tab 3: pnpm test --watch
├─ Tab 4: git status
└─ Tab 5: eza -la
```

特点：

- 每个任务都在单独 tab
- 看起来简单
- 但切换成本高
- 工作区结构不明显

### Zellij 方式

```text
Windows Terminal
└─ Zellij Session: my-project
   ├─ Tab 1: Main
   │  ├─ Pane A: codex
   │  └─ Pane B: project shell
   ├─ Tab 2: Runtime
   │  ├─ Pane A: pnpm dev
   │  └─ Pane B: pnpm test --watch
   └─ Tab 3: Ops
      ├─ Pane A: logs
      └─ Pane B: git
```

特点：

- 工作区结构稳定
- 上下文清晰
- 更容易长期使用

## 五、什么情况下收益最大

`zellij` 在 AI 编程里最有价值的，不是“我也能分屏”，而是下面这几种场景。

### 1. 你同时跑多个长期命令

例如：

- 本地服务
- watch 测试
- agent CLI
- 日志

### 2. 你频繁在多个终端任务之间切换

例如：

- 一边跟 AI 交互
- 一边检查代码
- 一边观察测试

### 3. 你希望一个项目就是一个固定工作台

不是每次打开终端都重新排列，而是：

- 这个项目就有一套固定结构

### 4. 你经常被“终端窗口太多”打断

如果你已经开始觉得：

- tab 太多
- pane 太乱
- 总是找不到当前任务

那就是 `zellij` 开始值得用的时候。

## 六、它不解决什么

也要讲清楚边界。

`zellij` 不能直接解决：

- AI 模型自己的长期记忆
- Codex / Claude Code 自己的会话语义恢复
- prompt 美化
- 文件列表配色

这些分别属于：

- AI 工具自身能力
- `starship`
- `eza`
- 主题系统

`zellij` 解决的是：

- 工作区组织
- pane / tab 管理
- session 稳定性

## 七、第一次上手时该怎么用

如果你想真正从传统方式过渡到 `zellij`，建议不要一步到位。

### 第 1 阶段

只做一件事：

- 用 `zellij` 代替“多 tab 并行”

也就是先把：

- AI CLI
- dev server
- test watcher

放进同一个 session。

### 第 2 阶段

开始固定 tab 分工：

- `main`
- `runtime`
- `ops`

### 第 3 阶段

再去考虑：

- session 命名
- layout
- 自动启动结构

不要一开始就沉迷配置。

## 八、适合你的最小实践方案

如果你现在就想试，不要想太多，直接用这套：

### Step 1

启动：

```powershell
zellij
```

### Step 2

建一个 main tab：

- Pane A：`codex`
- Pane B：普通 shell

### Step 3

建一个 runtime tab：

- Pane A：`pnpm dev`
- Pane B：`pnpm test --watch`

### Step 4

连续这样用几天。

如果你发现：

- 你更少丢上下文
- 你更少开乱 terminal
- 你更少在 AI、测试、服务之间来回迷路

那说明 `zellij` 对你是有价值的。

## 九、最重要的一句判断

如果你的工作方式是：

- 单线程
- 一次只跑一个命令
- 很少开多个终端任务

那 `zellij` 价值不大。

如果你的工作方式是：

- AI CLI + shell + service + tests + logs 并行

那 `zellij` 很可能会明显提效。

它提升的不是“某个命令更强”，而是：

**让多命令、多上下文、多任务的开发工作台变得更清晰。**
