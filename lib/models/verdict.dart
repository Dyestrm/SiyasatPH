import 'package:siyasat_ph/screens/verdict_screen.dart';

enum RiskLevel { safe, suspicious, likelyScam, spam }

class Verdict {
  final RiskLevel level;
  final List<VerdictReason> reasons;
  final List<String> tags;
  final String explanation;
  final String senderNumber;
  final DateTime timestamp;

  Verdict({
    required this.level,
    required this.reasons,
    required this.tags,
    required this.explanation,
    required this.senderNumber,
    required this.timestamp,
  });

  factory Verdict.fromJson(Map<String, dynamic> json) {
    return Verdict(
      level: RiskLevel.values.byName(json['level'] as String),
      reasons: (json['reasons'] as List)
        .map((r) => VerdictReason(
              label: r['label'] as String,
              title: r['title'] as String,
              body: r['body'] as String,
            ))
        .toList(),
      tags: List<String>.from(json['tags'] ?? []),
      explanation: json['explanation'] as String,
      senderNumber: json['senderNumber'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'reasons': reasons.map((r) => {
      'label': r.label,
      'title': r.title,
      'body': r.body,
    }).toList(),
    'tags': tags,
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

    final List<FlagItem> flags = reasons.map((r) => FlagItem(
      label: r.label,
      title: r.title,
      body: r.body,
    )).toList();

    return ScanResult(
      verdict: uiVerdict,
      message: originalMessage,
      sender: sender,
      flags: flags,
      tags: tags,
    );
  }
}

class VerdictReason {
  final String label;
  final String title;
  final String body;

  const VerdictReason({
    required this.label,
    required this.title,
    required this.body,
  });
}