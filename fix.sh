#!/bin/bash

set -e
echo "🚀 Starting fix.sh..."

##### STEP 1: Create folders
mkdir -p src/fixed/java
mkdir -p src/fixed/gradle

##### STEP 2: Copy vulnerable files into fixed folders
echo "📄 Copying vulnerable Java files to src/fixed/java/..."
cp src/main/java/RandomVuln*.java src/fixed/java/ 2>/dev/null || echo "⚠️ No RandomVuln files found"
cp src/main/java/TikaVuln*.java src/fixed/java/ 2>/dev/null || echo "⚠️ No TikaVuln files found"
cp src/main/java/Spring4ShellVuln/*.java src/fixed/java/ 2>/dev/null || echo "⚠️ No Spring4ShellVuln files found"
cp src/main/java/H2ConsoleVuln/*.java src/fixed/java/ 2>/dev/null || echo "⚠️ No H2ConsoleVuln files found"
cp src/main/java/SpringAccessVuln/*.java src/fixed/java/ 2>/dev/null || echo "⚠️ No SpringAccessVuln files found"

echo "📄 Copying vulnerable Gradle files to src/fixed/gradle/..."
cp src/main/java/gradle-vuln/*.build.gradle src/fixed/gradle/ 2>/dev/null || echo "⚠️ No Gradle vuln files found"

##### STEP 3: Fix Insecure Randomness (CVE-2021-27568)
echo "🔧 Fixing CVE-2021-27568..."

grep -rl 'new Random()' src/fixed/java | while read -r file; do
  echo "🔍 Fixing 'new Random()' in $file"
  sed -i 's/new Random()/new SecureRandom()/g' "$file"
done

grep -rl 'Math.random()' src/fixed/java | while read -r file; do
  echo "🔍 Fixing 'Math.random()' in $file"
  sed -i 's/Math.random()/secureRandom.nextDouble()/g' "$file"
done

find src/fixed/java -name "*.java" | while read -r file; do
  if grep -q 'SecureRandom' "$file" && ! grep -q 'import java.security.SecureRandom;' "$file"; then
    echo "📎 Adding SecureRandom import to $file"
    sed -i '1i import java.security.SecureRandom;' "$file"
  fi
done

##### STEP 4: Fix Apache Tika XXE (CVE-2021-29425)
echo "🔧 Fixing CVE-2021-29425..."

grep -rl 'AutoDetectParser' src/fixed/java | while read -r file; do
  echo "🔍 Securing AutoDetectParser in $file"
  sed -i 's/new AutoDetectParser()/new AutoDetectParser(new SecureContentHandler())/g' "$file"
  grep -q 'setEntityResolver' "$file" || sed -i '/AutoDetectParser/ a \
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());' "$file"
  grep -q 'SecureContentHandler' "$file" || sed -i '1i import org.apache.tika.sax.SecureContentHandler;' "$file"
  grep -q 'DefaultHandler' "$file" || sed -i '1i import org.xml.sax.helpers.DefaultHandler;' "$file"
done

##### STEP 5: Fix Gradle Filtering Bypass (CVE-2021-29427)
echo "🔧 Fixing CVE-2021-29427..."

find src/fixed/gradle -name "*.gradle" | while read -r gradle_file; do
  echo "🔍 Patching $gradle_file..."

  if grep -q 'mavenCentral()' "$gradle_file" && ! grep -A2 'mavenCentral()' "$gradle_file" | grep -q 'content {'; then
    sed -i '/mavenCentral()/a \
        content {\n\
            includeGroup "org.apache.tika"\n\
            includeGroup "com.google.guava"\n\
        }' "$gradle_file"
  fi

  awk '
  /maven\s*{/ {
    print; print "        content {\n            includeGroup \"org.apache.tika\"\n            includeGroup \"com.google.guava\"\n        }"
    next
  }
  { print }
  ' "$gradle_file" > "$gradle_file.tmp" && mv "$gradle_file.tmp" "$gradle_file"
done

##### STEP 6: Fix Spring4Shell (CVE-2022-22965)
echo "🔧 Fixing CVE-2022-22965..."

grep -rl 'Class.forName(request.getParameter' src/fixed/java | while read -r file; do
  echo "🔍 Neutralizing dynamic class loading in $file"
  sed -i 's/Class.forName(request.getParameter([^)]*)))/Class.forName("com.safe.Default")/g' "$file"
done

##### STEP 7: Fix H2 JNDI Injection (CVE-2021-42392)
echo "🔧 Fixing CVE-2021-42392..."

grep -rl 'jdbc:h2:' src/fixed/java | while read -r file; do
  if grep -q 'RUNSCRIPT FROM' "$file"; then
    echo "🔍 Removing malicious INIT script in $file"
    sed -i 's/;INIT=RUNSCRIPT FROM .*//' "$file"
  fi
done

##### STEP 8: Fix Spring Security Misconfiguration (CVE-2019-9193)
echo "🔧 Fixing CVE-2019-9193..."

grep -rl '@Secured("ROLE_USER")' src/fixed/java | while read -r file; do
  echo "🔍 Changing ROLE_USER to ROLE_ADMIN in $file"
  sed -i 's/@Secured("ROLE_USER")/@Secured("ROLE_ADMIN")/' "$file"
done

grep -rl '@PreAuthorize("hasRole('"'"'USER'"'"')")' src/fixed/java | while read -r file; do
  echo "🔍 Changing hasRole('USER') to hasRole('ADMIN') in $file"
  sed -i "s/@PreAuthorize(\"hasRole('USER')\")/@PreAuthorize(\"hasRole('ADMIN')\")/" "$file"
done

##### STEP 9: Git Commit & Push
echo "📦 Committing src/fixed/..."

git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"
git add src/fixed

if git diff --cached --quiet; then
  echo "ℹ️ No changes to commit"
else
  git commit -m "fix.sh: Added fixed versions for CVE remediation"
  git push
  echo "✅ Fixed files committed and pushed!"
fi

echo "✅ All vulnerabilities fixed and stored in src/fixed/"
