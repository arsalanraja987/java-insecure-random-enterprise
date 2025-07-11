#!/bin/bash
echo "🛠️ Compiling Java..."
mkdir -p out && javac -d out src/main/java/*.java

echo "▶️ Running Java Program..."
java -cp out InsecureTokenGenerator
