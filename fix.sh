#!/bin/bash

echo "🔍 Checking InsecureTokenGenerator.java for insecure Random usage..."

FILE="src/main/java/InsecureTokenGenerator.java"
VULN_LINE='Random random = new Random(); // 🚨 Insecure: predictable seed'
SAFE_LINE='SecureRandom secureRandom = new SecureRandom();'

if grep -q "$VULN_LINE" "$FILE"; then
    echo "🚨 Vulnerability found. Fixing..."
    sed -i "s|$VULN_LINE|$SAFE_LINE|" "$FILE"
    sed -i "s|random.nextInt|secureRandom.nextInt|g" "$FILE"
    sed -i "s|import java.util.Random;|import java.security.SecureRandom;|" "$FILE"

    git config --global user.name "AutoFix Bot"
    git config --global user.email "autofix@bot.com"
    git add "$FILE"
    git commit -m "Fix: replaced insecure Random with SecureRandom"
else
    echo "✅ No vulnerable code found."
fi
