import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siyasat_ph/screens/landing_screen.dart';
import './utils/locale_provider.dart';
import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';
import 'services/fcm_service.dart';
import 'services/notification_listener_service.dart';
import 'services/family_setup_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase / FCM and notification handling
  await FcmService.initialize();

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