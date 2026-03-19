#!/bin/bash
# Claude Model Switch Installer
# This script installs or updates claude-model-switch

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME=".claude-model-switch-bin"
UNINSTALL_NAME="claude-model-switch-uninstall"
BASHRC="$HOME/.bashrc"
MAIN_SRC="$SCRIPT_DIR/claude-model-switch"
UNINSTALL_SRC="$SCRIPT_DIR/uninstall.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    Claude Model Switch Installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Validate source files
if [ ! -f "$MAIN_SRC" ]; then
    echo -e "${RED}Error: file not found: $MAIN_SRC${NC}"
    exit 1
fi

if [ ! -f "$UNINSTALL_SRC" ]; then
    echo -e "${RED}Error: file not found: $UNINSTALL_SRC${NC}"
    exit 1
fi

# Ensure required directories/files exist
mkdir -p "$INSTALL_DIR"
touch "$BASHRC"

# Install main script (as hidden file)
echo -e "${YELLOW}Installing claude-model-switch...${NC}"
install -m 755 "$MAIN_SRC" "$INSTALL_DIR/$SCRIPT_NAME"
echo -e "  Installed: $INSTALL_DIR/$SCRIPT_NAME"

# Install uninstall script
echo -e "${YELLOW}Installing uninstall script...${NC}"
install -m 755 "$UNINSTALL_SRC" "$INSTALL_DIR/$UNINSTALL_NAME"
echo -e "  Installed: $INSTALL_DIR/$UNINSTALL_NAME"

# Shell function for environment variable auto-refresh
FUNC_MARKER="# Claude Model Switch - auto refresh env vars after switching"

# Check if function already exists in bashrc
if grep -qF "$FUNC_MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}Updating shell function...${NC}"
    # Remove old function (from marker to closing brace)
    sed -i "/$FUNC_MARKER/,/^}/d" "$BASHRC"
fi

# Add shell function to bashrc
cat >> "$BASHRC" <<'EOF'

# Claude Model Switch - auto refresh env vars after switching
claude-model-switch() {
    ~/.local/bin/.claude-model-switch-bin "$@"
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        source ~/.bashrc 2>/dev/null
    fi
    return $exit_code
}
EOF

echo -e "${GREEN}Added 'claude-model-switch' function to ~/.bashrc${NC}"

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]] && ! grep -qF 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo '# Add local bin to PATH' >> "$BASHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
    echo -e "${GREEN}Added $INSTALL_DIR to PATH in ~/.bashrc${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  1. Run 'source ~/.bashrc' to reload your shell"
echo "  2. Use 'claude-model-switch' to switch models/endpoints (env vars auto-refresh)"
echo ""
echo "To update later, run this script again from the project directory."
echo "To uninstall, run: $UNINSTALL_NAME"
