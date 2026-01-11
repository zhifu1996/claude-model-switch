#!/bin/bash
# Claude Model Switch Installer
# This script installs or updates claude-model-switch

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="claude-model-switch"
UNINSTALL_NAME="claude-model-switch-uninstall"
BASHRC="$HOME/.bashrc"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    Claude Model Switch Installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Create install directory if not exists
mkdir -p "$INSTALL_DIR"

# Copy main script
echo -e "${YELLOW}Installing $SCRIPT_NAME...${NC}"
cp "$SCRIPT_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo -e "  Installed: $INSTALL_DIR/$SCRIPT_NAME"

# Copy uninstall script
echo -e "${YELLOW}Installing uninstall script...${NC}"
cp "$SCRIPT_DIR/uninstall.sh" "$INSTALL_DIR/$UNINSTALL_NAME"
chmod +x "$INSTALL_DIR/$UNINSTALL_NAME"
echo -e "  Installed: $INSTALL_DIR/$UNINSTALL_NAME"

# Shell wrapper function for environment variable refresh
WRAPPER_MARKER="# Claude Model Switch wrapper"
WRAPPER_FUNCTION='# Claude Model Switch wrapper - enables env var refresh
model-switch() {
    '"$INSTALL_DIR/$SCRIPT_NAME"' "$@"
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        source ~/.bashrc 2>/dev/null
    fi
    return $exit_code
}'

# Check if wrapper already exists in bashrc
if grep -q "$WRAPPER_MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}Updating shell wrapper function...${NC}"
    # Remove old wrapper (from marker to closing brace)
    sed -i "/$WRAPPER_MARKER/,/^}/d" "$BASHRC"
fi

# Add wrapper function to bashrc
echo "" >> "$BASHRC"
echo "$WRAPPER_FUNCTION" >> "$BASHRC"
echo -e "${GREEN}Added shell wrapper function 'model-switch' to ~/.bashrc${NC}"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
        echo "" >> "$BASHRC"
        echo '# Add local bin to PATH' >> "$BASHRC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
        echo -e "${GREEN}Added $INSTALL_DIR to PATH in ~/.bashrc${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  1. Run 'source ~/.bashrc' to reload your shell"
echo "  2. Use 'model-switch' command to switch models (env vars auto-refresh)"
echo "  3. Or use '$SCRIPT_NAME' directly (requires manual 'source ~/.bashrc')"
echo ""
echo "To update later, run this script again from the project directory."
echo "To uninstall, run: $UNINSTALL_NAME"
