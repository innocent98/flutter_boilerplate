#!/bin/bash

# ============================================================================
# Flutter Boilerplate Generator - Installation Script
# ============================================================================
# This script installs the Flutter boilerplate generator as a global command
# Usage: ./install.sh
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
SCRIPT_NAME="GENERATE_FLUTTER_APP.sh"
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
# Pre-installation Checks
# ============================================================================

print_header "Flutter Boilerplate Generator - Installation"

info "Checking prerequisites..."

# Check if script exists
if [ ! -f "$SCRIPT_NAME" ]; then
    error "Error: $SCRIPT_NAME not found in current directory"
    echo "Please run this script from the flutter_boilerplate directory"
    exit 1
fi
success "Generator script found"

# Check if running on macOS or Linux
if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    error "Error: This installer only supports macOS and Linux"
    exit 1
fi
success "Operating system supported: $OSTYPE"

# Check if /usr/local/bin exists
if [ ! -d "$INSTALL_DIR" ]; then
    warning "$INSTALL_DIR does not exist. Creating it..."
    sudo mkdir -p "$INSTALL_DIR" || {
        error "Failed to create $INSTALL_DIR"
        exit 1
    }
    success "$INSTALL_DIR created"
fi

# Check if command already exists
if [ -f "$INSTALL_DIR/$COMMAND_NAME" ]; then
    warning "Command '$COMMAND_NAME' already exists"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Installation cancelled"
        exit 0
    fi
fi

# ============================================================================
# Installation
# ============================================================================

print_header "Installing..."

# Get the absolute path of the script
SCRIPT_PATH="$(cd "$(dirname "$SCRIPT_NAME")" && pwd)/$(basename "$SCRIPT_NAME")"

info "Installing $COMMAND_NAME to $INSTALL_DIR"

# Create a wrapper script that calls the original script
sudo tee "$INSTALL_DIR/$COMMAND_NAME" > /dev/null <<EOF
#!/bin/bash
# Flutter Boilerplate Generator - Global Command Wrapper
# This script calls the actual generator script

GENERATOR_SCRIPT="$SCRIPT_PATH"

if [ ! -f "\$GENERATOR_SCRIPT" ]; then
    echo "Error: Generator script not found at \$GENERATOR_SCRIPT"
    echo "Please ensure the flutter_boilerplate directory hasn't been moved or deleted"
    exit 1
fi

# Execute the generator script
bash "\$GENERATOR_SCRIPT" "\$@"
EOF

# Make it executable
sudo chmod +x "$INSTALL_DIR/$COMMAND_NAME"

success "Command installed successfully"

# ============================================================================
# Verification
# ============================================================================

print_header "Verifying Installation"

if command -v "$COMMAND_NAME" &> /dev/null; then
    success "Command '$COMMAND_NAME' is available globally"

    # Check PATH
    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        success "$INSTALL_DIR is in your PATH"
    else
        warning "$INSTALL_DIR is not in your PATH"
        info "Add this line to your ~/.zshrc or ~/.bashrc:"
        echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
else
    error "Command '$COMMAND_NAME' not found in PATH"
    exit 1
fi

# ============================================================================
# Installation Complete
# ============================================================================

print_header "✨ Installation Complete!"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Flutter Boilerplate Generator is ready to use!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "🚀 Usage:"
echo "   1. Navigate to your projects directory:"
echo "      cd ~/Documents/mobile"
echo ""
echo "   2. Run the generator:"
echo "      $COMMAND_NAME"
echo ""
echo "   3. Follow the prompts to create your Flutter project"
echo ""
echo "📝 Notes:"
echo "   • The command is now available globally from any directory"
echo "   • The generator script location: $SCRIPT_PATH"
echo "   • To uninstall: sudo rm $INSTALL_DIR/$COMMAND_NAME"
echo ""
echo "💡 Tips:"
echo "   • Don't move or delete the flutter_boilerplate directory"
echo "   • Run 'flutter-gen' from any directory to generate a new project"
echo ""

success "Happy coding!"
echo ""
