#!/bin/bash

# ============================================================================
# FLUTTER INDUSTRY STANDARD PROJECT GENERATOR v2.0
# ============================================================================
# Creates a complete production-ready Flutter project in one command
# Usage: ./GENERATE_FLUTTER_APP.sh my_app [com.organization]
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

log() { echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ ERROR: $1${NC}" >&2; exit 1; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Validation
[[ -z "$1" ]] && error "Usage: $0 <project_name> [organization]\nExample: $0 my_app com.company"
command -v flutter >/dev/null 2>&1 || error "Flutter is not installed!"

PROJECT=$1
ORG=${2:-com.example}
PROJECT_DIR="$(pwd)/$PROJECT"

[[ -d "$PROJECT" ]] && error "Directory '$PROJECT' already exists!"

# Display banner
print_header "Flutter Industry Standard Project Generator v2.0"
echo "  📦 Project Name: $PROJECT"
echo "  🏢 Organization: $ORG"
echo "  📱 Flutter Version: $(flutter --version | head -n 1 | awk '{print $2}')"
echo "  📂 Output: $PROJECT_DIR"
echo ""
echo "  This will create a production-ready app with:"
echo "  ✓ Clean Architecture"
echo "  ✓ Riverpod State Management"
echo "  ✓ Responsive Design System"
echo "  ✓ Pre-built Widget Library"
echo "  ✓ Complete Theme System"
echo ""
read -p "Continue? (Y/n) " -n 1 -r
echo ""
[[ $REPLY =~ ^[Nn]$ ]] && { warn "Cancelled"; exit 0; }

# ============================================================================
# STEP 1: Create Base Project
# ============================================================================

print_header "STEP 1/8: Creating Base Flutter Project"
log "Running flutter create..."
flutter create "$PROJECT" --org "$ORG" --platforms=android,ios,web > /dev/null 2>&1
cd "$PROJECT"
success "Base project created"

# ============================================================================
# STEP 2: Create Folder Structure
# ============================================================================

print_header "STEP 2/8: Creating Folder Structure"
log "Creating directories..."

mkdir -p lib/core/{constants,theme,utils,widgets,routes,services}
mkdir -p lib/core/widgets/{buttons,inputs,common}
mkdir -p lib/features/{splash,home}/presentation/pages
mkdir -p assets/images

success "Folder structure created"

# ============================================================================
# STEP 3: Update pubspec.yaml
# ============================================================================

print_header "STEP 3/8: Configuring Dependencies"
log "Updating pubspec.yaml..."

cat > pubspec.yaml << PUBSPEC
name: $PROJECT
description: A production-ready Flutter application.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management
  flutter_riverpod: ^2.6.1

  # UI & Styling
  google_fonts: ^6.2.1
  flutter_screenutil: ^5.10.0

  # Utilities
  shared_preferences: ^2.5.3
  logger: ^2.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
PUBSPEC

log "Installing dependencies..."
flutter pub get > /dev/null 2>&1
success "Dependencies configured"

# ============================================================================
# STEP 4: Generate Core Files
# ============================================================================

print_header "STEP 4/8: Generating Core Files"

# app_colors.dart
log "Creating app_colors.dart..."
cat > lib/core/constants/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

/// Application color palette following Material Design 3
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF8B5CF6);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
}
EOF

# app_sizes.dart
log "Creating app_sizes.dart..."
cat > lib/core/constants/app_sizes.dart << 'EOF'
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive size constants using flutter_screenutil
class AppSizes {
  AppSizes._();

  // Font Sizes (responsive)
  static double h1 = 32.sp;
  static double h2 = 28.sp;
  static double h3 = 24.sp;
  static double h4 = 20.sp;
  static double body = 16.sp;
  static double bodySmall = 14.sp;
  static double caption = 12.sp;

  // Component Sizes
  static double buttonHeight = 48.h;
  static double inputHeight = 56.h;
  static double iconSize = 24.r;
  static double iconSmall = 20.r;
  static double iconLarge = 32.r;

  // Spacing
  static double spacing = 16.w;
  static double spacingSmall = 8.w;
  static double spacingLarge = 24.w;

  // Border Radius
  static double radius = 12.r;
  static double radiusSmall = 8.r;
  static double radiusLarge = 16.r;

  // Elevation
  static double elevation = 4;
}
EOF

success "Core constants created"

# ============================================================================
# STEP 5: Generate Theme Files
# ============================================================================

print_header "STEP 5/8: Generating Theme System"

# app_theme.dart
log "Creating app_theme.dart..."
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      textTheme: GoogleFonts.interTextTheme(),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: AppSizes.h4,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacing,
          vertical: AppSizes.spacing,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: AppSizes.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
      ),
    );
  }
}
EOF

success "Theme system created"

# ============================================================================
# STEP 6: Generate Utility Files
# ============================================================================

print_header "STEP 6/8: Generating Utility Files"

# validators.dart
log "Creating validators.dart..."
cat > lib/core/utils/validators.dart << 'EOF'
class Validators {
  Validators._();

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
EOF

# responsive.dart
log "Creating responsive.dart..."
cat > lib/core/utils/responsive.dart << 'EOF'
import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}
EOF

success "Utility files created"

# ============================================================================
# STEP 7: Generate Widget Library
# ============================================================================

print_header "STEP 7/8: Generating Widget Library"

# Continue in next part...
echo "Generating widgets..."

# primary_button.dart
log "Creating primary_button.dart..."
cat > lib/core/widgets/buttons/primary_button.dart << 'WIDGET_EOF'
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSizes.iconSmall),
                    SizedBox(width: AppSizes.spacingSmall),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
WIDGET_EOF

# app_text_field.dart
log "Creating app_text_field.dart..."
cat > lib/core/widgets/inputs/app_text_field.dart << 'WIDGET_EOF'
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: AppSizes.bodySmall,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
WIDGET_EOF

# loading_indicator.dart
log "Creating loading_indicator.dart..."
cat > lib/core/widgets/common/loading_indicator.dart << 'WIDGET_EOF'
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
WIDGET_EOF

success "Widget library created (3 widgets)"

# ============================================================================
# STEP 8: Generate Feature Pages
# ============================================================================

print_header "STEP 8/8: Generating Feature Pages"

# splash_page.dart
log "Creating splash_page.dart..."
cat > lib/features/splash/presentation/pages/splash_page.dart << 'PAGE_EOF'
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: AppSizes.spacingLarge),
            Text(
              'Flutter App',
              style: TextStyle(
                fontSize: AppSizes.h1,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              'Production Ready',
              style: TextStyle(
                fontSize: AppSizes.body,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
PAGE_EOF

# home_page.dart
log "Creating home_page.dart..."
cat > lib/features/home/presentation/pages/home_page.dart << 'PAGE_EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/utils/validators.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form is valid! Email: ${_emailController.text}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacing),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.spacingLarge),
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppSizes.spacingLarge),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: AppSizes.h1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.spacingSmall),
                Text(
                  'Your Flutter app is ready with industry-standard architecture, responsive design, and pre-built components.',
                  style: TextStyle(
                    fontSize: AppSizes.body,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.spacingLarge * 2),
                Text(
                  'Try the Form:',
                  style: TextStyle(
                    fontSize: AppSizes.h4,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacing),
                AppTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  controller: _emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingLarge),
                PrimaryButton(
                  label: 'Validate',
                  icon: Icons.check,
                  onPressed: _handleSubmit,
                ),
                SizedBox(height: AppSizes.spacingLarge * 2),
                _buildFeatureList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Clean Architecture (Feature-First)',
      'Riverpod State Management',
      'Responsive Design System',
      'Pre-built Widget Library',
      'Form Validation',
      'Theme System',
      'Best Practices',
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Included Features:',
              style: TextStyle(
                fontSize: AppSizes.h4,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.spacing),
            ...features.map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.spacingSmall),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: AppSizes.iconSmall,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppSizes.spacingSmall),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(fontSize: AppSizes.bodySmall),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
PAGE_EOF

success "Feature pages created"

# ============================================================================
# STEP 9: Update main.dart
# ============================================================================

print_header "Finalizing Setup"

log "Updating main.dart..."
cat > lib/main.dart << 'MAIN_EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      child: const SplashPage(),
    );
  }
}
MAIN_EOF

success "main.dart updated"

# ============================================================================
# Complete!
# ============================================================================

print_header "✨ Project Generated Successfully!"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Your Flutter project is ready!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📂 Location: $PROJECT_DIR"
echo ""
echo "🚀 Next steps:"
echo "   1. cd $PROJECT"
echo "   2. flutter run"
echo ""
echo "📚 What's included:"
echo "   ✓ Clean Architecture"
echo "   ✓ Riverpod State Management"
echo "   ✓ Responsive Design (flutter_screenutil)"
echo "   ✓ Pre-built Widgets (Buttons, Inputs, Loading)"
echo "   ✓ Form Validation Utilities"
echo "   ✓ Theme System with Google Fonts"
echo "   ✓ Splash Screen & Home Page"
echo ""
echo "💡 Tips:"
echo "   • Add new features in lib/features/"
echo "   • Use AppColors and AppSizes for consistency"
echo "   • All widgets are reusable and customizable"
echo ""
echo -e "${CYAN}Happy Coding! 🎉${NC}"
echo ""

