// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:siyasat_ph/engine/rules_engine.dart';
import 'package:siyasat_ph/models/verdict.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RulesEngine engine;

  setUpAll(() async {
    engine = RulesEngine();
    engine.selectedBanks = ['BDO', 'GCash']; // simulate user setup
    engine.language = 'eng';
  });

  group('RulesEngine Integration – Spam vs Scam vs Safe + Edge Cases', () {
    // 1. Pure Spam (Loan/Pautang, Sabong, Prize, etc.)
    test('Spam message → RiskLevel.spam', () async {
      final verdict = await engine.analyze(
        "May available loan ka! Kumuha ng pautang ngayon. Instant approval!",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.spam);
      expect(verdict.reasons.any((r) => r.contains('Spam urgency')), true);
    });

    // 2. Real Scam (Bank/Government/Prize from the other scam_patterns.json)
    test('Bank scam message → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Your BDO account will be suspended in 24 hours. Verify now: https://fake-bdo.com",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    // 3. Safe message
    test('Normal message → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Hello po, kumusta ka? Tara kain tayo mamaya.",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    // 4. Mixed (spam + scam patterns) — prioritizes Spam (as per our design)
    test('Mixed spam + scam → RiskLevel.spam (spam wins)', () async {
      final verdict = await engine.analyze(
        "Nanalo ka ng prize! Claim now. Also your GCash is blocked: https://fake.com",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.spam);
    });

    // 5. Edge cases
    test('Empty message → safe', () async {
      final verdict = await engine.analyze("", "09171234567");
      expect(verdict.level, RiskLevel.safe);
    });

    test('Short Taglish spam → still detected as spam', () async {
      final verdict = await engine.analyze("May libre kang load! Claim now", "09171234567");
      expect(verdict.level, RiskLevel.spam);
    });

    test('From saved contact → still flagged (for now)', () async {
      // TODO: Once UI provides isSavedContact, we can downgrade spam here
      final verdict = await engine.analyze(
        "May available loan ka! Kumuha ng pautang ngayon",
        "09171234567", // assume this is saved contact
      );
      expect(verdict.level, RiskLevel.spam); // still flagged (as designed until whitelist added)
    });
  });
}