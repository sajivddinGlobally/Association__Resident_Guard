import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationNotification/Notificaion.dart'
    as association_notif;
import 'package:property_association_or_resident/Core/Utils/key.dart';
import 'package:property_association_or_resident/GuardScreen/GuardNotificationScreen/GuardNotificationScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentNotification_Screen.dart';

/// App background / band ho tab aaya push.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: PushNotificationService.platformOptions,
    );
    try {
      await FlutterRingtonePlayer().play(
        fromAsset: "assets/sounds/chime.wav",
        volume: 1.0,
        asAlarm: false,
      );
    } catch (_) {}
  } catch (_) {}
}

/// Push notification (Firebase) - popup, tap par Notification screen, token backend ko.
/// Kuch bhi fail ho to app normal chalti rahe - kabhi exception bahar nahi aata.
class PushNotificationService {
  PushNotificationService._();

  static const String _boxName = "associationdata";

  /// Wahi server jo app ki baaki API use karti hai (ApiStateNetwork baseUrl).
  static const String _api = "https://admin.ascentpms.care/api/v1";

  /// Channel jisme importance max hai
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'stayo_notifications',
    'Important Notifications',
    description: 'Stayo alerts and updates',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static bool _started = false;
  static bool _firebaseReady = false;
  static String? _lastSentKey;
  static bool _opening = false;

  /// iOS ke liye Firebase settings (GoogleService-Info.plist - stayo-4c7c4).
  /// Android google-services.json se apne aap leta hai.
  static FirebaseOptions? get platformOptions {
    if (kIsWeb) return null;
    if (Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyCdeZU7ZJjL_0xJVBVVi64DaY27zDn3GDM',
        appId: '1:1020638733342:ios:9115b160e53a30fb53ba0f',
        messagingSenderId: '1020638733342',
        projectId: 'stayo-4c7c4',
        storageBucket: 'stayo-4c7c4.firebasestorage.app',
        iosBundleId: 'com.example.propertyAssociationOrResident',
      );
    }
    return null;
  }

  /// main() mein Hive box khulne ke baad, runApp se pehle call karein.
  static Future<void> init() async {
    if (_started || kIsWeb) return;
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    _started = true;

    try {
      await Firebase.initializeApp(options: platformOptions);
      _firebaseReady = true;
    } catch (e) {
      log("Push: Firebase init failed - $e");
      return;
    }

    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _initLocalNotifications();

      final messaging = FirebaseMessaging.instance;

      // iOS: app khuli ho tab bhi upar popup dikhe
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen(_showForegroundPopup);
      FirebaseMessaging.onMessageOpenedApp.listen((_) => _openNotifications());
      messaging.onTokenRefresh.listen((t) {
        _lastSentKey = null;
        _sendTokenToServer(t);
      });

      _watchLogin();

      // App band thi aur push par tap karke khuli
      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        _openNotificationsAfterStart();
      } else {
        final launch = await _local.getNotificationAppLaunchDetails();
        if (launch?.didNotificationLaunchApp == true) {
          _openNotificationsAfterStart();
        }
      }

      // Permission popup pehli screen dikhne ke baad
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_requestPermissionAndSync());
      });
    } catch (e) {
      log("Push: setup error - $e");
    }
  }

  static Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (_) => _openNotifications(),
    );
    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      // Purana broken channel delete karo jo missing raw file dhoondh raha tha
      try {
        await androidPlugin.deleteNotificationChannel(
          'high_importance_channel',
        );
      } catch (_) {}
      // Naya clean channel create karo jisme system default sound hai
      await androidPlugin.createNotificationChannel(_channel);
    }
  }

  static Future<void> _requestPermissionAndSync() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      log("Push: permission error - $e");
    }
    await syncToken();
  }

  /// Login hote hi (Hive mein token save hote hi) FCM token backend ko bhejo.
  static void _watchLogin() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return;
      Hive.box(_boxName).watch(key: "token").listen((event) {
        _lastSentKey = null;
        if (!event.deleted && event.value != null) {
          unawaited(syncToken());
        }
      });
    } catch (e) {
      log("Push: login watch error - $e");
    }
  }

  /// FCM token lekar backend (/auth/fcm-token) ko bhejo - sirf login hone par.
  static Future<void> syncToken() async {
    if (!_firebaseReady) return;
    try {
      final messaging = FirebaseMessaging.instance;
      if (Platform.isIOS) {
        // iOS par pehle Apple (APNs) token aana zaroori hai
        String? apns = await messaging.getAPNSToken();
        for (int i = 0; i < 5 && apns == null; i++) {
          await Future.delayed(const Duration(seconds: 2));
          apns = await messaging.getAPNSToken();
        }
        if (apns == null) {
          log(
            "Push: APNs token nahi mila (APNs key / Push capability check karein)",
          );
          return;
        }
      }
      final fcm = await messaging.getToken();
      await _sendTokenToServer(fcm);
    } catch (e) {
      log("Push: token error - $e");
    }
  }

  static Future<void> _sendTokenToServer(String? fcm) async {
    if (fcm == null || fcm.trim().isEmpty) return;
    try {
      final box = Hive.isBoxOpen(_boxName)
          ? Hive.box(_boxName)
          : await Hive.openBox(_boxName);
      final auth = box.get("token");
      if (auth == null || auth.toString().trim().isEmpty) return;

      final key = "$auth|$fcm";
      if (_lastSentKey == key) return;

      // Alag Dio - taaki yahan error aane par login screen par redirect na ho
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );
      await dio.post(
        "$_api/auth/fcm-token",
        data: {"fcm_token": fcm},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $auth",
          },
        ),
      );
      _lastSentKey = key;
      log("Push: FCM token server par save ho gaya");
      log("FCM Token : - $fcm");
    } catch (e) {
      log("Push: token send failed - $e");
    }
  }

  /// App khuli ho tab Android popup aur sound ke liye.
  static Future<void> _showForegroundPopup(RemoteMessage message) async {
    try {
      final n = message.notification;
      final title = n?.title ?? message.data['title']?.toString();
      final body =
          n?.body ??
          message.data['body']?.toString() ??
          message.data['message']?.toString();
      if (title == null && body == null) return;

      // 1. Play audio chime from assets (Track_Loved style)
      try {
        FlutterRingtonePlayer().play(
          fromAsset: "assets/sounds/chime.wav",
          volume: 1.0,
          asAlarm: false,
        );
      } catch (e) {
        log("Push: ringtone error - $e");
      }

      // 2. Show notification popup (without raw resource so it never crashes with invalid_sound)
      final id =
          int.tryParse(message.data['notification_id']?.toString() ?? '') ??
          (DateTime.now().millisecondsSinceEpoch ~/ 1000);
      await _local.show(
        id & 0x7fffffff,
        title ?? 'Stayo Notification',
        body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(body ?? ''),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      log("Push: popup error - $e");
    }
  }

  static void _openNotificationsAfterStart() {
    Future.delayed(const Duration(milliseconds: 1200), _openNotifications);
  }

  /// Notification par tap -> role ke hisaab se Notification screen (sirf login ho tab).
  /// Role check wahi hai jo main.dart mein home screen chunne ke liye hai.
  static Future<void> _openNotifications() async {
    if (_opening) return;
    _opening = true;
    try {
      final box = Hive.isBoxOpen(_boxName)
          ? Hive.box(_boxName)
          : await Hive.openBox(_boxName);
      final auth = box.get("token");
      if (auth == null || auth.toString().trim().isEmpty) return;

      for (int i = 0; i < 10 && navigatorKey.currentState == null; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      final nav = navigatorKey.currentState;
      if (nav == null) return;
      final role = (box.get("role") ?? "").toString().toLowerCase();
      final Widget screen;
      if (role.contains("resident")) {
        screen = const ResidentnotificationScreen();
      } else if (role.contains("security")) {
        screen = const GuardNotificationScreen();
      } else {
        screen = const association_notif.Notification();
      }
      await nav.push(MaterialPageRoute(builder: (context) => screen));
    } catch (e) {
      log("Push: open screen error - $e");
    } finally {
      _opening = false;
    }
  }
}
