class BankCheckResult {
  final int riskScore;      // 0, 10 (Low), or 35 (High)
  final List<String> reasons;

  BankCheckResult({
    required this.riskScore,
    this.reasons = const [],
  });
}