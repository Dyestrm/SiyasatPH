import 'package:siyasat_ph/screens/verdict_screen.dart';

enum RiskLevel { safe, suspicious, likelyScam, spam }

class Verdict {
  final RiskLevel level;
  final List<String> reasons;
  final String explanation;
  final String senderNumber;
  final DateTime timestamp;

  Verdict({
    required this.level,
    required this.reasons,
    required this.explanation,
    required this.senderNumber,
    required this.timestamp,
  });

  factory Verdict.fromJson(Map<String, dynamic> json) {
    return Verdict(
      level: RiskLevel.values.byName(json['level'] as String),
      reasons: List<String>.from(json['reasons'] ?? []),
      explanation: json['explanation'] as String,
      senderNumber: json['senderNumber'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'reasons': reasons,
    'explanation': explanation,
    'senderNumber': senderNumber,
    'timestamp': timestamp.toIso8601String(),
  };
}
extension VerdictToScanResult on Verdict {
  ScanResult toScanResult({
    required String originalMessage,
    required String sender,
  }) {
    final VerdictType uiVerdict = switch (level) {
      RiskLevel.safe       => VerdictType.safe,
      RiskLevel.suspicious => VerdictType.suspicious,
      RiskLevel.likelyScam       => VerdictType.scam,
      RiskLevel.spam       => VerdictType.spam,
    };

    final List<FlagItem> flags = reasons.map((reason) => FlagItem(
          label: 'BAKIT NA FLAG',
          title: '',
          body: reason,
        )).toList();

    return ScanResult(
      verdict: uiVerdict,
      message: originalMessage,
      sender: sender,
      flags: flags,
      tags: const [],
    );
  }
}