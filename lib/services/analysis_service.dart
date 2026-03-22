import '../engine/rules_engine.dart';
import '../models/verdict.dart';
import '../models/scam_alert.dart';
import '../repository/history_repository.dart';
import '../models/family_setup_model.dart';
import 'firebase_messaging_service.dart';
import 'notification_service.dart';
import '../utils/device_utils.dart';

class AnalysisService {
  static final AnalysisService _instance = AnalysisService._internal();
  factory AnalysisService() => _instance;
  AnalysisService._internal();

  final _messagingService = FirebaseMessagingService();

  Future<Verdict> analyzeMessage(
    String message,
    String senderNumber, {
    FamilySetupModel? setup,
  }) async {
    final engine = RulesEngine();

    if (setup != null) {
      engine.selectedBanks = setup.selectedBanks;
      engine.language = setup.language;
    } else {
      engine.selectedBanks = ['BDO', 'GCash', 'Maya'];
      engine.language = 'fil';
    }

    final verdict = await engine.analyze(message.trim(), senderNumber);
    await HistoryRepository().saveAnalysis(message, verdict);

    if (_isScamDetected(verdict)) {
      if (setup != null) {
        await _notifyGuardianOfScam(message, verdict, setup);
      } else {
        // No setup but still save to Firestore so we can see it
        final deviceId = await getOrCreateDeviceId();
        final alert = ScamAlert(
          elderDeviceId: deviceId,
          alertType: 'scam',
          riskLevel: verdict.level.name,
          detectedMessage: message,
          senderNumber: senderNumber,
          explanation: verdict.explanation,
          reasons: verdict.reasons,
          status: AlertStatus.pending,
          detectedAt: verdict.timestamp,
        );
        await _messagingService.saveAlertToFirestore(alert);
        print('[AnalysisService] Alert saved to Firestore without guardian');
      }
    }

    return verdict;
  }

  // ── DETECT SCAM ─────────────────────────────────────────────

  bool _isScamDetected(Verdict verdict) {
    return verdict.level == RiskLevel.likelyScam ||
        verdict.level == RiskLevel.suspicious ||
        verdict.level == RiskLevel.spam;
  }

  // ── NOTIFY GUARDIAN ─────────────────────────────────────────

  Future<void> _notifyGuardianOfScam(
    String message,
    Verdict verdict,
    FamilySetupModel setup,
  ) async {
    try {
      final elderDeviceId = setup.deviceId;
      final guardianDeviceId = setup.guardianDeviceId;

      if (guardianDeviceId == null || guardianDeviceId.isEmpty) {
        print('[AnalysisService] Guardian device not linked - alert stored locally only');
      }

      final alert = ScamAlert(
        elderDeviceId: elderDeviceId,
        guardianDeviceId: guardianDeviceId,
        alertType: 'scam',
        riskLevel: verdict.level.name,
        detectedMessage: message,
        senderNumber: verdict.senderNumber,
        explanation: verdict.explanation,
        reasons: verdict.reasons,
        elderName: setup.configName,
        guardianName: setup.notifyName,
        status: AlertStatus.pending,
        detectedAt: verdict.timestamp,
      );

      // Show local notification on elder's phone
      await NotificationService.showScamAlert(
        packageName: 'com.siyasat.ph',
        originalText: message,
        verdictLevel: verdict.level.name.toUpperCase(),
        explanation: verdict.explanation,
      );

      // Send alert to guardian's phone (if linked)
      if (guardianDeviceId != null && guardianDeviceId.isNotEmpty) {
        print('[AnalysisService] Sending alert to guardian ${setup.notifyName} (device: ${guardianDeviceId.substring(0, 8)}...)');
        await _messagingService.sendScamAlertToGuardian(
          alert: alert,
          guardianDeviceId: guardianDeviceId,
        );
      } else {
        print('[AnalysisService] No guardian device linked - only stored in Firestore');
        await _messagingService.saveAlertToFirestore(alert);
      }
    } catch (e) {
      print('[AnalysisService] Error notifying guardian: $e');
    }
  }
}