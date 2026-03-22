import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './screens/landing_screen.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_listener_service.dart';
import 'services/family_setup_service.dart';
import 'services/notification_service.dart';
import 'services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local notifications service
  await NotificationService.initialize();

  // Only run notification listener on Android
  if (!kIsWeb) {
    await NotificationsListener.initialize();

    final hasPermission = await NotificationsListener.hasPermission;
    if (hasPermission == false) {
      await NotificationsListener.openPermissionSettings();
    }

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

    final isRunning = await NotificationsListener.isRunning;
    if (isRunning == false) {
      await NotificationsListener.startService();
    }
  }

  // Guardian listener works on both web and Android
  await NotificationListenerService().startGuardianListener();

  // Initialize Firebase Messaging Service
  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiyasatPH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LandingScreen(),
    );
  }
}