import '../models/analysis_result.dart';
import '../models/scam_pattern.dart';
import '../repository/pattern_repository.dart';

class UrgencyDetector {
  static final UrgencyDetector _instance = UrgencyDetector._internal();
  factory UrgencyDetector() => _instance;
  UrgencyDetector._internal();

  final PatternRepository _repository = PatternRepository();

  Future<AnalysisResult> analyze(String message) async {
    await _repository.loadPatterns();
    if (message.trim().isEmpty) {
      return const AnalysisResult(verdict: "Not a scam", riskScore: 0);
    }

    final lowerMsg = message.toLowerCase();
    final Map<ScamPattern, List<String>> phraseMap = {};

    for (var pattern in _repository.patterns) {
      final matchedPhrases = pattern.urgencyPhrases
          .where((p) => lowerMsg.contains(p.toLowerCase()))
          .toList();
      if (matchedPhrases.isNotEmpty) {
        phraseMap[pattern] = matchedPhrases;
      }
    }

    if (phraseMap.isEmpty) {
      return const AnalysisResult(verdict: "Not a scam", riskScore: 0);
    }

    final matchedPatterns = phraseMap.keys.toList();

    // Risk score (0-100)
    final maxBase = matchedPatterns.map((p) => p.riskScore).reduce((a, b) => a > b ? a : b);
    final extraMatches = phraseMap.values.fold(0, (sum, list) => sum + list.length) - matchedPatterns.length;
    final flagBonus = matchedPatterns.fold(0, (sum, p) => sum + p.flags.length) * 8;
    final riskScore = (maxBase + extraMatches * 12 + flagBonus).clamp(0, 100);

    // Verdict
    final verdict = riskScore >= 82
        ? "Scam"
        : riskScore >= 55
            ? "Likely a scam"
            : "Not a scam";

    final triggeredPhrases = phraseMap.values.expand((e) => e).toList();
    final categories = matchedPatterns.map((p) => p.category).toList();

    final topPattern = matchedPatterns.reduce((a, b) => a.riskScore > b.riskScore ? a : b);

    return AnalysisResult(
      verdict: verdict,
      riskScore: riskScore,
      triggeredPhrases: triggeredPhrases,
      matchedCategories: categories,
      explanation: topPattern.explanation['eng'],
    );
  }
}