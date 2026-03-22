import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import '../engine/rules_engine.dart';
import '../models/verdict.dart';
import 'notification_service.dart';

// Top-level callback function for notification listener
// This MUST be a top-level function - instance methods won't work with flutter_notification_listener
// The @pragma annotation marks this as an entry point for native code to call
@pragma('vm:entry-point')
void _notificationCallback(NotificationEvent event) {
  NotificationListenerService()._processNotificationAsync(event);
}

class NotificationListenerService {
  static final NotificationListenerService _instance =
      NotificationListenerService._internal();

  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  final RulesEngine _rulesEngine = RulesEngine();

  /// Start listening to incoming notifications with specified configuration
  Future<void> startListening({
    required List<String> selectedBanks,
    required String language,
  }) async {
    // Configure the rules engine with user settings
    _rulesEngine.selectedBanks = selectedBanks;
    _rulesEngine.language = language;

    // Register the notification event handler callback
    // Must be a top-level function for flutter_notification_listener
    await NotificationsListener.registerEventHandle(_notificationCallback);
    print('[SiyasatPH] Notification listener registered successfully');
  }

  /// Process notification asynchronously (called from top-level callback)
  Future<void> _processNotificationAsync(NotificationEvent event) async {
    _processNotification(event);
  }

  /// Process a notification through the scam detection pipeline
  Future<void> _processNotification(NotificationEvent event) async {
    // Extract message content from notification
    final packageName = event.packageName ?? '';
    final title = event.title ?? '';
    final messageText = event.text ?? '';

    print('[SiyasatPH] ========== NEW NOTIFICATION ==========');
    print('[SiyasatPH] Package: $packageName');
    print('[SiyasatPH] Title: $title');
    print('[SiyasatPH] Message: $messageText');

    // Combine title and body for analysis (use message as fallback)
    final fullMessage = (title.isNotEmpty && messageText.isNotEmpty)
        ? '$title $messageText'
        : messageText.isNotEmpty
            ? messageText
            : (event.message ?? '');

    print('[SiyasatPH] Full message for analysis: $fullMessage');

    if (fullMessage.trim().isEmpty) {
      print('[SiyasatPH] Message is empty, skipping');
      return;
    }

    // Extract sender information
    final senderInfo = _extractSenderInfo(packageName, event);
    print('[SiyasatPH] Sender info: $senderInfo');

    try {
      // Analyze the message using the rules engine
      print('[SiyasatPH] Starting analysis...');
      final verdict = await _rulesEngine.analyze(fullMessage, senderInfo);

      print('[SiyasatPH] Analysis complete!');
      print('[SiyasatPH] Verdict level: ${verdict.level}');
      print('[SiyasatPH] Risk reasons: ${verdict.reasons}');
      print('[SiyasatPH] Explanation: ${verdict.explanation}');

      // If it's flagged as suspicious or scam, show an alert
      if (verdict.level != RiskLevel.safe) {
        print('[SiyasatPH] ALERT TRIGGERED - Showing notification');
        await NotificationService.showScamAlert(
          packageName: packageName,
          originalText: fullMessage,
          verdictLevel: _getVerdictLabel(verdict.level),
          explanation: verdict.explanation,
        );

        // Log the detection for debugging
        print('[SiyasatPH] Scam detected from $packageName: ${verdict.level}');
        print('[SiyasatPH] Risk score: ${verdict.reasons}');
      } else {
        print('[SiyasatPH] Message is SAFE - no alert');
      }
    } catch (e, stackTrace) {
      print('[SiyasatPH] ERROR processing notification: $e');
      print('[SiyasatPH] Stack trace: $stackTrace');
    }
  }

  /// Extract sender information from notification metadata
  String _extractSenderInfo(String packageName, NotificationEvent event) {
    // For SMS/messaging apps, try to extract the sender (usually in title)
    switch (packageName) {
      case 'com.google.android.apps.messaging':
      case 'com.android.mms':
      case 'com.facebook.orca':
      case 'com.viber.voip':
        // Use title as sender for messaging apps
        return event.title ?? 'Unknown Sender';

      case 'com.gcash':
      case 'com.bdo.retail':
      case 'com.unionbank.online':
      case 'com.metrobank.online':
        // Banking apps - use package name as identifier
        return packageName.split('.').last.toUpperCase();

      default:
        // For other apps, use the package name
        return packageName;
    }
  }

  /// Convert RiskLevel enum to readable verdict label
  String _getVerdictLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return '✅ Safe';
      case RiskLevel.spam:
        return '⚠️ Spam';
      case RiskLevel.suspicious:
        return '⚠️ Suspicious';
      case RiskLevel.likelyScam:
        return '⚠️ Likely Scam';
    }
  }
}
