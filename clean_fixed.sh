#!/bin/bash

echo "🧹 Cleaning up fixed files and folders..."

# Check if the fixed folder exists before deleting
if [ -d "src/fixed" ]; then
  rm -rf src/fixed
  echo "✅ Deleted src/fixed folder"
else
  echo "⚠️ No src/fixed folder to delete"
fi

# Set git identity
git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"

# Stage, commit, and push changes
git add -A
git commit -m "
