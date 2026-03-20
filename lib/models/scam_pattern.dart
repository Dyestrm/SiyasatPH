class ScamPattern {
  final String category;
  final List<String> urgencyPhrases;
  final List<String> keywords;
  final List<String> flags;
  final List<String> institutions;
  final int riskScore;
  final String verdict;
  final Map<String, String> explanation;

  const ScamPattern({
    required this.category,
    required this.urgencyPhrases,
    required this.keywords,
    required this.flags,
    required this.institutions,
    required this.riskScore,
    required this.verdict,
    required this.explanation,
  });

  factory ScamPattern.fromJson(Map<String, dynamic> json) {
    return ScamPattern(
      category: json['category'] ?? '',
      urgencyPhrases: List<String>.from(json['urgency_phrases'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      flags: List<String>.from(json['flags'] ?? []),
      institutions: List<String>.from(json['institutions'] ?? []),
      riskScore: json['risk_score'] ?? 0,
      verdict: json['verdict'] ?? '',
      explanation: Map<String, String>.from(json['explanation'] ?? {}),
    );
  }
}