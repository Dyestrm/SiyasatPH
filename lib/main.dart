import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siyasat_ph/screens/landing_screen.dart';
import './utils/locale_provider.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_listener_service.dart';
import 'services/family_setup_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    // Start listening with user's configuration
    await NotificationListenerService().startListening(
      selectedBanks: setup.selectedBanks,
      language: setup.language,
    );
  } else {
    // Start with default configuration
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