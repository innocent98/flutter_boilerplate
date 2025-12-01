# 🚀 Quick Start Guide - Flutter Project Generator

## One-Command Setup

Generate a complete production-ready Flutter project in **under 2 minutes**:

```bash
./GENERATE_FLUTTER_APP.sh my_app_name
```

That's it! 🎉

## What You Get

A fully-functional Flutter app with:

- ✅ **Clean Architecture** - Feature-first organization
- ✅ **Riverpod** - Modern state management
- ✅ **Responsive Design** - Works on all screen sizes
- ✅ **Pre-built Widgets** - Ready-to-use components
- ✅ **Theme System** - Consistent design
- ✅ **Form Validation** - Built-in validators
- ✅ **Latest Flutter** - Always up-to-date

## Usage

### Basic Usage
```bash
./GENERATE_FLUTTER_APP.sh my_app
```

### With Custom Organization
```bash
./GENERATE_FLUTTER_APP.sh my_app com.mycompany
```

## Running Your App

```bash
cd my_app
flutter run
```

## Project Structure

```
my_app/
├── lib/
│   ├── core/
│   │   ├── constants/         # Colors, sizes
│   │   ├── theme/             # App theme
│   │   ├── widgets/           # Reusable widgets
│   │   │   ├── buttons/       # PrimaryButton
│   │   │   ├── inputs/        # AppTextField
│   │   │   └── common/        # LoadingIndicator
│   │   └── utils/             # Validators, Responsive
│   ├── features/
│   │   ├── splash/            # Splash screen
│   │   └── home/              # Home page with demo
│   └── main.dart
└── assets/
```

## Available Components

### Buttons
```dart
PrimaryButton(
  label: 'Submit',
  icon: Icons.check,
  onPressed: () {},
  isLoading: false,
)
```

### Inputs
```dart
AppTextField(
  label: 'Email',
  hint: 'Enter email',
  validator: Validators.email,
  prefixIcon: Icon(Icons.email),
)
```

### Validators
```dart
Validators.email(value)       // Email validation
Validators.password(value)    // Min 8 characters
Validators.required(value)    // Required field
Validators.phone(value)       // Phone number
```

### Theme
```dart
AppColors.primary            // Brand color
AppColors.textPrimary        // Text color
AppSizes.h1                  // Heading size (32sp)
AppSizes.spacing             // Standard spacing (16w)
AppSizes.radius              // Border radius (12r)
```

### Responsive Helpers
```dart
if (Responsive.isMobile(context)) {
  // Mobile layout
}
```

## Adding New Features

1. **Create feature folder:**
```bash
mkdir -p lib/features/profile/presentation/pages
```

2. **Create your page:**
```dart
class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Page')),
    );
  }
}
```

## Customization

### Change Primary Color
Edit `lib/core/constants/app_colors.dart`:
```dart
static const Color primary = Color(0xFFYOURCOLOR);
```

### Change Font
Edit `lib/core/theme/app_theme.dart`:
```dart
textTheme: GoogleFonts.robotoTextTheme(),  // or any Google Font
```

### Add More Widgets
Create in `lib/core/widgets/`:
```dart
// lib/core/widgets/buttons/secondary_button.dart
class SecondaryButton extends StatelessWidget {
  // Your implementation
}
```

## Tips

1. **Always use constants:**
   ```dart
   // ❌ Don't
   fontSize: 16
   color: Color(0xFF6366F1)

   // ✅ Do
   fontSize: AppSizes.body
   color: AppColors.primary
   ```

2. **Use pre-built widgets:**
   - Saves time
   - Ensures consistency
   - Easy to maintain

3. **Follow feature-first structure:**
   - Keep features isolated
   - Easy to test
   - Scalable

## Troubleshooting

### "Command not found"
Make script executable:
```bash
chmod +x GENERATE_FLUTTER_APP.sh
```

### "Flutter not found"
Install Flutter: https://flutter.dev/docs/get-started/install

### "Directory exists"
```bash
rm -rf my_app  # or choose a different name
```

## What's Next?

- Add authentication feature
- Connect to API
- Add more screens
- Implement state management
- Write tests

## Full Documentation

See `FLUTTER_TEMPLATE_GUIDE.md` for complete documentation.

---

**Questions?** Check the guide or open an issue.

**Happy Coding!** 🎉
