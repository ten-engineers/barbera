#!/bin/bash

echo "=== Connecting to OnePlus 7T ==="
echo ""

# Step 1: Pair
echo "Step 1: Pairing device..."
echo "When prompted, enter pairing code: 978432"
adb pair 192.168.8.60:37713

# Wait a moment
sleep 2

# Step 2: Connect
echo ""
echo "Step 2: Connecting to device..."
adb connect 192.168.8.60:38689

# Step 3: Verify
echo ""
echo "Step 3: Checking connected devices..."
adb devices

echo ""
echo "If device is listed above, connection successful!"
echo "You can now run: flutter run"

