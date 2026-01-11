# Claude Model Switch 使用文档

## 简介

Claude Model Switch 是一个交互式工具，用于快速切换 Claude Code 的默认模型。它从你的 CLIProxyAPI 自动获取可用模型列表，并支持分别设置不同的模型配置。

## 新特性

- **自动环境变量刷新**：使用 `model-switch` 命令切换模型后，环境变量会自动生效，无需手动执行 `source ~/.bashrc`
- **脚本同步更新**：使用 `--update` 选项可将项目文件同步到 `~/.local/bin`

## 安装

### 方法一：使用 install.sh（推荐）

```bash
cd /path/to/claude-model-switch
./install.sh
source ~/.bashrc
```

安装脚本会：
- 复制脚本到 `~/.local/bin/`
- 添加 `model-switch` wrapper 函数到 `~/.bashrc`（用于自动刷新环境变量）
- 确保 `~/.local/bin` 在 PATH 中

### 方法二：手动安装

```bash
cp claude-model-switch ~/.local/bin/
cp uninstall.sh ~/.local/bin/claude-model-switch-uninstall
chmod +x ~/.local/bin/claude-model-switch
chmod +x ~/.local/bin/claude-model-switch-uninstall
```

确保 `~/.bashrc` 中包含：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

然后运行 `source ~/.bashrc` 使配置生效。

## 使用方法

### 推荐方式（自动刷新环境变量）

```bash
model-switch
```

### 直接运行（需手动刷新环境变量）

```bash
claude-model-switch
```

切换后需要手动执行 `source ~/.bashrc`。

### 主界面说明

```
============================================================
           Claude Code 模型切换工具
============================================================

API: https://cliproxyapi.1049131.xyz

当前配置:
  主模型 (ANTHROPIC_MODEL):           gemini-claude-opus-4-5-thinking
  Haiku 模型:                         gemini-3-flash-preview
  Opus 模型:                          gemini-claude-opus-4-5-thinking
  Sonnet 模型:                        gemini-claude-opus-4-5-thinking

--- Claude/Minimax 兼容模型 (5) ---
  1. gemini-claude-opus-4-5-thinking      2. gemini-claude-sonnet-4-5
  3. gemini-claude-sonnet-4-5-thinking    4. minimax-m2.1
  5. minimax-m2

--- Google Gemini 模型 (7) ---
  6. gemini-2.5-flash                     7. gemini-2.5-flash-lite
  8. gemini-2.5-pro                       ...

--- 其他模型 (23) ---
  ...
```

### 操作选项

| 按键 | 功能 |
|------|------|
| 数字 | 选择模型后，可选择设置到哪个配置 |
| [h] | 设置 Haiku 模型 |
| [o] | 设置 Opus 模型 |
| [s] | 设置 Sonnet 模型 |
| [m] | 设置主模型 (ANTHROPIC_MODEL) |
| [a] | 自定义输入模型名称和配置目标 |
| [r] | 将所有模型同步为当前主模型 |
| [q] | 退出 |

### 设置目标选项

在选择模型后，可以选择设置到：

| 选项 | 说明 |
|------|------|
| [1] | 仅设置主模型 (ANTHROPIC_MODEL) |
| [2] | 设置 Haiku 模型 |
| [3] | 设置 Opus 模型 |
| [4] | 设置 Sonnet 模型 |
| [5] | 设置所有模型 |

### 命令行选项

```bash
claude-model-switch --list     # 列出所有模型（JSON 格式）
claude-model-switch 3          # 切换到第 3 个模型
claude-model-switch --update   # 同步脚本到 ~/.local/bin
claude-model-switch --help     # 显示帮助
```

## 更新脚本

修改项目文件后，同步到 `~/.local/bin`：

```bash
# 方法一：使用 --update 选项
cd /path/to/claude-model-switch
./claude-model-switch --update

# 方法二：重新运行安装脚本
./install.sh
```

## 卸载

运行卸载脚本：

```bash
claude-model-switch-uninstall
```

卸载脚本会：

1. 删除 `~/.local/bin/claude-model-switch`
2. 删除 `~/.local/bin/claude-model-switch-uninstall`
3. 删除 `~/.claude/tools/model-list.json`
4. 删除 `~/.claude/tools/model.json`
5. 从 `~/.bashrc` 中移除 `model-switch` wrapper 函数
6. 可选：删除 `~/.bash_aliases` 中的相关 alias

注意：卸载脚本**不会**修改 `~/.bashrc` 中的 Claude Code 环境变量配置。

## 手动卸载

如果需要手动完全卸载，执行：

```bash
# 删除脚本文件
rm ~/.local/bin/claude-model-switch
rm ~/.local/bin/claude-model-switch-uninstall

# 删除 Claude Code tools
rm ~/.claude/tools/model-list.json
rm ~/.claude/tools/model.json

# 重新加载配置
source ~/.bashrc
```

## 常见问题

### Q: 为什么获取不到模型列表？

检查以下配置是否正确：

```bash
# 在 ~/.bashrc 中确认
export ANTHROPIC_BASE_URL="https://your-api-endpoint"
export ANTHROPIC_AUTH_TOKEN="your-token"
```

然后运行：

```bash
source ~/.bashrc
claude-model-switch
```

### Q: 为什么切换模型后 Claude Code 还是用旧模型？

这是因为子进程无法修改父进程的环境变量。解决方案：

1. **使用 `model-switch` 命令**（推荐）：通过 install.sh 安装后，使用 `model-switch` 命令会自动刷新环境变量
2. **手动刷新**：运行 `source ~/.bashrc` 后再启动 Claude Code

### Q: 如何查看当前配置的模型？

```bash
grep -E "ANTHROPIC.*MODEL" ~/.bashrc
```

### Q: 可以设置快捷别名吗？

在 `~/.bash_aliases` 中添加：

```bash
alias ms='model-switch'
```

然后运行 `source ~/.bash_aliases` 生效。

## 配置文件说明

脚本会修改 `~/.bashrc` 中的以下环境变量：

| 环境变量 | 说明 |
|----------|------|
| `ANTHROPIC_MODEL` | 主模型 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Haiku 级别模型 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Opus 级别模型 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Sonnet 级别模型 |

## 优先级说明

- Claude Code 会优先读取 `~/.claude/settings.json` 中的模型配置
- 切换模型时，脚本会自动清理该文件中的 `model` 和 `defaultModel` 配置
- 确保 `~/.bashrc` 中的环境变量设置始终优先生效

## Claude Code 内使用

首次运行 `claude-model-switch` 时，脚本会自动在 `~/.claude/tools` 中创建两个工具配置：

- `/model-list` - 查看所有可用模型列表（带编号）
- `/model <编号>` - 根据编号快速切换模型（需先执行 `/model-list` 查看编号）

首次运行后请重启 Claude Code，即可在对话中直接使用这些命令。

### /model-list
查看所有可用模型列表（带编号）。

```
/model-list
```
输出示例：
```json
{"models": [{"id": "claude-3-opus"}, {"id": "claude-3-sonnet"}, {"id": "minimax-m2.1"}]}
```

### /model <编号>
根据编号快速切换模型（需先执行 `/model-list` 查看编号）。

```
/model 3
```

切换后会提示重启 Claude Code 生效。
