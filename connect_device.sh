#!/bin/bash

echo "=== OnePlus 7T WiFi Debugging Setup ==="
echo ""
echo "Step 1: Enable Wireless Debugging on your device:"
echo "  Settings → Developer Options → Wireless Debugging → Enable"
echo ""
echo "Step 2: Tap 'Pair device with pairing code'"
echo ""
read -p "Enter the IP address shown (e.g., 192.168.1.100): " DEVICE_IP
read -p "Enter the port shown (e.g., 12345): " PORT

echo ""
echo "Connecting to device at $DEVICE_IP:$PORT..."
adb connect $DEVICE_IP:$PORT

echo ""
echo "Checking connected devices..."
adb devices

echo ""
echo "If device is listed, you can now run: flutter run"

