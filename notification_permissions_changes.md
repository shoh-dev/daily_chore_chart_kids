# Notification Permissions Optimization

## Changes Made

### 1. Removed Unnecessary Permissions
Removed the following permissions from `android/app/src/main/AndroidManifest.xml`:
- `USE_EXACT_ALARM`
- `SCHEDULE_EXACT_ALARM`

The app now only uses:
- `POST_NOTIFICATIONS` (required for sending notifications)

### 2. Updated Notification Scheduling Mode
In `lib/core/services/notification_service.dart`, changed the notification scheduling mode from:
```dart
androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
```
to:
```dart
androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle
```

## Why These Changes?

1. **Battery Optimization**: The app doesn't need exact timing for daily reminders, so using inexact scheduling allows Android to optimize battery usage.

2. **Minimal Permissions**: Following the principle of least privilege, we only request permissions that are absolutely necessary for the app's functionality.

3. **Reliability**: Daily reminders will still work reliably, just with slightly flexible timing (system may adjust by a few minutes to optimize battery).

## How to Apply These Changes

1. In your AndroidManifest.xml, ensure you only have:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

2. In your notification service, use inexact scheduling:
```dart
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

- Reduced permission requirements
- Better battery optimization
- Still maintains reliable daily reminder functionality
- Follows Android best practices for notification scheduling 