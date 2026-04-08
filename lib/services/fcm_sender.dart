import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FcmSender {
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
  }) async {
    print('[FcmSender] Starting sendToTopic - Topic: $topic');
    print('[FcmSender] Title: $title');
    print('[FcmSender] Body: $body');

    // Load service account JSON from assets
    final jsonString =
        await rootBundle.loadString('assets/secrets/siyasatph_service_account.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);

    // Get OAuth token
    print('[FcmSender] Authenticating with service account...');
    final client = await clientViaServiceAccount(serviceAccount, _scopes);

    // Get project ID from service account
    final projectId = jsonDecode(jsonString)['project_id'];
    print('[FcmSender] Project ID: $projectId');

    // Send to FCM
    print('[FcmSender] Sending request to FCM API...');
    final response = await client.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': {
          'topic': topic,
          'notification': {
            'title': title,
            'body': body,
          }
        }
      }),
    );

    print('[FcmSender] Response status code: ${response.statusCode}');

    // Error handling
    if (response.statusCode == 200) {
      print('✅ [FcmSender] Notification sent successfully!');
    } else {
      print('❌ [FcmSender] Failed to send notification: ${response.body}');
    }

    client.close();
  }

}