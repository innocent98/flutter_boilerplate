#!/bin/bash

# ============================================================================
# Flutter Industry Standard Project Generator
# ============================================================================
# This script creates a production-ready Flutter project with:
# - Feature-first Clean Architecture
# - Pre-built widget library
# - Responsive design system
# - State management (Riverpod)
# - Type-safe routing (Auto_route)
# - Code generation setup
# - Testing infrastructure
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}============================================================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}============================================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# ============================================================================
# VALIDATION
# ============================================================================

if [ -z "$1" ]; then
    print_error "Project name is required!"
    echo "Usage: ./flutter_project_generator.sh <project_name> [organization]"
    echo "Example: ./flutter_project_generator.sh my_awesome_app com.example"
    exit 1
fi

PROJECT_NAME=$1
ORGANIZATION=${2:-"com.example"}
CURRENT_DIR=$(pwd)
PROJECT_DIR="$CURRENT_DIR/$PROJECT_NAME"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if project already exists
if [ -d "$PROJECT_DIR" ]; then
    print_error "Directory '$PROJECT_NAME' already exists!"
    exit 1
fi

# ============================================================================
# START GENERATION
# ============================================================================

print_header "Flutter Industry Standard Project Generator"
print_info "Project Name: $PROJECT_NAME"
print_info "Organization: $ORGANIZATION"
print_info "Flutter Version: $(flutter --version | head -n 1)"
echo ""

# ============================================================================
# STEP 1: Create Flutter Project
# ============================================================================

print_header "STEP 1: Creating Flutter Project"
flutter create "$PROJECT_NAME" --org "$ORGANIZATION" --platforms=android,ios,web
cd "$PROJECT_DIR"
print_success "Flutter project created"

# ============================================================================
# STEP 2: Add Dependencies
# ============================================================================

print_header "STEP 2: Adding Dependencies"

# State Management & Architecture
flutter pub add flutter_riverpod
flutter pub add riverpod_annotation

# Routing
flutter pub add auto_route

# Code Generation
flutter pub add freezed_annotation
flutter pub add json_annotation

# UI & Styling
flutter pub add google_fonts
flutter pub add flutter_svg
flutter pub add cached_network_image
flutter pub add flutter_screenutil
flutter pub add lottie

# Utilities
flutter pub add intl
flutter pub add logger
flutter pub add shared_preferences
flutter pub add flutter_secure_storage
flutter pub add dio
flutter pub add path_provider

# Permissions & Device
flutter pub add permission_handler
flutter pub add device_info_plus
flutter pub add package_info_plus

# Add Dev Dependencies
flutter pub add -d build_runner
flutter pub add -d freezed
flutter pub add -d json_serializable
flutter pub add -d auto_route_generator
flutter pub add -d riverpod_generator
flutter pub add -d riverpod_lint
flutter pub add -d custom_lint
flutter pub add -d flutter_lints
flutter pub add -d flutter_test

print_success "Dependencies added"

# ============================================================================
# STEP 3: Create Folder Structure
# ============================================================================

print_header "STEP 3: Creating Folder Structure"

# Core folders
mkdir -p lib/core/{constants,theme,utils,widgets,routes,services,models,providers,extensions}

# Core widgets subfolders
mkdir -p lib/core/widgets/{buttons,inputs,cards,images,animations,dialogs,common,layouts}

# Features folders
mkdir -p lib/features/splash/presentation/pages
mkdir -p lib/features/auth/{domain/models,data/repositories,presentation/{pages,providers,widgets}}
mkdir -p lib/features/home/{domain/models,data/repositories,presentation/{pages,providers,widgets}}

# Assets folders
mkdir -p assets/{images,icons,animations,fonts}
mkdir -p assets/images/{logos,placeholders}

# Test folders
mkdir -p test/{unit,widget,integration}
mkdir -p test/core/{utils,widgets}
mkdir -p test/features/auth

# Scripts folder
mkdir -p scripts

print_success "Folder structure created"

# ============================================================================
# STEP 4: Generate Template Files
# ============================================================================

print_header "STEP 4: Generating Template Files"

# This will be done in the next steps where we create individual files
print_info "Preparing to generate template files..."

echo "Template generation script created successfully!"
echo ""
echo "Next steps will create all the necessary files..."
