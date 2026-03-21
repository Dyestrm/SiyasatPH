import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../models/scam_report_model.dart';
import '../utils/device_utils.dart';

class ScamReportService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'ScamReports';

  // build report from verdict data
  Future<ScamReportModel> buildReport({
    required String message,
    required List<String> triggeredRules,
    required String verdict,
    String? senderNumber,
  }) async {
    final deviceId = await getOrCreateDeviceId();
    return ScamReportModel(
      messageSnippet: message.length > 300
          ? message.substring(0, 300)
          : message,
      triggeredRules: triggeredRules,
      verdict: verdict,
      deviceId: deviceId,
      createdAt: DateTime.now(),
      senderNumber: senderNumber,
    );
  }

  // save to Firestore
  Future<void> saveReport(ScamReportModel report) async {
    try {
      await _db
          .collection(_collection)
          .add(report.toFirestoreMap())
          .timeout(const Duration(seconds: 5));
    } on TimeoutException catch (_) {
      print('Firestore timed out — report not saved.');
    } catch (e) {
      print('Failed to save report: $e');
    }
  }

  // launch pre-filled email to NTC
  Future<void> launchNtcEmail({
    required String messageSnippet,
    required String verdict,
    required List<String> triggeredRules,
    String? senderNumber,
    String? configName,
    String? elderEmail,
    String? elderContact,
    String? elderAddress,
  }) async {
    final body =
        '''
Text Scam Complaint Report
--------------------------
Full Name: ${configName ?? '[Please fill in]'}
Address: ${elderAddress ?? '[Please fill in]'}
Contact Number: ${elderContact ?? '[Please fill in]'}
Email: ${elderEmail ?? '[Please fill in]'}

Scam Details:
Sender Number: ${senderNumber ?? 'Unknown'}
Verdict: $verdict
Flags Detected: ${triggeredRules.join(', ')}
Message: "$messageSnippet"

[Please attach: screenshot of the scam message and photo of valid ID]
''';

    // manually encode to preserve spaces and line breaks
    final encodedSubject = Uri.encodeComponent('Text Scam Complaint');
    final encodedBody = Uri.encodeComponent(body);

    final uri = Uri.parse(
      'mailto:houmiidono@gmail.com?subject=$encodedSubject&body=$encodedBody', // actual email - kontratextscam@gmail.com
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch mail client.');
    }
  }

  // full flow — save to Firestore then launch email
  Future<void> reportToNtc({
    required String message,
    required List<String> triggeredRules,
    required String verdict,
    String? senderNumber,
    String? configName,
    String? elderEmail,
    String? elderContact,
    String? elderAddress,
  }) async {
    final report = await buildReport(
      message: message,
      triggeredRules: triggeredRules,
      verdict: verdict,
      senderNumber: senderNumber,
    );

    await saveReport(report);

    await launchNtcEmail(
      messageSnippet: report.messageSnippet,
      verdict: verdict,
      triggeredRules: triggeredRules,
      senderNumber: senderNumber,
      configName: configName,
      elderEmail: elderEmail,
      elderContact: elderContact,
      elderAddress: elderAddress,
    );
  }
}
