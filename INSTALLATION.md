# 📦 Installation Guide - Flutter Boilerplate Generator

This guide covers how to install and use the Flutter Boilerplate Generator as a global command on your system.

---

## 🎯 Quick Installation

### Step 1: Navigate to the boilerplate directory
```bash
cd /path/to/flutter_boilerplate
```

### Step 2: Run the installer
```bash
./install.sh
```

### Step 3: Verify installation
```bash
flutter-gen --help
```

That's it! You can now use `flutter-gen` from anywhere on your system.

---

## 📖 Detailed Installation Steps

### Prerequisites

Before installing, ensure you have:
- ✅ macOS or Linux operating system
- ✅ Flutter SDK installed and in PATH
- ✅ Bash shell access
- ✅ `sudo` privileges (for installing to `/usr/local/bin`)

### Installation Process

1. **Clone or download the flutter_boilerplate directory**
   ```bash
   cd ~/Documents/mobile/flutter_boilerplate
   ```

2. **Make the installer executable (if not already)**
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation script**
   ```bash
   ./install.sh
   ```

   You'll see output like:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Flutter Boilerplate Generator - Installation
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ℹ Checking prerequisites...
   ✓ Generator script found
   ✓ Operating system supported: darwin
   ✓ Command installed successfully
   ✓ Command 'flutter-gen' is available globally
   ```

4. **The installer will:**
   - ✅ Check if the generator script exists
   - ✅ Verify your operating system is supported
   - ✅ Check for existing installations
   - ✅ Create a wrapper script in `/usr/local/bin/flutter-gen`
   - ✅ Set proper executable permissions
   - ✅ Verify the command is available in PATH

5. **Confirm installation**
   ```bash
   which flutter-gen
   # Output: /usr/local/bin/flutter-gen
   ```

---

## 🚀 Usage After Installation

### Generate a New Project

Simply run from any directory:

```bash
flutter-gen
```

Or with a project name:

```bash
flutter-gen my_awesome_app
```

### Example Workflow

```bash
# Navigate to your projects directory
cd ~/Documents/mobile

# Generate a new Flutter project
flutter-gen

# Follow the interactive prompts:
# - Enter project name: my_app
# - Enter description: My awesome app
# - Enter author: John Doe

# Navigate to the new project
cd my_app

# Run the app
flutter run
```

---

## 🔧 How It Works

### Architecture

The installation creates a **wrapper script** at `/usr/local/bin/flutter-gen` that:

1. **Points to the original generator script** in your flutter_boilerplate directory
2. **Passes all arguments** to the generator script
3. **Maintains a stable reference** even if you update the generator

### Directory Structure After Installation

```
/usr/local/bin/
└── flutter-gen (wrapper script)
    ↓ calls
~/Documents/mobile/flutter_boilerplate/
└── GENERATE_FLUTTER_APP.sh (actual generator)
```

### Important Notes

⚠️ **Do NOT move or delete the flutter_boilerplate directory** after installation, as the global command references it.

✅ **You CAN update the generator script** and changes will be reflected immediately without reinstalling.

---

## 🔄 Updating the Generator

If you make changes to `GENERATE_FLUTTER_APP.sh`:

1. **No reinstallation needed** - Changes take effect immediately
2. **Test your changes** by running `flutter-gen`
3. **All new projects** will use the updated generator

Example:
```bash
cd ~/Documents/mobile/flutter_boilerplate
# Edit GENERATE_FLUTTER_APP.sh
nano GENERATE_FLUTTER_APP.sh

# Changes are live immediately
flutter-gen
```

---

## 🗑️ Uninstallation

### Quick Uninstall

```bash
cd ~/Documents/mobile/flutter_boilerplate
./uninstall.sh
```

### Manual Uninstall

If you need to remove the command manually:

```bash
sudo rm /usr/local/bin/flutter-gen
```

### Complete Removal

To remove everything including the boilerplate directory:

```bash
# Uninstall the command
cd ~/Documents/mobile/flutter_boilerplate
./uninstall.sh

# Delete the boilerplate directory
cd ..
rm -rf flutter_boilerplate
```

---

## 🐛 Troubleshooting

### Issue: "Command not found: flutter-gen"

**Causes:**
1. Installation failed or was interrupted
2. `/usr/local/bin` is not in your PATH
3. Terminal needs to be restarted

**Solutions:**

1. **Reinstall:**
   ```bash
   cd ~/Documents/mobile/flutter_boilerplate
   ./install.sh
   ```

2. **Check PATH:**
   ```bash
   echo $PATH | grep "/usr/local/bin"
   ```

   If not found, add to your `~/.zshrc` or `~/.bashrc`:
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

3. **Restart terminal or reload shell:**
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

### Issue: "Permission denied"

**Solution:**
Make sure the installer script is executable:
```bash
chmod +x install.sh
./install.sh
```

### Issue: "Generator script not found"

**Cause:** The flutter_boilerplate directory was moved or deleted after installation.

**Solution:**
1. Move the directory back to its original location, or
2. Reinstall from the new location:
   ```bash
   ./uninstall.sh
   ./install.sh
   ```

### Issue: Installation hangs on "Checking prerequisites"

**Solution:**
1. Press `Ctrl+C` to cancel
2. Check if `GENERATE_FLUTTER_APP.sh` exists:
   ```bash
   ls -la GENERATE_FLUTTER_APP.sh
   ```
3. Make sure you're in the correct directory:
   ```bash
   pwd
   ```

### Issue: "Already installed" warning

**Solution:**
The installer will prompt you to overwrite. Choose:
- `y` - Overwrite and update the installation
- `n` - Cancel and keep existing installation

---

## 🔒 Security Considerations

### What Gets Installed

The installer:
- ✅ Only creates a single file in `/usr/local/bin`
- ✅ Does NOT modify system files
- ✅ Does NOT install background services
- ✅ Does NOT require full disk access
- ✅ Uses `sudo` only for writing to `/usr/local/bin`

### Permissions

- The wrapper script has `755` permissions (read/execute for all, write for owner)
- The script runs with your user permissions (not root)
- No elevated privileges are retained after installation

---

## 💡 Advanced Usage

### Custom Installation Location

If you prefer a different installation directory:

**Edit `install.sh` before running:**
```bash
nano install.sh
# Change: INSTALL_DIR="/usr/local/bin"
# To:     INSTALL_DIR="$HOME/bin"
```

**Then install:**
```bash
./install.sh
```

**Add to PATH (if using `~/bin`):**
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Custom Command Name

**Edit `install.sh` before running:**
```bash
nano install.sh
# Change: COMMAND_NAME="flutter-gen"
# To:     COMMAND_NAME="my-flutter-gen"
```

### Using with Multiple Versions

Keep multiple boilerplate versions:

```bash
# Install version 1
cd ~/flutter_boilerplate_v1
./install.sh
# Creates: /usr/local/bin/flutter-gen

# Install version 2 with custom name
cd ~/flutter_boilerplate_v2
# Edit install.sh: COMMAND_NAME="flutter-gen-v2"
./install.sh
# Creates: /usr/local/bin/flutter-gen-v2
```

---

## 📊 Comparison: Global vs Local

| Aspect | Global Install | Local Script |
|--------|---------------|--------------|
| **Convenience** | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Usage** | From anywhere | Must be in directory |
| **Updates** | Automatic | Manual copy |
| **Team Sharing** | Easy to document | Need full path |
| **Professional** | ✅ Yes | ⚠️ Less so |

---

## ✅ Best Practices

1. **Keep the boilerplate directory in a stable location**
   ```bash
   # Good locations:
   ~/tools/flutter_boilerplate
   ~/dev/flutter_boilerplate
   ~/Documents/flutter_boilerplate
   ```

2. **Don't move the directory after installation**
   - If you must move it, uninstall and reinstall

3. **Use version control for the boilerplate**
   ```bash
   cd flutter_boilerplate
   git init
   git add .
   git commit -m "Initial boilerplate version"
   ```

4. **Document the installation for your team**
   ```markdown
   # Team Setup
   1. Clone the repo
   2. cd flutter_boilerplate
   3. ./install.sh
   4. Run: flutter-gen
   ```

---

## 🤝 Sharing with Your Team

### Method 1: Git Repository

```bash
# Push to your team's repo
cd flutter_boilerplate
git remote add origin https://github.com/yourteam/flutter-boilerplate.git
git push -u origin main

# Team members install:
git clone https://github.com/yourteam/flutter-boilerplate.git
cd flutter_boilerplate
./install.sh
```

### Method 2: Documentation

Share these instructions with your team:

```markdown
## Install Flutter Project Generator

1. Clone the boilerplate:
   git clone https://github.com/yourteam/flutter-boilerplate.git
   cd flutter_boilerplate

2. Install globally:
   ./install.sh

3. Generate new projects:
   flutter-gen
```

---

## 📞 Support

### If you encounter issues:

1. **Check this guide** - Most common issues are covered above
2. **Check installation logs** - The installer provides detailed output
3. **Verify Flutter installation** - Run `flutter doctor`
4. **Check file permissions** - Ensure scripts are executable
5. **Try reinstalling** - Run `./uninstall.sh` then `./install.sh`

---

## 🎉 Success Checklist

After installation, you should be able to:

- [ ] Run `flutter-gen` from any directory
- [ ] See the interactive project generator
- [ ] Generate a test project
- [ ] Run `flutter run` in the generated project
- [ ] Generate projects with custom names

If all checks pass, you're ready to build amazing Flutter apps! 🚀

---

**Made with ❤️ for the Flutter community**

Happy coding! 🎯
