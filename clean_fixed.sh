#!/bin/bash

echo "🧹 Cleaning up fixed files and folders..."

# Check if the fixed folder exists
if [ -d "src/fixed" ]; then
  rm -rf src/fixed
  echo "✅ Deleted src/fixed folder"
else
  echo "⚠️ No src/fixed folder to delete"
fi

# Git identity
git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"

# Commit and push cleanup
git add -A
git commit -m "🧹 Cleanup: Removed all fixed versions"
git push
