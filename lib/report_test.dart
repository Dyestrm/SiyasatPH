import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/scam_report_service.dart';
import 'services/family_setup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ReportTestScreen());
  }
}

class ReportTestScreen extends StatefulWidget {
  const ReportTestScreen({super.key});

  @override
  State<ReportTestScreen> createState() => _ReportTestScreenState();
}

class _ReportTestScreenState extends State<ReportTestScreen> {
  final _reportService = ScamReportService();
  final _setupService = FamilySetupService();
  String _status = 'No action yet.';

  Future<void> _testBuildReport() async {
    setState(() => _status = 'Building report...');
    try {
      final report = await _reportService.buildReport(
        message:
            'Your BDO account will be suspended. Verify now at bdo-verify.com within 24 hours or your account will be closed.',
        triggeredRules: ['urgency_language', 'lookalike_url'],
        verdict: 'Likely Scam',
        senderNumber: '09171234567',
      );
      setState(
        () => _status =
            '✅ Report built!\n'
            'Snippet: ${report.messageSnippet}\n'
            'Verdict: ${report.verdict}\n'
            'Rules: ${report.triggeredRules.join(", ")}\n'
            'Sender: ${report.senderNumber}',
      );
    } catch (e) {
      setState(() => _status = '❌ Build failed: $e');
    }
  }

  Future<void> _testSaveReport() async {
    setState(() => _status = 'Saving to Firestore...');
    try {
      final report = await _reportService.buildReport(
        message:
            'Your BDO account will be suspended. Verify now at bdo-verify.com within 24 hours.',
        triggeredRules: ['urgency_language', 'lookalike_url'],
        verdict: 'Likely Scam',
        senderNumber: '09171234567',
      );
      await _reportService.saveReport(report);
      setState(
        () => _status =
            '✅ Saved to Firestore! Check Firebase Console → ScamReports.',
      );
    } catch (e) {
      setState(() => _status = '❌ Save failed: $e');
    }
  }

  Future<void> _testEmail() async {
    setState(() => _status = 'Opening email...');
    try {
      final setup = await _setupService.getSetup();
      await _reportService.reportToNtc(
        message:
            'Your BDO account will be suspended. Verify now at bdo-verify.com within 24 hours.',
        triggeredRules: ['urgency_language', 'lookalike_url'],
        verdict: 'Likely Scam',
        senderNumber: '09171234567',
        elderEmail: setup?.elderEmail,
        elderContact: setup?.elderContact,
        elderAddress: setup?.elderAddress,
      );
      setState(() => _status = '✅ Email launched! Check your mail app.');
    } catch (e) {
      setState(() => _status = '❌ Email failed: $e');
    }
  }

  Future<void> _testFullFlow() async {
    setState(() => _status = 'Running full flow...');
    try {
      final setup = await _setupService.getSetup();
      await _reportService.reportToNtc(
        message:
            'Your GCash account will be locked. Click gcash-secure.ph to verify within 24 hours.',
        triggeredRules: ['urgency_language', 'lookalike_url'],
        verdict: 'Likely Scam',
        senderNumber: '09181234567',
        elderEmail: setup?.elderEmail,
        elderContact: setup?.elderContact,
        elderAddress: setup?.elderAddress,
      );
      setState(
        () => _status =
            '✅ Full flow done!\n'
            '1. Report saved to Firestore\n'
            '2. Mail app opened with pre-filled email\n'
            'Elder email: ${setup?.elderEmail ?? "none (not set up)"}\n'
            'Elder contact: ${setup?.elderContact ?? "none (not set up)"}',
      );
    } catch (e) {
      setState(() => _status = '❌ Full flow failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NTC Report Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // STATUS BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(_status, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 20),

            // TEST BUTTONS
            _testButton(
              label: '1. Build Report',
              subtitle: 'Creates report object from dummy data',
              color: Colors.blue,
              onTap: _testBuildReport,
            ),
            _testButton(
              label: '2. Save to Firestore',
              subtitle: 'Saves report — check Firebase Console',
              color: Colors.green,
              onTap: _testSaveReport,
            ),
            _testButton(
              label: '3. Launch Email',
              subtitle: 'Opens mail app with pre-filled NTC email',
              color: Colors.orange,
              onTap: _testEmail,
            ),
            _testButton(
              label: '4. Full Flow',
              subtitle: 'Save + email in one tap',
              color: Colors.red,
              onTap: _testFullFlow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _testButton({
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(14),
          alignment: Alignment.centerLeft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
