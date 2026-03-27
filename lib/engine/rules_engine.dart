import 'package:siyasat_ph/models/analysis_result.dart';
import 'package:siyasat_ph/models/bank_check_result.dart';
import '../models/verdict.dart';
import 'url_checker.dart';
import 'urgency_detector.dart';
import 'spam_detector.dart';
import './bank_checker.dart';

class RulesEngine {
  static final RulesEngine _instance = RulesEngine._internal();
  factory RulesEngine() => _instance;
  RulesEngine._internal();

  // Singletons (objects declared once and reused)
  final UrlChecker _urlChecker = UrlChecker();
  final UrgencyDetector _urgencyDetector = UrgencyDetector();
  final SpamDetector _spamDetector = SpamDetector();
  final BankChecker _bankChecker = BankChecker();

  List<String> selectedBanks = [];
  String language = 'fil';

  Future<Verdict> analyze(String message, String senderNumber) async {
    final results = await _runAllDetectors(message);
    final totalScore = _calculateTotalScore(results);
    final clampedScore = totalScore.clamp(0, 100);
    final level = _determineRiskLevel(results, clampedScore);

    final reasons = <VerdictReason>[];
    _addReasonsFromResults(reasons, results, level);

    final explanation = _getExplanation(level);

    final List<String> tags = [];
    if (level == RiskLevel.safe) {
      if (results.urgency.riskScore == 0) tags.add('No urgency');
      if (!results.url.isFlagged) tags.add('No fake URLs');
      if (results.spam.riskScore == 0) tags.add('No Suspicious Keywords');
    }

    return Verdict(
      level: level,
      reasons: reasons,
      tags: tags,
      explanation: explanation,
      senderNumber: senderNumber,
      timestamp: DateTime.now(),
    );
  }

  Future<_DetectorResults> _runAllDetectors(String message) async {
    final urlResult = await _urlChecker.check(message);
    return _DetectorResults(
      spam: await _spamDetector.analyze(message),
      urgency: await _urgencyDetector.analyze(message),
      url: urlResult,
      bank: await _bankChecker.check(message, selectedBanks, urlResult),
    );
  }

  void _addReasonsFromResults(List<VerdictReason> reasons, _DetectorResults results, RiskLevel level) {
    final isSuspicious = level == RiskLevel.suspicious;
    final urgencyLabel = isSuspicious ? 'BABALA' : 'BAKIT NA FLAG';

    if (results.urgency.triggeredPhrases.isNotEmpty) {
      final phrases = results.urgency.triggeredPhrases.toSet().toList();
      final deduped = phrases.where((phrase) =>
        !phrases.any((other) => other != phrase && other.contains(phrase))
      ).toList();

      reasons.add(VerdictReason(
        label: urgencyLabel,
        title: 'Urgency Language',
        body: '${deduped.map((p) => '• $p').join('\n')}\n\n${results.urgency.explanation ?? ''}',
      ));
    }

    if (results.spam.triggeredPhrases.isNotEmpty) {
      final phrases = results.spam.triggeredPhrases.toSet().toList();
      final deduped = phrases.where((phrase) =>
        !phrases.any((other) => other != phrase && other.contains(phrase))
      ).toList();

      reasons.add(VerdictReason(
        label: urgencyLabel,
        title: 'Spam Language',
        body: '${deduped.map((p) => '• $p').join('\n')}\n\n${results.spam.explanation ?? ''}',
      ));
    }

    for (final reason in results.url.reasons) {
      reasons.add(VerdictReason(
        label: 'FAKE LINK',
        title: '',
        body: reason,
      ));
    }

    for (final reason in results.bank.reasons) {
      reasons.add(VerdictReason(
        label: 'HINDI SIGURADO?',
        title: '',
        body: reason,
      ));
    }
  }

  int _calculateTotalScore(_DetectorResults results) {
    int score = results.spam.riskScore + results.urgency.riskScore + results.bank.riskScore;
    if (results.url.isFlagged) score += 35;
    return score;
  }

  RiskLevel _determineRiskLevel(_DetectorResults results, int clampedScore) {
    if (results.spam.riskScore >= 35 && !results.url.isFlagged) {
      return RiskLevel.spam;
    }
    if (results.url.isFlagged && results.urgency.riskScore >= 20) {
      return RiskLevel.likelyScam;
    }
    if (results.urgency.riskScore >= 78) {
      return RiskLevel.likelyScam;
    }
    if (clampedScore >= 55) {
      return RiskLevel.suspicious;
    }
    if (results.spam.riskScore >= 35) {
      return RiskLevel.spam;
    }
    return RiskLevel.safe;
  }

  String _getExplanation(RiskLevel level) {
    if (level == RiskLevel.safe) {
      return language == 'fil'
          ? 'Walang nakitang kahina-hinalang bahagi sa mensaheng ito.'
          : 'No suspicious elements found in this message.';
    }
    if (level == RiskLevel.spam) {
      return language == 'fil'
          ? 'Ito ay promotional spam. Maaari itong i-ignore nang ligtas.'
          : 'This appears to be promotional spam. It can be safely ignored.';
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

// Private helper class to keep analyze() short and readable
class _DetectorResults {
  final AnalysisResult spam;
  final AnalysisResult urgency;
  final UrlCheckResult url;
  final BankCheckResult bank;

  _DetectorResults({
    required this.spam,
    required this.urgency,
    required this.url,
    required this.bank,
  });
}