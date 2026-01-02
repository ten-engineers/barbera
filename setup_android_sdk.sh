#!/bin/bash

# Setup Android SDK Platform 34
# This script installs Android SDK Platform 34 so Flutter doesn't need to download it every time

set -e

ANDROID_SDK_PATH="/opt/homebrew/Caskroom/android-platform-tools/36.0.0"
PLATFORMS_DIR="$ANDROID_SDK_PATH/platforms"
PLATFORM_34_DIR="$PLATFORMS_DIR/android-34"

echo "=== Setting up Android SDK Platform 34 ==="
echo ""

# Create platforms directory if it doesn't exist
mkdir -p "$PLATFORMS_DIR"

# Check if Platform 34 is already installed
if [ -d "$PLATFORM_34_DIR" ]; then
    echo "✅ Android SDK Platform 34 is already installed at: $PLATFORM_34_DIR"
    exit 0
fi

echo "⚠️  Android SDK Platform 34 is not installed."
echo ""
echo "To install it properly, you have two options:"
echo ""
echo "Option 1: Install Android Studio (Recommended)"
echo "  - Download from: https://developer.android.com/studio"
echo "  - Android Studio includes the full Android SDK with all platforms"
echo ""
echo "Option 2: Install Android SDK Command Line Tools"
echo "  - Download from: https://developer.android.com/studio#command-line-tools-only"
echo "  - Extract to: $ANDROID_SDK_PATH/cmdline-tools"
echo "  - Then run: sdkmanager \"platforms;android-34\""
echo ""
echo "For now, Flutter will download Platform 34 automatically during the first build."
echo "The license has been accepted, so it won't prompt you."

