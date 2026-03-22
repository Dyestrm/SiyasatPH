import 'dart:async';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'analysis_service.dart';
import 'family_setup_service.dart';
import 'notification_service.dart';
import '../repository/scam_alert_repository.dart';
import '../models/scam_alert.dart';

@pragma('vm:entry-point')
void _notificationCallback(NotificationEvent event) {
  NotificationListenerService()._processNotification(event);
}

class NotificationListenerService {
  static final NotificationListenerService _instance =
      NotificationListenerService._internal();
  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  final _analysisService = AnalysisService();
  final _familySetupService = FamilySetupService();
  StreamSubscription? _guardianSubscription;

  // ── ELDER: start listening to incoming notifications ──────

  Future<void> startListening({
    required List<String> selectedBanks,
    required String language,
  }) async {
    await NotificationsListener.registerEventHandle(_notificationCallback);
    print('[SiyasatPH] Notification listener registered successfully');
  }

  Future<void> _processNotification(NotificationEvent event) async {
    final packageName = event.packageName ?? '';

    // Ignore own app to prevent infinite loop
    if (packageName == 'com.example.siyasat_ph') return;

    // Ignore system noise
    const ignoredPackages = {
      'android',
      'com.android.systemui',
      'com.android.settings',
      'com.google.android.gms',
      'com.google.android.gsf',
    };
    if (ignoredPackages.contains(packageName)) return;

    final title = event.title ?? '';
    final messageText = event.text ?? '';

    print('[SiyasatPH] ========== NEW NOTIFICATION ==========');
    print('[SiyasatPH] Package: $packageName');
    print('[SiyasatPH] Title: $title');
    print('[SiyasatPH] Message: $messageText');

    final fullMessage = (title.isNotEmpty && messageText.isNotEmpty)
        ? '$title $messageText'
        : messageText.isNotEmpty
            ? messageText
            : (event.message ?? '');

    if (fullMessage.trim().isEmpty) {
      print('[SiyasatPH] Message is empty, skipping');
      return;
    }

    final senderInfo = _extractSenderInfo(packageName, event);

    try {
      final setup = await _familySetupService.getSetup();
      final verdict = await _analysisService.analyzeMessage(
        fullMessage,
        senderInfo,
        setup: setup,
      );

      print('[SiyasatPH] Verdict: ${verdict.level}');
      print('[SiyasatPH] Reasons: ${verdict.reasons}');
    } catch (e, stackTrace) {
      print('[SiyasatPH] ERROR processing notification: $e');
      print('[SiyasatPH] Stack trace: $stackTrace');
    }
  }

  String _extractSenderInfo(String packageName, NotificationEvent event) {
    switch (packageName) {
      case 'com.google.android.apps.messaging':
      case 'com.android.mms':
      case 'com.facebook.orca':
      case 'com.viber.voip':
        return event.title ?? 'Unknown Sender';
      case 'com.gcash':
      case 'com.bdo.retail':
      case 'com.unionbank.online':
      case 'com.metrobank.online':
        return packageName.split('.').last.toUpperCase();
      default:
        return packageName;
    }
  }

  // ── GUARDIAN: listen to Firestore and fire local notification

  Future<void> startGuardianListener() async {
    final repo = ScamAlertRepository();

    _guardianSubscription = repo.streamAlertsForGuardian().listen((alerts) {
      final newAlerts = alerts
          .where((a) => a.status == AlertStatus.pending)
          .toList();

      for (final alert in newAlerts) {
        NotificationService.showScamAlert(
          packageName: 'com.example.siyasat_ph',
          originalText: alert.detectedMessage,
          verdictLevel: alert.riskLevel.toUpperCase(),
          explanation:
              '${alert.elderName ?? "Your elder"} received a scam message!',
        );
      }
    });
  }

  void stopGuardianListener() {
    _guardianSubscription?.cancel();
    _guardianSubscription = null;
  }
}