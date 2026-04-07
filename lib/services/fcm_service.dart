import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications_plus/flutter_local_notifications_plus.dart';

import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.showNotificationForMessage(message);
  debugPrint('Background message received: ${message.notification?.title}');
}

class FcmService {
  FcmService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _highImportanceChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  static bool _initialized = false;

  static Future<void> initialize({bool requestPermission = true}) async {
    if (_initialized) return;

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initializeNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    if (requestPermission) {
      await requestPermissionIfNeeded();
    }

    _initialized = true;
  }

  static Future<void> requestPermissionIfNeeded() async {
    final settings = await _messaging.requestPermission();
    debugPrint('FCM permission status: ${settings.authorizationStatus}');
  }

  static Future<void> _initializeNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotificationsPlugin.initialize(initializationSettings);
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_highImportanceChannel);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.notification?.title}');
    await showNotificationForMessage(message);
  }

  static Future<void> showNotificationForMessage(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null || android == null) {
      return;
    }

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _highImportanceChannel.id,
          _highImportanceChannel.name,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static AndroidNotificationChannel get highImportanceChannel =>
      _highImportanceChannel;

  static FlutterLocalNotificationsPlugin get localNotificationsPlugin =>
      _localNotificationsPlugin;
}
