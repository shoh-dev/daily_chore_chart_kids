# Changes Need to Be Made

## 1. Application Name and ID Changes

### Android App Name Change
In `android/app/src/main/AndroidManifest.xml`, changed:
```xml
android:label="daily_chore_chart_kids"
```
to:
```xml
android:label="Daily Chore Chart – For Kids"
```

### iOS App Name Change
In `ios/Runner/Info.plist`, changed:
```xml
<key>CFBundleDisplayName</key>
<string>Daily Chore Chart Kids</string>
```

### Android Application ID Change
In `android/app/build.gradle.kts`, changed:
```kotlin
applicationId = "dev.shoh.chorechart"
```

## 2. Notification Permissions Optimization

### Removed Unnecessary Permissions
In `android/app/src/main/AndroidManifest.xml`, removed:
- `USE_EXACT_ALARM`
- `SCHEDULE_EXACT_ALARM`

The app now only uses:
- `POST_NOTIFICATIONS` (required for sending notifications)

### Updated Notification Scheduling Mode
In `lib/core/services/notification_service.dart`, changed:
```dart
androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
```
to:
```dart
androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle
```

## Why These Changes?

1. **App Identity**: 
   - More user-friendly app name that clearly describes the app's purpose
   - Professional application ID following reverse domain notation

2. **Battery Optimization**: 
   - The app doesn't need exact timing for daily reminders
   - Using inexact scheduling allows Android to optimize battery usage

3. **Minimal Permissions**: 
   - Following the principle of least privilege
   - Only requesting permissions that are absolutely necessary

4. **Reliability**: 
   - Daily reminders will still work reliably
   - Slightly flexible timing (system may adjust by a few minutes to optimize battery)

## How to Apply These Changes

1. Update Android App Name:
```xml
<!-- In android/app/src/main/AndroidManifest.xml -->
<application
    android:label="Daily Chore Chart – For Kids"
    ...
>
```

2. Update iOS App Name:
```xml
<!-- In ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Daily Chore Chart Kids</string>
```

3. Update Android Application ID:
```kotlin
// In android/app/build.gradle.kts
defaultConfig {
    applicationId = "dev.shoh.chorechart"
    ...
}
```

4. Update Notification Permissions:
```xml
<!-- In android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

5. Update Notification Scheduling:
```dart
// In lib/core/services/notification_service.dart
await _notifications.zonedSchedule(
  notificationId,
  title,
  body,
  scheduledTime,
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time,
);
```

## Benefits

- Professional app identity with clear naming
- Reduced permission requirements
- Better battery optimization
- Maintains reliable daily reminder functionality
- Follows Android best practices for notification scheduling 