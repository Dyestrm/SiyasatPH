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

    // Create a map that connects each pattern to the exact phrases it matched.
    // This lets us track both the patterns and the evidence for the UI.
    final Map<ScamPattern, List<String>> phraseMap = {};

    for (var pattern in _repository.patterns) {
      // Check both urgency phrases and keywords to catch more scam signals.
      final matchedUrgency = pattern.urgencyPhrases
          .where((p) => lowerMsg.contains(p.toLowerCase()))
          .toList();
      final matchedKeywords = pattern.keywords
          .where((k) => lowerMsg.contains(k.toLowerCase()))
          .toList();

      final allMatches = [...matchedUrgency, ...matchedKeywords];
      if (allMatches.isNotEmpty) {
        phraseMap[pattern] = allMatches;
      }
    }

    if (phraseMap.isEmpty) {
      return const AnalysisResult(verdict: "Not a scam", riskScore: 0);
    }

    final matchedPatterns = phraseMap.keys.toList();

    // Start with the highest risk score from all matched patterns.
    int riskScore = matchedPatterns.map((p) => p.riskScore).reduce((a, b) => a > b ? a : b);

    // Add small bonuses: +12 if multiple patterns match, +18 if a bank is mentioned.
    if (matchedPatterns.length > 1) riskScore += 12;
    if (matchedPatterns.any((p) => p.institutions.isNotEmpty)) riskScore += 18;

    riskScore = riskScore.clamp(0, 95);

    // Gather all matched phrases from every pattern.
    // This allows the app to show users the exact words that triggered the detection.
    final triggeredPhrases = phraseMap.values.expand((e) => e).toList();

    // Collect the categories of all matched patterns.
    // Useful for grouping results in the user interface.
    final categories = matchedPatterns.map((p) => p.category).toList();

    // Choose the pattern with the highest risk score.
    // We use its explanation because it gives the clearest warning.
    final topPattern = matchedPatterns.reduce((a, b) => a.riskScore > b.riskScore ? a : b);

    return AnalysisResult(
      verdict: "Likely a scam",
      riskScore: riskScore,
      triggeredPhrases: triggeredPhrases,
      matchedCategories: categories,
      explanation: topPattern.explanation['eng'],
    );
  }
}