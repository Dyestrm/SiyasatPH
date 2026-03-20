enum RiskLevel { safe, suspicious, likelyScam }

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
}