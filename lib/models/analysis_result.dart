class AnalysisResult {
  final String verdict;
  final int riskScore;
  final List<String> triggeredPhrases;
  final List<String> matchedCategories;
  final String? explanation;

  const AnalysisResult({
    required this.verdict,
    required this.riskScore,
    this.triggeredPhrases = const [],
    this.matchedCategories = const [],
    this.explanation,
  });
}