#!/bin/bash

# Script to connect Android device wirelessly for Flutter development
# Usage: ./connect_wireless.sh [IP_ADDRESS] [PORT] [PAIRING_CODE]

if [ $# -eq 3 ]; then
    # Pairing mode
    IP=$1
    PORT=$2
    CODE=$3
    echo "Pairing device at $IP:$PORT with code $CODE..."
    adb pair $IP:$PORT <<< "$CODE"
elif [ $# -eq 2 ]; then
    # Connection mode (already paired)
    IP=$1
    PORT=$2
    echo "Connecting to device at $IP:$PORT..."
    adb connect $IP:$PORT
else
    echo "Usage:"
    echo "  To pair:   ./connect_wireless.sh [IP] [PAIRING_PORT] [PAIRING_CODE]"
    echo "  To connect: ./connect_wireless.sh [IP] [CONNECTION_PORT]"
    echo ""
    echo "Example:"
    echo "  ./connect_wireless.sh 192.168.1.100 12345 123456"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✓ Connected successfully!"
    echo ""
    echo "Checking devices..."
    adb devices
    echo ""
    echo "You can now run: flutter run"
else
    echo "✗ Connection failed. Make sure:"
    echo "  1. Your phone and MacBook are on the same WiFi network"
    echo "  2. Wireless debugging is enabled on your phone"
    echo "  3. The IP address and port are correct"
fi
