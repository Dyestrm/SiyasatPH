import 'package:flutter/material.dart';
import 'package:siyasat_ph/screens/choice_setup_screen.dart';
import './theme/colors.dart';
import './screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/family_setup_service.dart';
import 'services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// temporarily commented out — causes black screen in debug mode
// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
// import 'services/notification_listener_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize local notifications service
  await NotificationService.initialize();

  // one-time clear of stale cached setup data (old config_name key)
  // remove these two lines after first successful run
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('family_setup');

  // ── NOTIFICATION LISTENER — commented out temporarily ──
  // await NotificationsListener.initialize();

  // final hasPermission = await NotificationsListener.hasPermission;
  // if (hasPermission == false) {
  //   await NotificationsListener.openPermissionSettings();
  // }

  // final familySetupService = FamilySetupService();
  // final setup = await familySetupService.getSetup();

  // if (setup != null && setup.isActive) {
  //   await NotificationListenerService().startListening(
  //     selectedBanks: setup.selectedBanks,
  //     language: setup.language,
  //   );
  // } else {
  //   await NotificationListenerService().startListening(
  //     selectedBanks: [],
  //     language: 'Filipino',
  //   );
  // }

  // final isRunning = await NotificationsListener.isRunning;
  // if (isRunning == false) {
  //   await NotificationsListener.startService();
  // }
  // ────────────────────────────────────────────────────────

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiyasatPH',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: SetupChoiceScreen(),
    );
  }
}
