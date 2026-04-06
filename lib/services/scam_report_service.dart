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

  // formats DateTime to readable string e.g. "March 20, 2026 - 6:30 PM"
  String _formatDateTime(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    final hour = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
            ? 12
            : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} - $hour:$minute $period';
  }

  // launch pre-filled email to NTC
  Future<void> launchNtcEmail({
    required String messageSnippet,
    required String verdict,
    required List<String> triggeredRules,
    required String scamType,
    required DateTime dateTime,
    String? senderNumber,
    String? userName,
    String? elderEmail,
    String? elderContact,
    String? elderAddress,
    String? additionalComment,
  }) async {
    // build optional sections only if data is present
    final commentSection = (additionalComment != null && additionalComment.isNotEmpty)
        ? '\nAdditional Comments:\n$additionalComment\n'
        : '';

    final body =
        '''
Text Scam Complaint Report
--------------------------
Full Name: ${userName ?? 'Ilagay dito'}
Address: ${elderAddress ?? 'Ilagay dito'}
Contact Number: ${elderContact ?? 'Ilagay dito'}

Scam Details:
Sender Number: ${senderNumber ?? 'Unknown'}
Type of Scam: $scamType
Message: "$messageSnippet"
Date and Time: ${_formatDateTime(dateTime)}
$commentSection

[Paki-attach: screenshot ng scam message at larawan ng valid ID]
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
    required String scamType,
    required DateTime dateTime,
    String? senderNumber,
    String? userName,
    String? elderEmail,
    String? elderContact,
    String? elderAddress,
    String? additionalComment,
    String? attachedFileName,
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
      scamType: scamType,
      dateTime: dateTime,
      triggeredRules: triggeredRules, 
      senderNumber: senderNumber,
      userName: userName,
      elderEmail: elderEmail,
      elderContact: elderContact,
      elderAddress: elderAddress,
      additionalComment: additionalComment,
    );
  }
}
