class ScamReportModel {
  final String messageSnippet;
  final List<String> triggeredRules;
  final String verdict;
  final String deviceId;
  final DateTime createdAt;
  final String status;
  final String? senderNumber;

  ScamReportModel({
    required this.messageSnippet,
    required this.triggeredRules,
    required this.verdict,
    required this.deviceId,
    required this.createdAt,
    this.status = 'pending',
    this.senderNumber,
  });

  Map<String, dynamic> toFirestoreMap() => {
    'message_snippet': messageSnippet,
    'triggered_rules': triggeredRules,
    'verdict': verdict,
    'device_id': deviceId,
    'created_at': createdAt,
    'status': status,
    'sender_number': senderNumber ?? 'Unknown',
  };
}
