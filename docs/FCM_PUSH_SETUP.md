# Push notifications (FCM) - setup

Backend is ready (`app/Services/FcmService.php`). It sends a push whenever a
visitor / parcel / gate-pass / SOS notification row is created, **only if**
`FCM_PROJECT_ID` and `FCM_CREDENTIALS` are set in the backend `.env`.

The app side needs your own Firebase project files, so it is NOT switched on
in this zip (adding Firebase without `google-services.json` would break the
Android build). Steps when you are ready:

## 1. Backend `.env`
```
FCM_PROJECT_ID=your-firebase-project-id
FCM_CREDENTIALS=/absolute/path/to/service-account.json
```
Then `php artisan config:clear`. (Service account: Firebase console ->
Project settings -> Service accounts -> Generate new private key. Keep the
file outside `public/`.)

## 2. Flutter
```
flutter pub add firebase_core firebase_messaging
```
Put `google-services.json` in `android/app/` and add the Google services
Gradle plugin as shown by `flutterfire configure` (or the Firebase docs).

## 3. Code to add (`lib/Core/Push/PushService.dart`)
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:property_association_or_resident/Core/Utils/preety.dio.dart';

class PushService {
  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      FirebaseMessaging.onMessage.listen((m) {}); // foreground: in-app list already updates
      fm.onTokenRefresh.listen(_sendToken);
      final token = await fm.getToken();
      if (token != null) await _sendToken(token);
    } catch (_) {
      // Firebase not configured -> app keeps working without push
    }
  }

  // Call again right after a successful login (token needs the Bearer header).
  static Future<void> _sendToken(String token) async {
    try {
      await createDio().post(
        'https://realestate.gwsstaging.com/api/v1/auth/fcm-token',
        data: {'fcm_token': token},
      );
    } catch (_) {}
  }
}
```
Call `PushService.init()` in `main()` after `Hive.openBox(...)` and again after
every successful login (guard / resident / association).
Android 8+ channel id used by the backend: `high_importance_channel`.
