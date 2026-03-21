import 'url_checker.dart';
import '../models/bank_check_result.dart';

class BankChecker {
  static final BankChecker _instance = BankChecker._internal();
  factory BankChecker() => _instance;
  BankChecker._internal();

  final UrlChecker _urlChecker = UrlChecker();

  Future<BankCheckResult> check(
    String message,
    List<String> selectedBanks,
    UrlCheckResult urlResult,
  ) async {
    await _urlChecker.loadDomains(); // reuse verified_domains.json

    final lower = message.toLowerCase();
    final foundUrls = _extractUrls(lower);
    final bool hasUrl = foundUrls.isNotEmpty;

    // Use verified_domains.json as source of truth (institutions only)
    final knownInstitutions = _urlChecker.domains
        .map((d) => d['institution'].toString().toLowerCase())
        .toSet();

    final selectedLower = selectedBanks.map((s) => s.toLowerCase()).toSet();

    final mentioned = knownInstitutions.where((i) => lower.contains(i)).toSet();
    final unidentified = mentioned.where((i) => !selectedLower.contains(i)).toList();
    final hasIdentified = mentioned.any((i) => selectedLower.contains(i));

    int riskScore = 0;
    final reasons = <String>[];

    if (unidentified.isNotEmpty) {
      riskScore = 35; // High – Test cases 1 & 2
      reasons.add('Unidentified institution mentioned: ${unidentified.join(", ")}');
    } else if (hasIdentified) {
      final bool isFlaggedLink = hasUrl && urlResult.isFlagged;
      if (isFlaggedLink) {
        riskScore = 35; // High – Test case 3
        reasons.add('Flagged link for your institution');
      } else if (!hasUrl) {
        riskScore = 10; // Low – Test case 5
        reasons.add('Your institution mentioned without link');
      } else {
        riskScore = 0; // Clean identified link – Test case 6
        reasons.add('Clean link to your institution');
      }
    }
    // Test case 4 naturally = 0

    return BankCheckResult(riskScore: riskScore, reasons: reasons);
  }

  List<String> _extractUrls(String text) {
    final pattern = RegExp(
      r'https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}[^\s]*',
      caseSensitive: false,
    );
    return pattern.allMatches(text).map((m) => m.group(0)!).toList();
  }
}