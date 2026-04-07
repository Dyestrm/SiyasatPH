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
  static String? _cachedToken;
  static bool _tokenListenerAttached = false;

  static Future<void> initialize({bool requestPermission = true}) async {
    if (_initialized) return;

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initializeNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    _attachTokenRefreshListener();

    if (requestPermission) {
      await requestPermissionIfNeeded();
    }

    _initialized = true;
    await _cacheToken();
  }

  static Future<String?> getToken({bool forceRefresh = false}) async {
    if (!_initialized) {
      await initialize(requestPermission: false);
    }

    if (_cachedToken == null || forceRefresh) {
      await _cacheToken(forceRefresh: forceRefresh);
    }

    return _cachedToken;
  }

  static String? get token => _cachedToken;

  static Future<void> _cacheToken({bool forceRefresh = false}) async {
    if (_cachedToken != null && !forceRefresh) {
      return;
    }

    _cachedToken = await _messaging.getToken();
    debugPrint('FCM token cached: $_cachedToken');
  }

  static void _attachTokenRefreshListener() {
    if (_tokenListenerAttached) return;
    _tokenListenerAttached = true;

    _messaging.onTokenRefresh.listen((newToken) {
      _cachedToken = newToken;
      debugPrint('FCM token refreshed: $newToken');
    });
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
