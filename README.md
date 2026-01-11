# Claude Model Switch

A CLI tool for quickly switching Claude Code default models. Automatically fetches available models from your CLIProxyAPI endpoint.

## Features

- Automatically fetches available models from your API
- Supports setting individual model configurations (Main, Haiku, Opus, Sonnet)
- Two-column display with alphabetical sorting
- Highlights currently selected model
- Batch operations to sync all models
- Environment variable priority: automatically clears `~/.claude/settings.json` to ensure `~/.bashrc` settings take precedence
- Automatic environment refresh: re-sources `~/.bashrc` immediately after switching models

## Screenshot

```
============================================================
           Claude Code Model Switch
============================================================

API: https://api.example.com

Current Configuration:
  Main Model (ANTHROPIC_MODEL):       claude-3-opus
  Haiku Model:                        claude-3-haiku
  Opus Model:                         claude-3-opus
  Sonnet Model:                       claude-3-sonnet

--- Claude/Minimax Compatible (5) ---
1. claude-3-haiku                    4. minimax-m2
2. claude-3-opus *                   5. minimax-m2.1
3. claude-3-sonnet

--- Google Gemini Models (7) ---
6. gemini-2.5-flash                  10. gemini-3-flash
7. gemini-2.5-pro                    11. gemini-3-pro
...

--- Set Individual Models ---
  [h] Set Haiku Model          [o] Set Opus Model
  [s] Set Sonnet Model         [m] Set Main Model (ANTHROPIC_MODEL)

--- Batch Operations ---
  [a] Custom model name input
  [r] Sync all models to main model
  [q] Quit
```

## Prerequisites

- Python 3.7+
- A CLIProxyAPI-compatible endpoint
- Claude Code environment configured in `~/.bashrc`

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/claude-model-switch.git
cd claude-model-switch
```

2. Copy the scripts to your local bin:

```bash
cp claude-model-switch ~/.local/bin/
cp claude-model-switch ~/.local/bin/claude-model-list
chmod +x ~/.local/bin/claude-model-switch
chmod +x ~/.local/bin/claude-model-list
```

3. Make sure `~/.local/bin` is in your PATH. Add to `~/.bashrc` if needed:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

4. Reload your shell:

```bash
source ~/.bashrc
```

## Configuration

The tool reads configuration from environment variables. Add these to your `~/.bashrc`:

```bash
# Claude Code Configuration
export ANTHROPIC_AUTH_TOKEN="your-api-key-here"
export ANTHROPIC_BASE_URL="https://api.example.com"
export ANTHROPIC_MODEL="claude-3-opus"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-3-haiku"
export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-3-opus"
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-3-sonnet"
```

## Usage

Simply run:

```bash
claude-model-switch
```

### Menu Options

| Key | Action |
|-----|--------|
| Number | Select a model, then choose which config to set |
| [h] | Set Haiku model |
| [o] | Set Opus model |
| [s] | Set Sonnet model |
| [m] | Set Main model (ANTHROPIC_MODEL) |
| [a] | Enter custom model name |
| [r] | Sync all models to the current main model |
| [q] | Quit |

### After Selecting a Model

| Key | Action |
|-----|--------|
| [1] | Set Main Model only |
| [2] | Set Haiku Model only |
| [3] | Set Opus Model only |
| [4] | Set Sonnet Model only |
| [5] | Set All Models |

### Command Line Options

```bash
claude-model-switch --list     # List all models (JSON format)
claude-model-switch 3          # Switch to model #3
claude-model-switch --help     # Show help
```

## Usage from Claude Code

The first time you run `claude-model-switch`, it automatically installs two tools to `~/.claude/tools`:

- `/model-list` - List all available models with index numbers
- `/model <number>` - Switch model by index number (run `/model-list` first to see numbers)

Restart Claude Code after first run to use these tools in conversations.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_BASE_URL` | API endpoint URL |
| `ANTHROPIC_AUTH_TOKEN` | API authentication token |
| `ANTHROPIC_MODEL` | Main model for Claude Code |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Haiku-level model |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Opus-level model |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Sonnet-level model |

## Uninstall

Run the uninstall script:

```bash
./uninstall.sh
```

Or manually:

```bash
rm ~/.local/bin/claude-model-switch
```

## License

MIT License

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
