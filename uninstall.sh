#!/bin/bash
# Claude Model Switch Uninstaller

echo "=========================================="
echo "      Claude Model Switch Uninstaller"
echo "=========================================="
echo ""

SCRIPT_PATH="$HOME/.local/bin/.claude-model-switch-bin"
UNINSTALL_SCRIPT="$HOME/.local/bin/claude-model-switch-uninstall"
TOOLS_DIR="$HOME/.claude/tools"
BASHRC="$HOME/.bashrc"
FUNC_MARKER="# Claude Model Switch - auto refresh env vars after switching"

echo "The following will be removed:"
echo "  1. $SCRIPT_PATH"
echo "  2. $UNINSTALL_SCRIPT"
echo "  3. $TOOLS_DIR/model-list.json (if exists)"
echo "  4. $TOOLS_DIR/model.json (if exists)"
echo "  5. Shell function 'claude-model-switch' from ~/.bashrc"
echo ""

files_to_delete=()
if [ -f "$SCRIPT_PATH" ]; then
    files_to_delete+=("$SCRIPT_PATH")
fi
if [ -f "$UNINSTALL_SCRIPT" ]; then
    files_to_delete+=("$UNINSTALL_SCRIPT")
fi

has_func=false
if grep -q "$FUNC_MARKER" "$BASHRC" 2>/dev/null; then
    has_func=true
fi

if [ ${#files_to_delete[@]} -eq 0 ] && [ ! -f "$TOOLS_DIR/model-list.json" ] && [ ! -f "$TOOLS_DIR/model.json" ] && [ "$has_func" = false ]; then
    echo "No files found to delete."
    exit 0
fi

read -p "Confirm deletion? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
fi

for file in "${files_to_delete[@]}"; do
    rm -f "$file"
    echo "Deleted: $file"
done

# Delete Claude Code tools
if [ -f "$TOOLS_DIR/model-list.json" ]; then
    rm -f "$TOOLS_DIR/model-list.json"
    echo "Deleted: $TOOLS_DIR/model-list.json"
fi
if [ -f "$TOOLS_DIR/model.json" ]; then
    rm -f "$TOOLS_DIR/model.json"
    echo "Deleted: $TOOLS_DIR/model.json"
fi

# Remove shell function from bashrc
if [ "$has_func" = true ]; then
    # Remove function block (from marker line to closing brace)
    sed -i "/$FUNC_MARKER/,/^}/d" "$BASHRC"
    # Remove any trailing empty lines that might be left
    sed -i '/^$/N;/^\n$/d' "$BASHRC"
    echo "Removed shell function 'claude-model-switch' from ~/.bashrc"
fi

if [ -f "$HOME/.bash_aliases" ]; then
    if grep -q "model-switch" "$HOME/.bash_aliases"; then
        echo ""
        echo "Found related aliases in ~/.bash_aliases:"
        grep "model-switch" "$HOME/.bash_aliases"
        read -p "Delete these alias lines? (y/n): " confirm_alias
        if [ "$confirm_alias" = "y" ] || [ "$confirm_alias" = "Y" ]; then
            sed -i '/model-switch/d' "$HOME/.bash_aliases"
            echo "Removed aliases from ~/.bash_aliases."
        fi
    fi
fi

echo ""
echo "Uninstall complete!"
echo ""
echo "Note:"
echo "  - Claude Code environment variables in ~/.bashrc were not modified."
echo "  - ~/.claude/settings.json was not modified."
echo "  - Run 'source ~/.bashrc' to reload your shell."
