# Claude Model Switch 使用文档

## 简介

Claude Model Switch 是一个交互式工具，用于快速切换 Claude Code 的默认模型。它从你的 CLIProxyAPI 自动获取可用模型列表，并支持分别设置不同的模型配置。

## 特性

- 自动从 API 获取可用模型列表
- 支持分别设置 Main、Haiku、Opus、Sonnet 模型
- **环境变量自动刷新** - 切换模型后无需手动执行 `source ~/.bashrc`
- 脚本同步更新功能

## 安装

```bash
cd /path/to/claude-model-switch
./install.sh
source ~/.bashrc
```

安装脚本会：
- 安装脚本到 `~/.local/bin/`
- 添加 `claude-model-switch` shell 函数到 `~/.bashrc`（用于自动刷新环境变量）
- 确保 `~/.local/bin` 在 PATH 中

## 使用方法

### 交互模式

```bash
claude-model-switch
```

### 命令行模式

```bash
claude-model-switch --list     # 列出所有模型（JSON 格式）
claude-model-switch 3          # 切换到第 3 个模型
claude-model-switch --update   # 同步脚本到 ~/.local/bin
claude-model-switch --help     # 显示帮助
```

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
  ...

--- Google Gemini 模型 (7) ---
  6. gemini-2.5-flash                     7. gemini-2.5-flash-lite
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

## 更新脚本

修改项目文件后，同步到 `~/.local/bin`：

```bash
cd /path/to/claude-model-switch
./claude-model-switch --update
# 或
./install.sh
```

## 卸载

```bash
claude-model-switch-uninstall
```

卸载脚本会删除：
- `~/.local/bin/.claude-model-switch-bin`
- `~/.local/bin/claude-model-switch-uninstall`
- `~/.claude/tools/model-list.json`
- `~/.claude/tools/model.json`
- `~/.bashrc` 中的 shell 函数

## 环境变量自动刷新原理

由于 Unix/Linux 进程模型限制，子进程无法修改父进程的环境变量。本工具通过在 `~/.bashrc` 中安装一个名为 `claude-model-switch` 的 shell 函数来解决：

```bash
claude-model-switch() {
    ~/.local/bin/.claude-model-switch-bin "$@"
    source ~/.bashrc
}
```

这样切换模型后，环境变量会在当前 shell 中立即刷新。

## Claude Code 内使用

首次运行 `claude-model-switch` 时，脚本会自动在 `~/.claude/tools` 中创建两个工具配置：

- `/model-list` - 查看所有可用模型列表（带编号）
- `/model <编号>` - 根据编号快速切换模型

首次运行后请重启 Claude Code，即可在对话中直接使用这些命令。

## 常见问题

### Q: 为什么获取不到模型列表？

检查 `~/.bashrc` 中的配置：

```bash
export ANTHROPIC_BASE_URL="https://your-api-endpoint"
export ANTHROPIC_AUTH_TOKEN="your-token"
```

### Q: 如何查看当前配置的模型？

```bash
grep -E "ANTHROPIC.*MODEL" ~/.bashrc
```

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
