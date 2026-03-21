// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:siyasat_ph/engine/url_checker.dart';
import 'package:siyasat_ph/engine/bank_checker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BankChecker checker;
  late UrlCheckResult flaggedResult;
  late UrlCheckResult cleanResult;

  setUpAll(() {
    checker = BankChecker();
    flaggedResult = UrlCheckResult(
      foundUrls: ['fake.com'], 
      suspiciousUrls: ['fake.com'], 
      reasons: ['fake'], 
      isFlagged: true,
    );
    cleanResult = UrlCheckResult(
      foundUrls: ['official.com'], 
      suspiciousUrls: [], 
      reasons: [], 
      isFlagged: false,
    );
  });

  group('Bank Checker Matcher', () {
    test('1. Unidentified bank link = High', () async {
      final res = await checker.check("Metrobank verify https://fake-metrobank.com", ['BDO'], flaggedResult);
      expect(res.riskScore, 35);
    });

    /* This test fails because the risk score is supposed to be 35 
      but PBN is not included in verified_domain.json
      the checker ignores it and gives a risk score of 0.

      Try changing PBN to BPI and rerun the test 
    */  
    test('2. Unidentified bank name = High', () async {
      final res = await checker.check("Your PBN account is suspended", ['BDO'], cleanResult);  // ← changed to BPI
      expect(res.riskScore, 35);
    });

    test('3. Identified bank link but is flagged = High', () async {
      final res = await checker.check("BDO click here https://bdo-fake.com", ['BDO'], flaggedResult);
      expect(res.riskScore, 35);
    });

    test('4. No bank name nor link = Low (0)', () async {
      final res = await checker.check("Hello how are you?", ['BDO', 'GCash'], cleanResult);
      expect(res.riskScore, 0);
    });

    test('5. Identified bank name (no link) = Low (10)', () async {
      final res = await checker.check("Your GCash balance is ready", ['GCash'], cleanResult);
      expect(res.riskScore, 10);
    });

    test('6. Identified bank link and is not flagged = 0', () async {
      final res = await checker.check("BDO statement: https://bdo.com.ph", ['BDO'], cleanResult);
      expect(res.riskScore, 0);
    });
  });
}