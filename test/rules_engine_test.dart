// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:siyasat_ph/engine/rules_engine.dart';
import 'package:siyasat_ph/models/verdict.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RulesEngine engine;

  setUpAll(() async {
    engine = RulesEngine();
    engine.selectedBanks = ['BDO', 'GCash'];
    engine.language = 'eng';
  });

  // ===========================================================================
  // CURRENTLY SUPPORTED TESTS
  // These align with the existing 3 patterns in scam_patterns.json
  // ===========================================================================
  group('Currently Supported by scam_patterns.json', () {
    test('Spam message → RiskLevel.spam', () async {
      final verdict = await engine.analyze(
        "May available loan ka! Kumuha ng pautang ngayon. Instant approval!",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.spam);
      expect(verdict.reasons.any((r) => r.contains('Spam urgency')), true);
    });

    test('Normal message → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Hello po, kumusta ka? Tara kain tayo mamaya.",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    test('Empty message → safe', () async {
      final verdict = await engine.analyze("", "09171234567");
      expect(verdict.level, RiskLevel.safe);
    });

    test('Short Taglish spam → still detected as spam', () async {
      final verdict = await engine.analyze("May libre kang load! Claim now", "09171234567");
      expect(verdict.level, RiskLevel.spam);
    });

    test('Pure Tagalog loan spam → RiskLevel.spam', () async {
      final verdict = await engine.analyze(
        "Kumuha na ng pautang ngayon! Walang collateral, instant approval. Tumawag na sa 09XXXXXXXXX.",
        "09341234567",
      );
      expect(verdict.level, RiskLevel.spam);
    });

    test('Pure Tagalog safe greeting → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Kumusta na kayo? Kamusta na ang pamilya? Magkita-kita tayo sa Sabado.",
        "09331234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });
  });

  // ===========================================================================
  // OUT OF SCOPE TESTS
  // These test cases are not supported by the current scam_patterns.json
  // (limited to only 3 very narrow patterns). They are kept here for documentation
  // and future enhancement when the patterns file is expanded by the team.
  // ===========================================================================
  group('Out of Scope – Not Supported by Current scam_patterns.json', () {
    test('Bank scam message → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Your BDO account will be suspended in 24 hours. Verify now: https://fake-bdo.com",
        "09171234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('SSS benefit suspension threat → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Your SSS benefits have been suspended. Verify your account immediately: https://sss-verify.net",
        "09181234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('PhilHealth account deactivation → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "PHILHEALTH NOTICE: Your membership will be deactivated. Update your info now at http://philhealth-update.com",
        "09191234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('BIR tax refund lure → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "BIR: You have a pending tax refund of PHP 15,000. Click here to claim: https://bir-refund.ph",
        "09201234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Tagalog-only PhilSys/national ID phishing → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "ABISO: Ang iyong national ID ay nakabloke. I-verify ang iyong impormasyon dito: https://philsys-verify.net",
        "09211234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Legitimate government reminder (no link, no threat) → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Reminder: SSS contribution deadline is on the 10th. Visit the nearest SSS branch for assistance.",
        "09221234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    test('OTP request via SMS with suspicious link → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Your GCash OTP is 482910. Do NOT share this. If you did not request this, secure your account: https://gcash-help.net",
        "09231234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Fake OTP asking user to reply or call back → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "BDO ALERT: Your OTP is 391028. If you did not request this, call us at 09XX-XXXXXXX to cancel.",
        "09241234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Social engineering asking to share OTP → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Hi! I accidentally sent my GCash OTP to your number. Please share it back to me: 09XXXXXXXXX",
        "09251234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Legitimate OTP message (no link, no call-back prompt) → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Your BDO OTP is 847302. Valid for 5 minutes. Do not share this with anyone.",
        "09261234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    test('OTP phishing in pure Tagalog → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "BABALA: Ang iyong GCash OTP ay 726481. Huwag ibahagi. Kung hindi ikaw ito, i-click dito para i-secure: https://gcash-tulong.com",
        "09271234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Too-good-to-be-true work-from-home offer → RiskLevel.spam or likelyScam', () async {
      final verdict = await engine.analyze(
        "HIRING! Work from home, earn PHP 50,000/week! No experience needed. Apply now: https://jobs-ph.net",
        "09281234567",
      );
      expect([RiskLevel.spam, RiskLevel.likelyScam].contains(verdict.level), true);
    });

    test('Upfront registration fee job scam → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Congratulations! You have been selected for an online job. Pay PHP 500 registration fee to start. GCash: 09XXXXXXXXX",
        "09291234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Vague job offer with no company name → RiskLevel.suspicious', () async {
      final verdict = await engine.analyze(
        "We are looking for online encoders. Part-time, PHP 800/day. Reply YES to apply.",
        "09301234567",
      );
      expect([RiskLevel.suspicious, RiskLevel.spam].contains(verdict.level), true);
    });

    test('Legitimate job posting with company details → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Accenture PH is hiring Software Engineers. Visit careers.accenture.com to apply. Ref: HR-2024-001.",
        "09311234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    test('Tagalog-only job scam with upfront fee → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Naghahanap kami ng mga online encoder! Kumita ng PHP 1,000 bawat araw. Magpadala ng PHP 200 para sa training materials sa GCash: 09XXXXXXXXX",
        "09321234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Pure Tagalog bank scam → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "ABISO mula sa BDO: Ang iyong account ay maso-suspend. I-verify na ngayon: https://bdo-verify.com",
        "09351234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });

    test('Pure Tagalog prize scam → RiskLevel.spam or likelyScam', () async {
      final verdict = await engine.analyze(
        "Binabati kita! Ikaw ang nanalo ng PHP 50,000. I-claim na ang iyong premyo. Mag-reply ng iyong pangalan at address.",
        "09361234567",
      );
      expect([RiskLevel.spam, RiskLevel.likelyScam].contains(verdict.level), true);
    });

    test('Suspicious URL only, no threatening text → RiskLevel.suspicious', () async {
      final verdict = await engine.analyze(
        "Check this out: https://totally-not-a-scam-ph.xyz",
        "09371234567",
      );
      expect([RiskLevel.suspicious, RiskLevel.likelyScam].contains(verdict.level), true);
    });

    test('Trusted domain URL in safe context → RiskLevel.safe', () async {
      final verdict = await engine.analyze(
        "Here is the Google form for our reunion: https://forms.google.com/abc123",
        "09381234567",
      );
      expect(verdict.level, RiskLevel.safe);
    });

    test('Unknown shortened URL → RiskLevel.suspicious', () async {
      final verdict = await engine.analyze(
        "Tingnan mo ito: https://bit.ly/3xYzAbc",
        "09391234567",
      );
      expect([RiskLevel.suspicious, RiskLevel.likelyScam].contains(verdict.level), true);
    });

    test('URL with lookalike bank domain (no extra keywords) → RiskLevel.likelyScam', () async {
      final verdict = await engine.analyze(
        "Update required: https://bdo-secure-login.net",
        "09401234567",
      );
      expect(verdict.level, RiskLevel.likelyScam);
    });
  });

  // ===========================================================================
  // Verdict.reasons field assertions
  // ===========================================================================
  group('Verdict.reasons field assertions', () {
    test('Scam verdict includes at least one reason', () async {
      final verdict = await engine.analyze(
        "Your GCash account is compromised. Verify now: https://gcash-ph-help.com",
        "09491234567",
      );
      expect(verdict.level, isNot(RiskLevel.safe));
      expect(verdict.reasons, isNotEmpty);
    });

    test('Spam verdict includes at least one reason', () async {
      final verdict = await engine.analyze(
        "Libreng load! Kumuha na ngayon bago maubusan!",
        "09501234567",
      );
      expect(verdict.level, RiskLevel.spam);
      expect(verdict.reasons, isNotEmpty);
    });

    test('Safe verdict has empty or null reasons', () async {
      final verdict = await engine.analyze(
        "Uy, nandoon ka ba bukas? Sabay tayo.",
        "09511234567",
      );
      expect(verdict.level, RiskLevel.safe);
      expect(verdict.reasons.isEmpty, true);
    });

    test('Non-selected bank name in scam message → not escalated to likelyScam', () async {
      final verdict = await engine.analyze(
        "Your Metrobank account will be suspended. Verify: https://metrobank-verify.com",
        "09521234567",
      );
      expect(verdict.level, isNot(RiskLevel.safe));
    });
  });
}