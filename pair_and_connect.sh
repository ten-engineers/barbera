#!/bin/bash

echo "=== Pairing OnePlus 7T ==="
echo ""
echo "Pairing with device at 192.168.8.60:37713"
echo "When prompted, enter pairing code: 275237"
echo ""
adb pair 192.168.8.60:37713

echo ""
echo "=== Checking for connection port ==="
echo "After pairing, check your device's Wireless Debugging screen"
echo "You should see a new IP:PORT for connecting (different from 37713)"
echo ""
read -p "Enter the connection IP:PORT (e.g., 192.168.8.60:XXXXX): " CONNECTION_PORT

if [ -n "$CONNECTION_PORT" ]; then
    echo ""
    echo "Connecting to $CONNECTION_PORT..."
    adb connect $CONNECTION_PORT
    
    echo ""
    echo "Checking connected devices..."
    adb devices
else
    echo "No connection port provided. Please run manually:"
    echo "  adb connect <IP:PORT>"
fi

