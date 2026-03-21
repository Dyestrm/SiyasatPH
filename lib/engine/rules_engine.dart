import '../models/verdict.dart';
import 'url_checker.dart';
import 'urgency_detector.dart';
import './bank_checker.dart';

class RulesEngine {
  static final RulesEngine _instance = RulesEngine._internal();
  factory RulesEngine() => _instance;
  RulesEngine._internal();

  // Singletons (objects declared once and reused)
  final UrlChecker _urlChecker = UrlChecker();
  final UrgencyDetector _urgencyDetector = UrgencyDetector();
  final BankChecker _bankChecker = BankChecker();

  List<String> selectedBanks = [];
  String language = 'fil';

  Future<Verdict> analyze(String message, String senderNumber) async {
    final reasons = <String>[];
    int score = 0;

    // 1. Urgency detection (uses PatternRepository internally)
    final urgencyResult = await _urgencyDetector.analyze(message);
    score += urgencyResult.riskScore;
    if (urgencyResult.triggeredPhrases.isNotEmpty) {
      for (final phrase in urgencyResult.triggeredPhrases) {
        reasons.add('Urgency language: "$phrase"');
      }
    }

    // 2. URL lookalike check
    final urlResult = await _urlChecker.check(message);
    if (urlResult.isFlagged) {
      score += 30;
      reasons.addAll(urlResult.reasons);
    }

    // 3. Personalized bank check
    if (selectedBanks.isNotEmpty) {
      final lower = message.toLowerCase();
      for (final bank in selectedBanks) {
        if (lower.contains(bank.toLowerCase())) {
          if (urlResult.isFlagged || urgencyResult.riskScore >= 55) {
            score += 15;
            reasons.add('Targets your bank: "$bank"');
            break;
          }
        }
      }
    }

    // 4. Clamp score to 100
    final clampedScore = score.clamp(0, 100);

    // 5. Determine verdict level
    final level = clampedScore >= 82
        ? RiskLevel.likelyScam
        : clampedScore >= 55
            ? RiskLevel.suspicious
            : RiskLevel.safe;

    // 6. Get explanation in user's language
    final explanation = urgencyResult.explanation != null && language == 'eng'
        ? urgencyResult.explanation!
        : _getExplanation(level);

    return Verdict(
      level: level,
      reasons: reasons,
      explanation: explanation,
      senderNumber: senderNumber,
      timestamp: DateTime.now(),
    );
  }

  String _getExplanation(RiskLevel level) {
    if (level == RiskLevel.safe) {
      return language == 'fil'
          ? 'Walang nakitang kahina-hinalang bahagi sa mensaheng ito.'
          : 'No suspicious elements found in this message.';
    }
    if (level == RiskLevel.suspicious) {
      return language == 'fil'
          ? 'May ilang kahina-hinalang bahagi. Mag-ingat at huwag mag-click ng anumang link.'
          : 'This message has some suspicious elements. Do not click any links.';
    }
    return language == 'fil'
        ? 'Ito ay posibleng scam. Huwag sundin ang mga tagubilin. Huwag magbigay ng personal na impormasyon.'
        : 'This is likely a scam. Do not follow the instructions or give personal information.';
  }
}