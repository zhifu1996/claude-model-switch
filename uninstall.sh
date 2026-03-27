#!/bin/bash
# Claude Model Switch Uninstaller

set -euo pipefail

echo "=========================================="
echo "      Claude Model Switch Uninstaller"
echo "=========================================="
echo ""

SCRIPT_PATH="$HOME/.local/bin/.claude-model-switch-bin"
UNINSTALL_SCRIPT="$HOME/.local/bin/claude-model-switch-uninstall"
TOOLS_DIR="$HOME/.claude/tools"
PROVIDERS_FILE="$HOME/.claude/providers.json"
BASHRC="$HOME/.bashrc"
BASH_ALIASES="$HOME/.bash_aliases"
FUNC_MARKER="# Claude Model Switch - auto refresh env vars after switching"

# Collect removable items
files_to_delete=()
for f in "$SCRIPT_PATH" "$UNINSTALL_SCRIPT" \
         "$TOOLS_DIR/model-list.json" "$TOOLS_DIR/model.json"; do
    [ -f "$f" ] && files_to_delete+=("$f")
done

has_providers=false
[ -f "$PROVIDERS_FILE" ] && has_providers=true

has_func=false
[ -f "$BASHRC" ] && grep -qF "$FUNC_MARKER" "$BASHRC" 2>/dev/null && has_func=true

has_alias=false
[ -f "$BASH_ALIASES" ] && grep -q "model-switch" "$BASH_ALIASES" 2>/dev/null && has_alias=true

if [ ${#files_to_delete[@]} -eq 0 ] && [ "$has_providers" = false ] && [ "$has_func" = false ] && [ "$has_alias" = false ]; then
    echo "No files found to delete."
    exit 0
fi

echo "The following will be removed:"
for f in "${files_to_delete[@]}"; do
    echo "  - $f"
done
[ "$has_providers" = true ] && echo "  - $PROVIDERS_FILE (provider profiles)"
[ "$has_func" = true ]      && echo "  - Shell function 'claude-model-switch' from ~/.bashrc"
echo ""

read -rp "Confirm deletion? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
fi

for file in "${files_to_delete[@]}"; do
    rm -f "$file"
    echo "Deleted: $file"
done

# Remove provider profiles
if [ "$has_providers" = true ]; then
    rm -f "$PROVIDERS_FILE"
    echo "Deleted: $PROVIDERS_FILE"
fi

# Remove shell function from bashrc
if [ "$has_func" = true ]; then
    sed -i '/^# Claude Model Switch - auto refresh env vars after switching$/,/^}/d' "$BASHRC"
    echo "Removed shell function 'claude-model-switch' from ~/.bashrc"
fi

# Optionally remove related aliases
if [ "$has_alias" = true ]; then
    echo ""
    echo "Found related aliases in ~/.bash_aliases:"
    grep "model-switch" "$BASH_ALIASES"
    read -rp "Delete these alias lines? (y/n): " confirm_alias
    if [ "$confirm_alias" = "y" ] || [ "$confirm_alias" = "Y" ]; then
        sed -i '/model-switch/d' "$BASH_ALIASES"
        echo "Removed aliases from ~/.bash_aliases."
    fi
fi

echo ""
echo "Uninstall complete!"
echo ""
echo "Note:"
echo "  - Claude Code environment variables in ~/.bashrc were not modified."
echo "  - ~/.claude/settings.json was not modified."
echo "  - Run 'source ~/.bashrc' to reload your shell."
