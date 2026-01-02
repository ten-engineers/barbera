# Setup Instructions for Testing on OnePlus 7T

## Prerequisites
1. Flutter SDK installed and in your PATH
2. Android device (OnePlus 7T) connected via USB or WiFi debugging enabled
3. Developer options enabled on your device

## Steps to Run on Device

### 1. Enable Developer Options on OnePlus 7T
- Go to Settings → About Phone
- Tap "Build Number" 7 times
- Go back to Settings → System → Developer Options
- Enable "USB Debugging"
- Enable "Wireless Debugging" (for WiFi connection)

### 2. Connect Device

**Option A: USB Connection**
```bash
# Connect via USB cable
adb devices
```

**Option B: WiFi Connection (Same Network)**
```bash
# First connect via USB once to pair
adb devices

# Enable wireless debugging on device, then:
# On device: Settings → Developer Options → Wireless Debugging → Pair device with pairing code
# Get IP address and port from Wireless Debugging settings
adb connect <DEVICE_IP>:<PORT>
adb devices
```

### 3. Install Dependencies
```bash
cd /Users/pavelbohovin/www/barbera
flutter pub get
```

### 4. Generate Hive Adapters (REQUIRED)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Check Connected Devices
```bash
flutter devices
```

### 6. Run on Device
```bash
flutter run -d <device-id>
# Or simply:
flutter run
```

## Troubleshooting

### If device not detected:
- Check USB debugging is enabled
- Try `adb kill-server && adb start-server`
- For WiFi: Ensure device and computer are on same network
- Check firewall settings

### If build fails:
- Make sure Hive adapters are generated (`*.g.dart` files exist)
- Run `flutter clean && flutter pub get`
- Check Flutter version: `flutter --version` (should be >=3.0.0)

