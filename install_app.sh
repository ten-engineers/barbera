#!/bin/bash

set -e

echo "=== Installing Barbera App on OnePlus 7T ==="
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please ensure Flutter is in your PATH."
    exit 1
fi

echo "✅ Flutter: $(flutter --version | head -1)"
echo ""

# Check device
echo "📱 Checking connected device..."
if ! adb devices | grep -q "device$"; then
    echo "❌ No device connected. Please connect your device via USB."
    exit 1
fi

echo "✅ Device connected: $(adb devices | grep device | grep -v List)"
echo ""

# Step 1: Install dependencies
echo "Step 1: Installing Flutter dependencies..."
flutter pub get

# Step 2: Generate Hive adapters (REQUIRED)
echo ""
echo "Step 2: Generating Hive adapters (required for compilation)..."
flutter pub run build_runner build --delete-conflicting-outputs

# Step 3: Verify device
echo ""
echo "Step 3: Verifying Flutter can see device..."
flutter devices

# Step 4: Build and install
echo ""
echo "Step 4: Building and installing app on device..."
echo "This may take a few minutes on first build..."
flutter run --release

echo ""
echo "✅ Installation complete! App should be running on your device."

