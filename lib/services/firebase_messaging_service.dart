import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/scam_alert.dart';
import '../utils/device_utils.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _alertStreamController = StreamController<ScamAlert>.broadcast();
  Stream<ScamAlert> get alertStream => _alertStreamController.stream;

  // ── INITIALIZATION ──────────────────────────────────────────

  Future<void> initialize() async {
    await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessageStatic);

    final token = await _fcm.getToken();
    if (token != null) {
      await _saveDeviceToken(token);
      print('[FirebaseMessagingService] Initialized with token: ${token.substring(0, 20)}...');
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      await _saveDeviceToken(newToken);
    });
  }

  // ── SAVE DEVICE TOKEN ───────────────────────────────────────

  Future<void> _saveDeviceToken(String token) async {
    try {
      final deviceId = await getOrCreateDeviceId();
      await _db
          .collection('DeviceTokens')
          .doc(deviceId)
          .set({
            'device_id': deviceId,
            'fcm_token': token,
            'updated_at': Timestamp.now(),
          }, SetOptions(merge: true))
          .timeout(const Duration(seconds: 5));

      print('[FirebaseMessagingService] Device token saved');
    } catch (e) {
      print('[FirebaseMessagingService] Error saving device token: $e');
    }
  }

  // ── SEND SCAM ALERT TO GUARDIAN ─────────────────────────────

  Future<void> sendScamAlertToGuardian({
    required ScamAlert alert,
    required String guardianDeviceId,
  }) async {
    try {
      // 1. Save alert to Firestore
      final alertRef = await _db.collection('ScamAlerts').add(
        alert.copyWith(guardianDeviceId: guardianDeviceId).toFirestoreMap(),
      );

      // 2. Get guardian's FCM token
      final tokenSnap = await _db
          .collection('DeviceTokens')
          .doc(guardianDeviceId)
          .get();

      if (!tokenSnap.exists) {
        print('[FCMService] Guardian device token not found for: $guardianDeviceId');
        return;
      }

      final guardianToken = tokenSnap['fcm_token'] as String?;
      if (guardianToken == null) {
        print('[FCMService] Guardian FCM token is null');
        return;
      }

      // 3. Queue push notification
      await _sendPushNotification(
        token: guardianToken,
        alertId: alertRef.id,
        alert: alert,
      );

      // 4. Update alert status to sent
      await alertRef.update({
        'status': AlertStatus.sent.name,
        'sent_at': Timestamp.now(),
      });

      print('[FCMService] Scam alert sent to guardian: ${alert.elderName}');
    } catch (e) {
      print('[FCMService] Error sending alert: $e');
    }
  }

  // ── SAVE ALERT TO FIRESTORE (NO PUSH) ───────────────────────

  Future<String> saveAlertToFirestore(ScamAlert alert) async {
    try {
      final alertRef = await _db.collection('ScamAlerts').add(alert.toFirestoreMap());
      print('[FCMService] Alert saved to Firestore: ${alertRef.id}');
      return alertRef.id;
    } catch (e) {
      print('[FCMService] Error saving alert: $e');
      rethrow;
    }
  }

  // ── HANDLE INCOMING MESSAGES ────────────────────────────────

  void _handleForegroundMessage(RemoteMessage message) {
    print('[FCMService] Foreground message: ${message.notification?.title}');
    final alert = _parseAlertFromMessage(message);
    if (alert != null) _alertStreamController.add(alert);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('[FCMService] Background message opened: ${message.notification?.title}');
    final alert = _parseAlertFromMessage(message);
    if (alert != null) _alertStreamController.add(alert);
  }

  static Future<void> _handleBackgroundMessageStatic(RemoteMessage message) async {
    print('[FCMService] Terminated app message: ${message.notification?.title}');
  }

  ScamAlert? _parseAlertFromMessage(RemoteMessage message) {
    try {
      final data = message.data;
      return ScamAlert(
        id: data['alert_id'],
        elderDeviceId: data['elder_device_id'] ?? '',
        guardianDeviceId: data['guardian_device_id'],
        alertType: data['alert_type'] ?? 'scam',
        riskLevel: data['risk_level'] ?? 'suspicious',
        detectedMessage: data['detected_message'] ?? '',
        senderNumber: data['sender_number'] ?? '',
        explanation: data['explanation'] ?? '',
        reasons: (data['reasons'] as String?)?.split('|') ?? [],
        elderName: data['elder_name'],
        guardianName: data['guardian_name'],
        status: AlertStatus.pending,
        detectedAt: DateTime.parse(
          data['detected_at'] ?? DateTime.now().toIso8601String(),
        ),
      );
    } catch (e) {
      print('[FCMService] Error parsing alert from message: $e');
      return null;
    }
  }

  // ── SEND PUSH NOTIFICATION ──────────────────────────────────

  Future<void> _sendPushNotification({
    required String token,
    required String alertId,
    required ScamAlert alert,
  }) async {
    try {
      await _db.collection('FCMQueue').add({
        'fcm_token': token,
        'alert_id': alertId,
        'title': '⚠️ Scam Alert for ${alert.elderName ?? "your elder"}',
        'body': '${alert.riskLevel.toUpperCase()} — ${alert.explanation}',
        'data': {
          'alert_id': alertId,
          'elder_device_id': alert.elderDeviceId,
          'guardian_device_id': alert.guardianDeviceId,
          'alert_type': alert.alertType,
          'risk_level': alert.riskLevel,
          'detected_message': alert.detectedMessage,
          'sender_number': alert.senderNumber,
          'explanation': alert.explanation,
          'reasons': alert.reasons.join('|'),
          'elder_name': alert.elderName ?? '',
          'detected_at': alert.detectedAt.toIso8601String(),
        },
        'status': 'pending',
        'created_at': Timestamp.now(),
      });

      print('[FCMService] Push notification queued for: ${token.substring(0, 20)}...');
    } catch (e) {
      print('[FCMService] Error queueing push notification: $e');
    }
  }

  // ── ACKNOWLEDGE ALERT ───────────────────────────────────────

  Future<void> acknowledgeAlert(String alertId) async {
    try {
      await _db.collection('ScamAlerts').doc(alertId).update({
        'status': AlertStatus.acknowledged.name,
        'acknowledged_at': Timestamp.now(),
      });
      print('[FCMService] Alert acknowledged: $alertId');
    } catch (e) {
      print('[FCMService] Error acknowledging alert: $e');
    }
  }

  // ── CLEANUP ─────────────────────────────────────────────────

  void dispose() {
    _alertStreamController.close();
  }
}