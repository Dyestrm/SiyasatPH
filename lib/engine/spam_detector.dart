// spam_detector.dart  ← MAJOR FIX
import '../models/analysis_result.dart';
import '../models/scam_pattern.dart';
import '../repository/spam_pattern_repository.dart';

class SpamDetector {
  static final SpamDetector _instance = SpamDetector._internal();
  factory SpamDetector() => _instance;
  SpamDetector._internal();

  final SpamPatternRepository _repository = SpamPatternRepository();

  Future<AnalysisResult> analyze(String message) async {
    await _repository.loadPatterns();
    if (message.trim().isEmpty) {
      return const AnalysisResult(verdict: "Not spam", riskScore: 0);
    }

    final lowerMsg = message.toLowerCase();

    // Create a map that connects each pattern to the exact phrases it matched.
    // This lets us track both the patterns and the evidence for the UI.
    final Map<ScamPattern, List<String>> phraseMap = {};

    for (var pattern in _repository.patterns) {
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
      return const AnalysisResult(verdict: "Not spam", riskScore: 0);
    }

    final matchedPatterns = phraseMap.keys.toList();

    // Take the highest risk score from all matched patterns.
    // The final score reflects the most dangerous pattern found.
    final riskScore = matchedPatterns
        .map((p) => p.riskScore)
        .reduce((a, b) => a > b ? a : b);

    // Gather all matched phrases from every pattern.
    // This allows the app to show users the exact words that triggered the detection.
    final triggeredPhrases = phraseMap.values.expand((e) => e).toList();
    
    // Collect the categories of all matched patterns.
    // Useful for grouping results in the user interface.
    final categories = matchedPatterns.map((p) => p.category).toList();

    // Choose the pattern with the highest risk score.
    // We use its explanation because it gives the clearest warning.
    final topPattern = matchedPatterns.reduce((a, b) => a.riskScore > b.riskScore ? a : b);

    // TODO: Once frontend team builds UI, swap this with UI-provided localized text elements
    return AnalysisResult(
      verdict: "Spam",
      riskScore: riskScore,
      triggeredPhrases: triggeredPhrases,
      matchedCategories: categories,
      explanation: topPattern.explanation['eng'],
    );
  }
}