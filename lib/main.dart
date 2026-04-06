import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siyasat_ph/screens/landing_screen.dart';
import './utils/locale_provider.dart';
import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';
import 'package:flutter_local_notifications_plus/flutter_local_notifications_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/notification_listener_service.dart';
import 'services/family_setup_service.dart';
import 'services/notification_service.dart';

// Must be a top-level function, outside of any class
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request FCM permission (required for Android 13+)
  await FirebaseMessaging.instance.requestPermission();

  // Get FCM token for testing
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
  } catch (e) {
    debugPrint('Error getting FCM token: $e');
  }

  // Subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic("sample");

  // Setup high importance notification channel for FCM
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Foreground message listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('✅ Message received in foreground!');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // Initialize local notifications service
  await NotificationService.initialize();

  // Initialize the notification listener plugin
  await NotificationsListener.initialize();

  // Check permission — sends user to Settings if not granted
  final hasPermission = await NotificationsListener.hasPermission;
  if (hasPermission == false) {
    await NotificationsListener.openPermissionSettings();
  }

  // Load family setup and start listening with configured rules
  final familySetupService = FamilySetupService();
  final setup = await familySetupService.getSetup();

  if (setup != null && setup.isActive) {
    await NotificationListenerService().startListening(
      selectedBanks: setup.selectedBanks,
      language: setup.language,
    );
  } else {
    await NotificationListenerService().startListening(
      selectedBanks: [],
      language: 'fil',
    );
  }

  // Start the native listener service
  final isRunning = await NotificationsListener.isRunning;
  if (isRunning == false) {
    await NotificationsListener.startService();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MaterialApp(
        title: 'SiyasatPH',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}