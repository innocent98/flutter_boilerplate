#!/bin/bash

# ============================================================================
# Flutter Boilerplate Generator - Uninstallation Script
# ============================================================================
# This script removes the Flutter boilerplate generator global command
# Usage: ./uninstall.sh
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COMMAND_NAME="flutter-gen"
INSTALL_DIR="/usr/local/bin"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Pre-uninstallation Checks
# ============================================================================

print_header "Flutter Boilerplate Generator - Uninstallation"

# Check if command exists
if [ ! -f "$INSTALL_DIR/$COMMAND_NAME" ]; then
    warning "Command '$COMMAND_NAME' is not installed"
    info "Nothing to uninstall"
    exit 0
fi

success "Found installed command at $INSTALL_DIR/$COMMAND_NAME"

# Confirm uninstallation
echo ""
read -p "Are you sure you want to uninstall '$COMMAND_NAME'? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Uninstallation cancelled"
    exit 0
fi

# ============================================================================
# Uninstallation
# ============================================================================

print_header "Uninstalling..."

info "Removing $COMMAND_NAME from $INSTALL_DIR"

# Remove the command
sudo rm -f "$INSTALL_DIR/$COMMAND_NAME"

if [ ! -f "$INSTALL_DIR/$COMMAND_NAME" ]; then
    success "Command removed successfully"
else
    error "Failed to remove command"
    exit 1
fi

# ============================================================================
# Verification
# ============================================================================

print_header "Verifying Removal"

if ! command -v "$COMMAND_NAME" &> /dev/null; then
    success "Command '$COMMAND_NAME' is no longer available"
else
    warning "Command '$COMMAND_NAME' still found in PATH"
    info "You may need to restart your terminal or run: hash -r"
fi

# ============================================================================
# Uninstallation Complete
# ============================================================================

print_header "✨ Uninstallation Complete!"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Flutter Boilerplate Generator has been removed${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📝 Notes:"
echo "   • The generator script files are still in the flutter_boilerplate directory"
echo "   • You can reinstall anytime by running: ./install.sh"
echo "   • To completely remove, delete the flutter_boilerplate directory"
echo ""

success "Goodbye!"
echo ""
