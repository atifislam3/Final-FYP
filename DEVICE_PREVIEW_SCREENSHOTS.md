# Device Preview Screenshot Guide

Instead of automated integration tests, use **Device Preview** to manually capture screenshots of your app across different device frames.

## Setup

Device preview is already added to `pubspec.yaml`. Just run:

```bash
flutter pub get
```

## Running Device Preview

Start the app in device preview mode:

```bash
flutter run -t lib/main_device_preview.dart
```

## Capturing Screenshots

### Option 1: Built-in Device Preview Screenshot Tool
1. Tap the **camera icon** in the Device Preview toolbar (on the left side or top)
2. Screenshots are saved to:
   - **Android/iOS**: Device's default screenshot location
   - **Web**: Your Downloads folder

### Option 2: Manual Device Screenshot
1. Navigate to the screen you want to capture
2. Press the device's hardware screenshot button (if available)
3. Or use device preview's built-in tools

### Option 3: System Screenshot + Crop
1. Run the app in device preview
2. Take a full screenshot of your screen
3. Crop to the device frame manually in an image editor

## Changing Device Frames

Once the app is running:
1. Look at the Device Preview control panel (left sidebar or floating menu)
2. Select a different device from the dropdown (iPhone 14, Pixel 5, iPad, etc.)
3. The app will reframe to match that device's dimensions

## Organizing Screenshots

Store all screenshots in a folder:

```
screenshots/
  ├── fyp_report/
  │   ├── 01_splash.png
  │   ├── 02_login.png
  │   ├── 03_signup.png
  │   └── ... (all your screens)
```

## Tips

- **Multiple Devices**: Run multiple instances with different device targets to capture on various screen sizes
- **Dark/Light Mode**: Toggle theme in your app settings to capture both modes
- **Empty States**: Clear data in-app or via Hive inspector to capture empty screens
- **Consistent Frame**: Use the same device frame for all screenshots to maintain visual consistency in your FYP report

## No Integration Test Hassles

This approach avoids:
- Permission dialog popups
- Navigation context errors
- Async/timing issues
- Complex test harness setup

Just run, tap, screenshot, repeat!
