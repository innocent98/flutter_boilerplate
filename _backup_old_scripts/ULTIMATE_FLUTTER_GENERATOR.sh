#!/bin/bash

# ============================================================================
# ULTIMATE FLUTTER PROJECT GENERATOR - ALL-IN-ONE
# ============================================================================
# Creates a complete production-ready Flutter app in ONE command
# Run: ./ULTIMATE_FLUTTER_GENERATOR.sh my_app_name
# ============================================================================

set -e
exec 2>&1

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}" >&2; exit 1; }

[[ -z "$1" ]] && error "Usage: $0 <project_name> [org]"
command -v flutter >/dev/null 2>&1 || error "Flutter not found!"

PROJECT=$1
ORG=${2:-com.example}
[[ -d "$PROJECT" ]] && error "Directory '$PROJECT' exists!"

log "Creating Flutter project '$PROJECT'..."
flutter create "$PROJECT" --org "$ORG" >/dev/null 2>&1
cd "$PROJECT"

# Update pubspec.yaml
cat > pubspec.yaml << 'PUBSPEC'
name: PROJECT_NAME
description: Production-ready Flutter app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  auto_route: ^10.1.2
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  google_fonts: ^6.2.1
  flutter_screenutil: ^5.10.0
  dio: ^5.8.0
  shared_preferences: ^2.5.3
  logger: ^2.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.5.4
  auto_route_generator: ^10.1.2
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
PUBSPEC
sed -i.bak "s/PROJECT_NAME/$PROJECT/" pubspec.yaml && rm pubspec.yaml.bak

log "Installing dependencies..."
flutter pub get >/dev/null 2>&1

log "Creating directory structure..."
mkdir -p lib/core/{constants,theme,utils,widgets,routes,services}
mkdir -p lib/core/widgets/{buttons,inputs,common}
mkdir -p lib/features/{splash,home}/presentation/pages
mkdir -p assets/images

# Generate all source files
log "Generating source files..."

# Main.dart
cat > lib/main.dart << 'EOF'
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
      child: MaterialApp(
        title: 'Flutter App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
EOF

# Constants
cat > lib/core/constants/app_colors.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const border = Color(0xFFE2E8F0);
}
EOF

cat > lib/core/constants/app_sizes.dart << 'EOF'
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  static double h1 = 32.sp;
  static double h2 = 24.sp;
  static double body = 16.sp;
  static double caption = 12.sp;
  static double buttonHeight = 48.h;
  static double inputHeight = 56.h;
  static double iconSize = 24.r;
  static double radius = 12.r;
  static double spacing = 16.w;
}
EOF

# Theme
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
        ),
      ),
    );
  }
}
EOF

# Widgets - Buttons
cat > lib/core/widgets/buttons/primary_button.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
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
            : Text(label),
      ),
    );
  }
}
EOF

# Widgets - Inputs
cat > lib/core/widgets/inputs/app_text_field.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: TextStyle(fontSize: AppSizes.body)),
          SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
EOF

# Widgets - Common
cat > lib/core/widgets/common/loading_indicator.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}
EOF

# Utils
cat > lib/core/utils/validators.dart << 'EOF'
class Validators {
  static String? email(String? value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(value!) ? null : 'Invalid email';
  }

  static String? required(String? value) {
    return (value?.isEmpty ?? true) ? 'This field is required' : null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Password is required';
    return value!.length >= 8 ? null : 'Min 8 characters';
  }
}
EOF

cat > lib/core/utils/responsive.dart << 'EOF'
import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}
EOF

# Features - Splash
cat > lib/features/splash/presentation/pages/splash_page.dart << 'EOF'
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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 100, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Flutter App',
              style: TextStyle(
                fontSize: AppSizes.h1,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Features - Home
cat > lib/features/home/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: AppSizes.h1,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Your Flutter app is ready with industry-standard architecture.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              PrimaryButton(
                label: 'Get Started',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button pressed!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# Analysis options
cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: true
    prefer_single_quotes: true

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
EOF

# README
cat > README.md << 'EOF'
# Flutter Production Template

A production-ready Flutter application with industry best practices.

## Features

- ✅ Clean Architecture (Feature-first)
- ✅ Riverpod State Management
- ✅ Responsive Design (flutter_screenutil)
- ✅ Pre-built Widget Library
- ✅ Theme System
- ✅ Code Generation Ready
- ✅ Validation Utilities

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/     # Colors, sizes, strings
│   ├── theme/         # App theme configuration
│   ├── widgets/       # Reusable widgets
│   └── utils/         # Helper functions
└── features/
    ├── splash/        # Splash screen
    └── home/          # Home feature
```

## Available Widgets

- PrimaryButton
- AppTextField
- LoadingIndicator

## Utilities

- Validators (email, password, required)
- Responsive helpers

---

Generated with Flutter Template Generator
EOF

success "Project '$PROJECT' created successfully!"
success "Location: $(pwd)"
echo ""
echo "Next steps:"
echo "  cd $PROJECT"
echo "  flutter run"
echo ""
echo "Happy coding! 🚀"
