# App Icon Setup

To create the app icon:

1. Create a 1024x1024 PNG image with your app icon design
2. Save it as `app_icon.png` in this directory
3. For adaptive icon, create `app_icon_foreground.png` (1024x1024, transparent background)

Or use an online tool:
- https://appicon.co/
- https://www.appicon.build/
- https://icon.kitchen/

After creating the icon files, run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Quick Icon Design Ideas:
- Book/flashcard with letter "B"
- Blue background (#2196F3) with white card
- Simple, clean design matching the app's minimal aesthetic

