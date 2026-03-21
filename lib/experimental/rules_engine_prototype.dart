import 'package:flutter/material.dart';
import '../engine/rules_engine.dart';
import '../repository/history_repository.dart';
import '../models/history_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'SiyasatPH Test', home: TestScreen());
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

  String _historyText = 'Loading history...';
  List<HistoryEntry> _historyEntries = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); // automatically loads history when screen opens
  }

  Future<void> _test(String message, String label) async {
    setState(() => _result = 'Analyzing...');
    final verdict = await _engine.analyze(message, '09171234567');

    /* ----History Tracking test---- */
    await HistoryRepository().saveAnalysis(message, verdict);
    await HistoryRepository().displayHistory();
    await _loadHistory();

    setState(() {
      _result =
          '''
				TEST: $label

				Verdict: ${verdict.level.name}
				Score reasons:
				${verdict.reasons.isEmpty ? '• None' : verdict.reasons.map((r) => '• $r').join('\n')}

				Explanation:
				${verdict.explanation}
			''';
    });
  }

  /* ----History Tracking Test---- */
  Future<void> _loadHistory() async {
    try {
      final entries = await HistoryRepository().getAll();
      setState(() {
        _historyEntries = entries;
        _historyText = entries.isEmpty
            ? 'No analysis history yet.'
            : '📜 ${entries.length} saved analyses\n\n'
                  'Latest: ${entries.first.result.level.name} '
                  '(${entries.first.result.explanation})';
      });
    } catch (e) {
      setState(() => _historyText = 'Error loading history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SiyasatPH Engine Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Test 1 — obvious scam
            ElevatedButton(
              onPressed: () => _test(
                'Your BDO account is suspended. Verify now at bdo-verify.com/login or your account will be closed.',
                'Obvious Scam (BDO fake URL + urgency)',
              ),
              child: const Text('Test 1 — Obvious Scam'),
            ),
            const SizedBox(height: 8),
            // Test 2 — suspicious only
            ElevatedButton(
              onPressed: () => _test(
                'Please verify your GCash account immediately.',
                'Suspicious (urgency only, no URL)',
              ),
              child: const Text('Test 2 — Suspicious'),
            ),
            const SizedBox(height: 8),
            // Test 3 — safe message
            ElevatedButton(
              onPressed: () => _test(
                'Your OTP is 123456. Valid for 5 minutes. Do not share this with anyone.',
                'Safe (OTP message)',
              ),
              child: const Text('Test 3 — Safe'),
            ),
            const SizedBox(height: 8),
            // Test 4 — government scam
            ElevatedButton(
              onPressed: () => _test(
                'SSS: Your benefit is ready. Claim within 24 hours at sss-claim.com',
                'Government Scam (SSS fake URL)',
              ),
              child: const Text('Test 4 — Gov Scam'),
            ),
            const SizedBox(height: 16),
            // Analysis History
            const Text(
              '📜 History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(_historyText, style: const TextStyle(fontSize: 13)),
            ),
            // Result display
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
