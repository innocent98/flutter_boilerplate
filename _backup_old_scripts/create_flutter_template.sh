#!/bin/bash

# ============================================================================
# Flutter Industry Standard Project Generator - Complete Version
# ============================================================================
# Author: Professional Flutter Template Generator
# Description: Creates a production-ready Flutter project with all boilerplate
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ️  $1${NC}"; }
print_step() { echo -e "${MAGENTA}→ $1${NC}"; }

# ============================================================================
# VALIDATION
# ============================================================================

if [ -z "$1" ]; then
    print_error "Project name is required!"
    echo ""
    echo "Usage: ./create_flutter_template.sh <project_name> [organization]"
    echo ""
    echo "Examples:"
    echo "  ./create_flutter_template.sh my_app"
    echo "  ./create_flutter_template.sh my_app com.company"
    echo ""
    exit 1
fi

PROJECT_NAME=$1
ORGANIZATION=${2:-"com.example"}
CURRENT_DIR=$(pwd)
PROJECT_DIR="$CURRENT_DIR/$PROJECT_NAME"

# Validate Flutter installation
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if project exists
if [ -d "$PROJECT_DIR" ]; then
    print_error "Directory '$PROJECT_NAME' already exists!"
    exit 1
fi

# ============================================================================
# DISPLAY INFO
# ============================================================================

print_header "Flutter Industry Standard Project Generator"
echo "  Project Name: $PROJECT_NAME"
echo "  Organization: $ORGANIZATION"
echo "  Flutter Version: $(flutter --version | head -n 1)"
echo "  Output Directory: $PROJECT_DIR"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Cancelled by user"
    exit 0
fi

# ============================================================================
# STEP 1: Create Base Flutter Project
# ============================================================================

print_header "STEP 1/10: Creating Base Flutter Project"
print_step "Running flutter create..."
flutter create "$PROJECT_NAME" \
    --org "$ORGANIZATION" \
    --platforms=android,ios,web \
    --no-overwrite 2>&1 | grep -v "^Running" || true

cd "$PROJECT_DIR"
print_success "Base project created"

# ============================================================================
# STEP 2: Add Dependencies
# ============================================================================

print_header "STEP 2/10: Adding Dependencies"

print_step "Adding core dependencies..."
flutter pub add \
    flutter_riverpod \
    riverpod_annotation \
    auto_route \
    freezed_annotation \
    json_annotation \
    google_fonts \
    flutter_svg \
    cached_network_image \
    flutter_screenutil \
    lottie \
    intl \
    logger \
    shared_preferences \
    flutter_secure_storage \
    dio \
    path_provider \
    permission_handler \
    device_info_plus \
    package_info_plus \
    > /dev/null 2>&1

print_step "Adding dev dependencies..."
flutter pub add -d \
    build_runner \
    freezed \
    json_serializable \
    auto_route_generator \
    riverpod_generator \
    riverpod_lint \
    custom_lint \
    flutter_lints \
    > /dev/null 2>&1

print_success "All dependencies added"

# ============================================================================
# STEP 3: Create Folder Structure
# ============================================================================

print_header "STEP 3/10: Creating Folder Structure"

print_step "Creating core folders..."
mkdir -p lib/core/{constants,theme,utils,widgets,routes,services,models,providers,extensions}
mkdir -p lib/core/widgets/{buttons,inputs,cards,images,animations,dialogs,common,layouts}

print_step "Creating feature folders..."
mkdir -p lib/features/splash/presentation/pages
mkdir -p lib/features/auth/{domain/models,data/repositories,presentation/{pages,providers,widgets}}
mkdir -p lib/features/home/{domain/models,data/repositories,presentation/{pages,providers,widgets}}

print_step "Creating asset folders..."
mkdir -p assets/{images,icons,animations,fonts}
mkdir -p assets/images/{logos,placeholders}

print_step "Creating test folders..."
mkdir -p test/{unit,widget,integration}

print_step "Creating scripts folder..."
mkdir -p scripts

print_success "Folder structure created"

# ============================================================================
# STEP 4: Create Core Constants
# ============================================================================

print_header "STEP 4/10: Creating Core Constants"

print_step "Creating app_colors.dart..."
cat > lib/core/constants/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

/// Application color palette
/// Following Material Design 3 guidelines
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899);
  static const Color accentLight = Color(0xFFF472B6);
  static const Color accentDark = Color(0xFFDB2777);

  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Input Colors
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputFocused = primary;

  // Shadow Colors
  static Color shadow = Colors.black.withOpacity(0.1);
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowDark = Colors.black.withOpacity(0.2);
}
EOF

print_step "Creating app_spacing.dart..."
cat > lib/core/constants/app_spacing.dart << 'EOF'
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive spacing system
/// Uses flutter_screenutil for responsive sizing
class AppSpacing {
  AppSpacing._();

  // Spacing Scale
  static double xxxs = 2.w;
  static double xxs = 4.w;
  static double xs = 8.w;
  static double sm = 12.w;
  static double md = 16.w;
  static double lg = 24.w;
  static double xl = 32.w;
  static double xxl = 48.w;
  static double xxxl = 64.w;

  // Common Padding
  static double screenPadding = md;
  static double cardPadding = md;
  static double buttonPadding = md;
}
EOF

print_step "Creating app_sizes.dart..."
cat > lib/core/constants/app_sizes.dart << 'EOF'
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive size constants
class AppSizes {
  AppSizes._();

  // Font Sizes (responsive)
  static double h1 = 32.sp;
  static double h2 = 28.sp;
  static double h3 = 24.sp;
  static double h4 = 20.sp;
  static double h5 = 18.sp;
  static double h6 = 16.sp;

  static double bodyLarge = 16.sp;
  static double bodyMedium = 14.sp;
  static double bodySmall = 12.sp;

  static double labelLarge = 14.sp;
  static double labelMedium = 12.sp;
  static double labelSmall = 10.sp;

  // Component Sizes
  static double buttonHeight = 48.h;
  static double buttonHeightSmall = 36.h;
  static double buttonHeightLarge = 56.h;

  static double inputHeight = 56.h;
  static double inputHeightSmall = 44.h;

  static double iconSize = 24.r;
  static double iconSizeSmall = 20.r;
  static double iconSizeLarge = 32.r;

  static double avatarSize = 48.r;
  static double avatarSizeSmall = 32.r;
  static double avatarSizeLarge = 72.r;

  // Border Radius
  static double radiusXS = 4.r;
  static double radiusSM = 8.r;
  static double radiusMD = 12.r;
  static double radiusLG = 16.r;
  static double radiusXL = 24.r;
  static double radiusFull = 999.r;

  // Elevation
  static double elevationSM = 2;
  static double elevationMD = 4;
  static double elevationLG = 8;
  static double elevationXL = 16;

  // App Bar
  static double appBarHeight = 56.h;

  // Bottom Navigation
  static double bottomNavHeight = 60.h;
}
EOF

print_step "Creating app_assets.dart..."
cat > lib/core/constants/app_assets.dart << 'EOF'
/// Asset paths for images, icons, animations, and fonts
class AppAssets {
  AppAssets._();

  // Images
  static const String _imagesPath = 'assets/images';
  static const String logo = '$_imagesPath/logos/logo.png';
  static const String logoWhite = '$_imagesPath/logos/logo_white.png';
  static const String placeholder = '$_imagesPath/placeholders/placeholder.png';
  static const String avatarPlaceholder = '$_imagesPath/placeholders/avatar.png';

  // Icons
  static const String _iconsPath = 'assets/icons';
  static const String homeIcon = '$_iconsPath/home.svg';
  static const String profileIcon = '$_iconsPath/profile.svg';

  // Animations
  static const String _animationsPath = 'assets/animations';
  static const String loadingAnimation = '$_animationsPath/loading.json';
  static const String successAnimation = '$_animationsPath/success.json';
  static const String errorAnimation = '$_animationsPath/error.json';

  // Fonts
  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Poppins';
}
EOF

print_step "Creating app_strings.dart..."
cat > lib/core/constants/app_strings.dart << 'EOF'
/// Application string constants
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Flutter App';
  static const String appVersion = '1.0.0';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String close = 'Close';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorServer = 'Server error. Please try again later.';

  // Validation
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email';
  static const String validationPassword = 'Password must be at least 8 characters';
  static const String validationPasswordMatch = 'Passwords do not match';
}
EOF

print_success "Core constants created"

# Continue in next message due to length...
print_info "Base structure created. Run the file generator script next..."
