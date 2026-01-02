#!/bin/bash

set -e

echo "=== Barbera App - Device Installation ==="
echo ""

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found in PATH"
    echo "Please add Flutter to your PATH or run this script from a terminal where Flutter is available"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Step 1: Connect device (if IP provided)
if [ -n "$1" ]; then
    echo "📱 Connecting to device at $1..."
    adb connect $1
    sleep 2
else
    echo "📱 Checking connected devices..."
fi

adb devices

echo ""
echo "Step 1: Installing dependencies..."
flutter pub get

echo ""
echo "Step 2: Generating Hive adapters (required for compilation)..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "Step 3: Checking available devices..."
flutter devices

echo ""
echo "Step 4: Building and installing on device..."
flutter run --release

echo ""
echo "✅ App installation complete!"

