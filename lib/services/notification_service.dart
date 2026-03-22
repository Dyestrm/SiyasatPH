import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings: settings);
    
    // Request POST_NOTIFICATIONS permission at runtime (Android 13+)
    await _requestNotificationPermission();
    
    _initialized = true;
  }

  static Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      print('[NotificationService] Notification permission denied');
    } else if (status.isPermanentlyDenied) {
      print('[NotificationService] Notification permission permanently denied - opening settings');
      openAppSettings();
    } else {
      print('[NotificationService] Notification permission granted');
    }
  }

  static Future<void> showScamAlert({
    required String packageName,
    required String originalText,
    required String verdictLevel,
    required String explanation,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'scam_alerts',           // channel id
      'Scam Alerts',           // channel name
      channelDescription: 'SiyasatPH scam detection alerts',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Scam detected',
      styleInformation: BigTextStyleInformation(explanation),
    );

    final appName = _friendlyAppName(packageName);
    final notificationId = packageName.hashCode.abs();

    await _plugin.show(
      id: notificationId,
      title: '⚠️ Scam detected in $appName',
      body: verdictLevel,
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: originalText,
    );
  }

  // Convert package name to readable app name
  static String _friendlyAppName(String packageName) {
    const names = {
      'com.gcash':          'GCash',
      'com.bdo.retail':     'BDO',
      'com.google.android.apps.messaging': 'Messages',
      'com.facebook.orca':  'Messenger',
      'com.viber.voip':     'Viber',
    };
    return names[packageName] ?? packageName.split('.').last;
  }
}