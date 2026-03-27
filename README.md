# Claude Model Switch

A CLI tool for quickly switching Claude Code default models. Supports multiple API providers with saved profiles and automatic fallback.

## Features

- **Multi-provider management** - save, switch, add, and remove API provider profiles (`~/.claude/providers.json`)
- **Auto-fallback** - if the active provider fails, automatically tries other saved providers
- **Rollback protection** - verifies connectivity before applying a switch; reverts on failure
- Automatically fetches available models from your API
- Supports setting individual model configurations (Main, Haiku, Opus, Sonnet)
- Two-column display with alphabetical sorting
- Highlights currently selected model
- Batch operations to sync all models
- Supports updating endpoint settings directly from menu (`ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN`)
- Environment variable priority: automatically clears `~/.claude/settings.json` to ensure `~/.bashrc` settings take precedence
- **Automatic environment variable refresh** - no manual `source ~/.bashrc` needed
- Script sync/update functionality to keep installed scripts up to date

## Screenshot

```
============================================================
           Claude Code Model Switch
============================================================

Active Provider: my-proxy
  Base URL:   https://api.example.com
  Auth Token: ***
  Saved Providers: my-proxy, backup-provider

Current Configuration:
  Main Model (ANTHROPIC_MODEL):  claude-3-opus
  Haiku Model:                   claude-3-haiku
  Opus Model:                    claude-3-opus
  Sonnet Model:                  claude-3-sonnet

--- Claude/Minimax Compatible (5) ---
1. claude-3-haiku                    4. minimax-m2
2. claude-3-opus *                   5. minimax-m2.1
3. claude-3-sonnet

--- Google Gemini Models (7) ---
6. gemini-2.5-flash                  10. gemini-3-flash
7. gemini-2.5-pro                    11. gemini-3-pro
...

--- Model Settings ---
  [h] Set Haiku    [o] Set Opus    [s] Set Sonnet    [m] Set Main
  [a] Custom model  [r] Sync all to Main

--- Provider Management ---
  [p] Switch Provider  [+] Add Provider   [-] Remove Provider
  [b] Set Base URL     [k] Set Auth Token

  [q] Quit
```

## Prerequisites

- Python 3.7+
- A CLIProxyAPI-compatible endpoint
- Claude Code environment configured in `~/.bashrc`

## Installation

```bash
git clone https://github.com/zhifu1996/claude-model-switch.git
cd claude-model-switch
./install.sh
source ~/.bashrc
```

This will:
- Install the script to `~/.local/bin/`
- Add `claude-model-switch` shell function to `~/.bashrc` for automatic environment refresh
- Ensure `~/.local/bin` is in your PATH

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

On first run, the tool will detect existing endpoint configuration and offer to save it as a provider profile.

## Usage

### Interactive Mode

```bash
claude-model-switch
```

### Menu Options

#### Model Settings

| Key | Action |
|-----|--------|
| Number | Select a model, then choose which config to set |
| [h] | Set Haiku model |
| [o] | Set Opus model |
| [s] | Set Sonnet model |
| [m] | Set Main model (ANTHROPIC_MODEL) |
| [a] | Enter custom model name |
| [r] | Sync all models to the current main model |

#### Provider Management

| Key | Action |
|-----|--------|
| [p] | Switch between saved providers |
| [+] | Add a new provider (name, URL, token) |
| [-] | Remove a saved provider |
| [b] | Set Base URL (ANTHROPIC_BASE_URL) |
| [k] | Set Auth Token (ANTHROPIC_AUTH_TOKEN) |

#### Other

| Key | Action |
|-----|--------|
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
claude-model-switch --update   # Sync scripts to ~/.local/bin
claude-model-switch --help     # Show help
```

## Provider Profiles

Provider profiles are stored in `~/.claude/providers.json`:

```json
{
  "providers": [
    {
      "name": "my-proxy",
      "base_url": "https://api.example.com",
      "api_key": "sk-xxx",
      "active": true
    },
    {
      "name": "backup",
      "base_url": "https://backup.example.com",
      "api_key": "sk-yyy",
      "active": false
    }
  ]
}
```

### Fallback Behavior

| Scenario | Behavior |
|----------|----------|
| Startup: active provider fails | Tries other saved providers in order; uses first one that responds |
| Switch `[p]`: new provider fails | Does not apply the switch; stays on current provider |
| Add `[+]` with activate: fails | Provider is saved but not activated |
| Manual URL/Token `[b]`/`[k]`: fails | Rolls back to previous URL/Token |

## Updating Scripts

After modifying the project files, sync to `~/.local/bin`:

```bash
cd /path/to/claude-model-switch
./claude-model-switch --update
# or
./install.sh
```

## Usage from Claude Code

The first time you run `claude-model-switch`, it automatically installs two tools to `~/.claude/tools`:

- `/model-list` - List all available models with index numbers
- `/model <number>` - Switch model by index number (run `/model-list` first to see numbers)

Restart Claude Code after first run to use these tools in conversations.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_BASE_URL` | API endpoint URL (can be changed by menu key `[b]`) |
| `ANTHROPIC_AUTH_TOKEN` | API authentication token (can be changed by menu key `[k]`) |
| `ANTHROPIC_MODEL` | Main model for Claude Code |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Haiku-level model |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Opus-level model |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Sonnet-level model |

## How Environment Auto-Refresh Works

Due to Unix/Linux process model limitations, a child process cannot modify parent process environment variables. This tool solves it by installing a shell function named `claude-model-switch` in `~/.bashrc` that:
1. Calls the actual Python script
2. Automatically runs `source ~/.bashrc` after the script exits

This way, environment variables are refreshed in the current shell immediately after switching models.

## Uninstall

```bash
claude-model-switch-uninstall
```

This will remove:
- `~/.local/bin/.claude-model-switch-bin`
- `~/.local/bin/claude-model-switch-uninstall`
- `~/.claude/tools/model-list.json`
- `~/.claude/tools/model.json`
- `~/.claude/providers.json` (saved provider profiles)
- Shell function from `~/.bashrc`

## License

MIT License

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
