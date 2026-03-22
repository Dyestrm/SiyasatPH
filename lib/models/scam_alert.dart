import 'package:cloud_firestore/cloud_firestore.dart';

enum AlertStatus { pending, sent, acknowledged, dismissed }

/// ScamAlert represents a scam detection event
/// 
/// Data sources:
/// - FROM SMS NOTIFICATION: detectedMessage, senderNumber
/// - FROM FAMILY SETUP CONFIG: elderDeviceId, elderName, guardianDeviceId, guardianName
/// - FROM VERDICT ENGINE: riskLevel, explanation, reasons
class ScamAlert {
  final String? id; // Firestore doc ID
  
  // ── From elder's phone (SMS detector) ────────────────────────
  final String elderDeviceId;           // Device where SMS received
  final String detectedMessage;         // Actual SMS message text
  final String senderNumber;            // Sender phone number (all we get from SMS)
  
  // ── From family setup config ────────────────────────────────
  final String? guardianDeviceId;       // Guardian's device (if linked)
  final String? elderName;              // Elder identifier from setup
  final String? guardianName;           // Guardian name from setup
  
  // ── From scam detection engine ──────────────────────────────
  final String alertType;               // 'scam', 'spam', 'suspicious'
  final String riskLevel;               // 'likelyScam', 'suspicious', 'spam'
  final String explanation;             // Reason for detection
  final List<String> reasons;           // Detailed flags
  
  // ── Status tracking ─────────────────────────────────────────
  final AlertStatus status;
  final DateTime detectedAt;
  final DateTime? sentAt;               // When notification sent to guardian
  final DateTime? acknowledgedAt;       // When guardian acknowledged

  ScamAlert({
    this.id,
    required this.elderDeviceId,
    this.guardianDeviceId,
    required this.alertType,
    required this.riskLevel,
    required this.detectedMessage,
    required this.senderNumber,
    required this.explanation,
    required this.reasons,
    this.elderName,
    this.guardianName,
    required this.status,
    required this.detectedAt,
    this.sentAt,
    this.acknowledgedAt,
  });

  Map<String, dynamic> toFirestoreMap() => {
    'elder_device_id': elderDeviceId,
    'guardian_device_id': guardianDeviceId,
    'alert_type': alertType,
    'risk_level': riskLevel,
    'detected_message': detectedMessage,
    'sender_number': senderNumber,
    'explanation': explanation,
    'reasons': reasons,
    'elder_name': elderName,
    'guardian_name': guardianName,
    'status': status.name,
    'detected_at': Timestamp.fromDate(detectedAt),
    'sent_at': sentAt != null ? Timestamp.fromDate(sentAt!) : null,
    'acknowledged_at': acknowledgedAt != null ? Timestamp.fromDate(acknowledgedAt!) : null,
  };

  factory ScamAlert.fromFirestore(String docId, Map<String, dynamic> map) =>
      ScamAlert(
        id: docId,
        elderDeviceId: map['elder_device_id'],
        guardianDeviceId: map['guardian_device_id'],
        alertType: map['alert_type'],
        riskLevel: map['risk_level'],
        detectedMessage: map['detected_message'],
        senderNumber: map['sender_number'],
        explanation: map['explanation'],
        reasons: List<String>.from(map['reasons'] ?? []),
        elderName: map['elder_name'],
        guardianName: map['guardian_name'],
        status: AlertStatus.values.byName(map['status'] ?? 'pending'),
        detectedAt: (map['detected_at'] as Timestamp).toDate(),
        sentAt: map['sent_at'] != null ? (map['sent_at'] as Timestamp).toDate() : null,
        acknowledgedAt: map['acknowledged_at'] != null ? (map['acknowledged_at'] as Timestamp).toDate() : null,
      );

  ScamAlert copyWith({
    String? id,
    String? elderDeviceId,
    String? guardianDeviceId,
    String? alertType,
    String? riskLevel,
    String? detectedMessage,
    String? senderNumber,
    String? explanation,
    List<String>? reasons,
    String? elderName,
    String? guardianName,
    AlertStatus? status,
    DateTime? detectedAt,
    DateTime? sentAt,
    DateTime? acknowledgedAt,
  }) =>
      ScamAlert(
        id: id ?? this.id,
        elderDeviceId: elderDeviceId ?? this.elderDeviceId,
        guardianDeviceId: guardianDeviceId ?? this.guardianDeviceId,
        alertType: alertType ?? this.alertType,
        riskLevel: riskLevel ?? this.riskLevel,
        detectedMessage: detectedMessage ?? this.detectedMessage,
        senderNumber: senderNumber ?? this.senderNumber,
        explanation: explanation ?? this.explanation,
        reasons: reasons ?? this.reasons,
        elderName: elderName ?? this.elderName,
        guardianName: guardianName ?? this.guardianName,
        status: status ?? this.status,
        detectedAt: detectedAt ?? this.detectedAt,
        sentAt: sentAt ?? this.sentAt,
        acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      );
}
