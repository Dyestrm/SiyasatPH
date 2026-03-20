import 'package:flutter/material.dart';
import 'engine/rules_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SiyasatPH Test',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _result = 'Press a button to test';
  final _engine = RulesEngine();

  Future<void> _test(String message, String label) async {
    setState(() => _result = 'Analyzing...');
    final verdict = await _engine.analyze(message, '09171234567');
    setState(() {
      _result = '''
TEST: $label

Verdict: ${verdict.level.name}
Score reasons:
${verdict.reasons.isEmpty ? '• None' : verdict.reasons.map((r) => '• $r').join('\n')}

Explanation:
${verdict.explanation}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SiyasatPH Engine Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _test(
                'Your BDO account is suspended. Verify now at bdo-verify.com/login or your account will be closed.',
                'Obvious Scam (BDO fake URL + urgency)',
              ),
              child: const Text('Test 1 — Obvious Scam'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _test(
                'Please verify your GCash account immediately.',
                'Suspicious (urgency only, no URL)',
              ),
              child: const Text('Test 2 — Suspicious'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _test(
                'Your OTP is 123456. Valid for 5 minutes. Do not share this with anyone.',
                'Safe (OTP message)',
              ),
              child: const Text('Test 3 — Safe'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _test(
                'SSS: Your benefit is ready. Claim within 24 hours at sss-claim.com',
                'Government Scam (SSS fake URL)',
              ),
              child: const Text('Test 4 — Gov Scam'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}