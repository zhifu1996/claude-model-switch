#!/bin/bash
# Claude Model Switch Uninstaller

echo "=========================================="
echo "      Claude Model Switch Uninstaller"
echo "=========================================="
echo ""

SCRIPT_PATH="$HOME/.local/bin/claude-model-switch"
UNINSTALL_SCRIPT="$HOME/.local/bin/claude-model-switch-uninstall"

echo "The following files will be deleted:"
echo "  1. $SCRIPT_PATH"
echo "  2. $UNINSTALL_SCRIPT"
echo ""

files_to_delete=()
if [ -f "$SCRIPT_PATH" ]; then
    files_to_delete+=("$SCRIPT_PATH")
fi
if [ -f "$UNINSTALL_SCRIPT" ]; then
    files_to_delete+=("$UNINSTALL_SCRIPT")
fi

if [ ${#files_to_delete[@]} -eq 0 ]; then
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
echo "Note: Claude Code environment variables in ~/.bashrc were not modified."
echo "Edit ~/.bashrc manually if needed."
