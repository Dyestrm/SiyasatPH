import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scam_alert.dart';
import '../utils/device_utils.dart';

class ScamAlertRepository {
  final _db = FirebaseFirestore.instance;
  final _collection = 'ScamAlerts';

  // ── SAVE ALERT ──────────────────────────────────────────────

  Future<String> saveAlert(ScamAlert alert) async {
    try {
      final docRef = await _db.collection(_collection).add(alert.toFirestoreMap());
      print('[ScamAlertRepository] Alert saved: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('[ScamAlertRepository] Error saving alert: $e');
      rethrow;
    }
  }

  // ── GET ALERTS FOR ELDER DEVICE ─────────────────────────────

  Future<List<ScamAlert>> getAlertsForElder({int limit = 50}) async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final snapshot = await _db
          .collection(_collection)
          .where('elder_device_id', isEqualTo: deviceId)
          .orderBy('detected_at', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ScamAlert.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('[ScamAlertRepository] Error getting elder alerts: $e');
      return [];
    }
  }

  // ── GET ALERTS FOR GUARDIAN DEVICE ──────────────────────────

  Future<List<ScamAlert>> getAlertsForGuardian({int limit = 50}) async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final snapshot = await _db
          .collection(_collection)
          .where('guardian_device_id', isEqualTo: deviceId)
          .orderBy('detected_at', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ScamAlert.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('[ScamAlertRepository] Error getting guardian alerts: $e');
      return [];
    }
  }

  // ── GET UNACKNOWLEDGED ALERTS ───────────────────────────────

  Future<List<ScamAlert>> getUnacknowledgedAlerts() async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final snapshot = await _db
          .collection(_collection)
          .where('guardian_device_id', isEqualTo: deviceId)
          .where('status', isNotEqualTo: AlertStatus.acknowledged.name)
          .orderBy('status')
          .orderBy('detected_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ScamAlert.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('[ScamAlertRepository] Error getting unacknowledged alerts: $e');
      return [];
    }
  }

  // ── GET ALERT BY ID ─────────────────────────────────────────

  Future<ScamAlert?> getAlertById(String alertId) async {
    try {
      final doc = await _db.collection(_collection).doc(alertId).get();
      if (!doc.exists) return null;
      return ScamAlert.fromFirestore(doc.id, doc.data()!);
    } catch (e) {
      print('[ScamAlertRepository] Error getting alert by ID: $e');
      return null;
    }
  }

  // ── UPDATE ALERT STATUS ─────────────────────────────────────
  // FIX: typed as Map<String, dynamic> to allow Timestamp values

  Future<void> updateAlertStatus(String alertId, AlertStatus status) async {
    try {
      final Map<String, dynamic> update = {
        'status': status.name,
      };

      if (status == AlertStatus.acknowledged) {
        update['acknowledged_at'] = Timestamp.now();
      } else if (status == AlertStatus.sent) {
        update['sent_at'] = Timestamp.now();
      }

      await _db.collection(_collection).doc(alertId).update(update);
      print('[ScamAlertRepository] Alert status updated: $alertId -> ${status.name}');
    } catch (e) {
      print('[ScamAlertRepository] Error updating alert status: $e');
      rethrow;
    }
  }

  // ── DELETE ALERT ────────────────────────────────────────────

  Future<void> deleteAlert(String alertId) async {
    try {
      await _db.collection(_collection).doc(alertId).delete();
      print('[ScamAlertRepository] Alert deleted: $alertId');
    } catch (e) {
      print('[ScamAlertRepository] Error deleting alert: $e');
      rethrow;
    }
  }

  // ── GET ALERT STATISTICS ────────────────────────────────────

  Future<Map<String, int>> getAlertStats() async {
    try {
      final deviceId = await getOrCreateDeviceId();
      final allAlerts = await _db
          .collection(_collection)
          .where('guardian_device_id', isEqualTo: deviceId)
          .get();

      final alerts = allAlerts.docs
          .map((doc) => ScamAlert.fromFirestore(doc.id, doc.data()))
          .toList();

      return {
        'total': alerts.length,
        'pending': alerts.where((a) => a.status == AlertStatus.pending).length,
        'sent': alerts.where((a) => a.status == AlertStatus.sent).length,
        'acknowledged': alerts.where((a) => a.status == AlertStatus.acknowledged).length,
        'likelyScam': alerts.where((a) => a.riskLevel == 'likelyScam').length,
        'suspicious': alerts.where((a) => a.riskLevel == 'suspicious').length,
        'spam': alerts.where((a) => a.riskLevel == 'spam').length,
      };
    } catch (e) {
      print('[ScamAlertRepository] Error getting stats: $e');
      return {};
    }
  }

  // ── STREAM ALERTS (REAL-TIME) ───────────────────────────────
  // FIX: use async* with await for getOrCreateDeviceId()

  Stream<List<ScamAlert>> streamAlertsForGuardian() async* {
    final deviceId = await getOrCreateDeviceId();
    yield* _db
        .collection(_collection)
        .where('guardian_device_id', isEqualTo: deviceId)
        .orderBy('detected_at', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScamAlert.fromFirestore(doc.id, doc.data()))
            .toList());
  }
}