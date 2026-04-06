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
    // Load service account JSON from assets
    final jsonString = await rootBundle.loadString('assets/secrets/service_account.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);

    // Get OAuth token
    final client = await clientViaServiceAccount(serviceAccount, _scopes);

    // Get project ID from service account
    final projectId = jsonDecode(jsonString)['project_id'];

    // Send to FCM
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

    // Error handling
    if (response.statusCode == 200) {
      print('✅ Notification sent successfully!');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }

    client.close();
  }

}