#!/bin/bash

# ============================================================================
# Cleanup Script - Remove Old/Experimental Files
# ============================================================================
# This removes all the old development scripts, keeping only what you need
# ============================================================================

echo "🧹 Cleaning up old files from flutter_boilerplate..."
echo ""

# Files to delete (old development iterations)
OLD_FILES=(
    "create_flutter_template.sh"
    "flutter_project_generator.sh"
    "flutter_template_complete.sh"
    "generate_template_files.sh"
    "generate_widgets.sh"
    "ULTIMATE_FLUTTER_GENERATOR.sh"
)

echo "The following files will be removed:"
for file in "${OLD_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ❌ $file"
    fi
done

echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create backup folder
    mkdir -p _backup_old_scripts

    # Move files to backup
    for file in "${OLD_FILES[@]}"; do
        if [ -f "$file" ]; then
            mv "$file" _backup_old_scripts/
            echo "✅ Moved $file to _backup_old_scripts/"
        fi
    done

    echo ""
    echo "✅ Cleanup complete!"
    echo ""
    echo "📂 Old files backed up to: _backup_old_scripts/"
    echo ""
    echo "Remaining files:"
    ls -lh *.sh *.md *.txt 2>/dev/null
    echo ""
    echo "You can now use: ./GENERATE_FLUTTER_APP.sh"
    echo ""
else
    echo "Cancelled. No files were removed."
fi
