import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';
import 'package:siyasat_ph/services/fcm_sender.dart';
import 'package:siyasat_ph/services/fcm_service.dart';
import '../engine/rules_engine.dart';
import '../models/verdict.dart';
import 'notification_service.dart';
import 'dart:async';

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
  int _requestCounter = 0;
  final Set<String> _processedNotifications = {};

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
    _requestCounter++;
    final requestId = 'REQ#${_requestCounter}';

    // Extract message content from notification
    final packageName = event.packageName ?? '';
    final title = event.title ?? '';
    final messageText = event.text ?? '';

    // Skip FCM notifications sent by our own app to prevent loops
    if (packageName == 'com.example.siyasat_ph' && title.contains('Scam alert')) {
      print('[$requestId] ⏭️ Skipping own FCM notification to prevent processing loop');
      return;
    }

    print('[$requestId] ========== NEW NOTIFICATION RECEIVED ==========');
    print('[$requestId] Package: $packageName');
    print('[$requestId] Title: $title');
    print('[$requestId] Message: $messageText');

    // Combine title and body for analysis (use message as fallback)
    final fullMessage = (title.isNotEmpty && messageText.isNotEmpty)
        ? '$title $messageText'
        : messageText.isNotEmpty
            ? messageText
            : (event.message ?? '');

    print('[$requestId] Full message for analysis: $fullMessage');

    if (fullMessage.trim().isEmpty) {
      print('[$requestId] Message is empty, skipping');
      return;
    }

    // Create a unique key for this notification to prevent duplicates
    final notificationKey = '${packageName}_${title}_${messageText}';
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print('[$requestId] Notification key: $notificationKey');

    // Check if we've processed this exact notification recently (within 10 seconds)
    final recentDuplicates = _processedNotifications.where((key) {
      if (!key.startsWith(notificationKey)) return false;
      final parts = key.split('_');
      if (parts.length < 4) return false;
      final timestamp = int.tryParse(parts.last) ?? 0;
      return (now - timestamp) <= 10; // 10 second window
    });

    if (recentDuplicates.isNotEmpty) {
      print(
          '[$requestId] ⚠️ DUPLICATE DETECTED - Same notification processed within 10 seconds');
      return;
    }

    // Add current timestamp to the key
    final timestampedKey = '${notificationKey}_${now}';
    _processedNotifications.add(timestampedKey);

    // Clean up old entries (older than 60 seconds)
    _processedNotifications.removeWhere((key) {
      final parts = key.split('_');
      if (parts.length < 4) return false;
      final timestamp = int.tryParse(parts.last) ?? 0;
      return (now - timestamp) > 60;
    });

    // Extract sender information
    final senderInfo = _extractSenderInfo(packageName, event);
    print('[$requestId] Sender info: $senderInfo');

    try {
      // Analyze the message using the rules engine
      print('[$requestId] 📊 Starting analysis...');
      final verdict = await _rulesEngine.analyze(fullMessage, senderInfo);

      print('[$requestId] ✅ Analysis complete!');
      print('[$requestId] Verdict level: ${verdict.level}');
      print('[$requestId] Risk reasons: ${verdict.reasons}');
      print('[$requestId] Explanation: ${verdict.explanation}');

      // If it's flagged as suspicious or scam, show local alert and send FCM alert to family
      if (verdict.level != RiskLevel.safe) {
        print('[$requestId] 🚨 ALERT TRIGGERED - Showing local alert and sending FCM to family');
        await NotificationService.showScamAlert(
          packageName: packageName,
          originalText: fullMessage,
          verdictLevel: _getVerdictLabel(verdict.level),
          explanation: verdict.explanation,
        );
        print('[$requestId] ✅ Local notification shown');

        // Log the detection for debugging
        print('[$requestId] Scam detected from $packageName: ${verdict.level}');
        print('[$requestId] Risk score: ${verdict.reasons}');

        // Alert all subscribed devices using the unique topic
        print('[$requestId] 📡 Fetching unique topic...');
        final topic = await FcmService.getUniqueTopic();
        print('[$requestId] 📡 Topic obtained: $topic');
        print('[$requestId] 📡 Sending FCM alert to all subscribed devices...');

        await FcmSender.sendToTopic(
          topic: topic,
          title: 'Scam alert - ${verdict.level.toString()}',
          body: 'May natanggap ang iyong family member na posibleng scam. Makipag-usap sa kanya agad para maiwasan ang panganib.',
        );
        print('[$requestId] ✅ FCM alert sent successfully');
      } else {
        print('[$requestId] ✅ Message is SAFE - no alert needed');
      }
    } catch (e, stackTrace) {
      print('[$requestId] ❌ ERROR processing notification: $e');
      print('[$requestId] Stack trace: $stackTrace');
    }

    print('[$requestId] ========== NOTIFICATION PROCESSING COMPLETE ==========\n');
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
