const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Triggered when a new document is added to FCMQueue.
 * Reads the FCM token and sends a push notification to the guardian's device.
 */
exports.sendScamAlertToGuardian = functions.firestore
  .document("FCMQueue/{docId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const token = data.fcm_token;
    const title = data.title;
    const body = data.body;
    const payload = data.data;

    if (!token) {
      console.error("[FCMQueue] No FCM token found, skipping.");
      await snap.ref.update({ status: "failed", reason: "no_token" });
      return;
    }

    const message = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: {
        alert_id:          payload.alert_id        ?? "",
        elder_device_id:   payload.elder_device_id  ?? "",
        guardian_device_id: payload.guardian_device_id ?? "",
        alert_type:        payload.alert_type       ?? "scam",
        risk_level:        payload.risk_level        ?? "suspicious",
        detected_message:  payload.detected_message  ?? "",
        sender_number:     payload.sender_number     ?? "",
        explanation:       payload.explanation       ?? "",
        reasons:           payload.reasons           ?? "",
        elder_name:        payload.elder_name        ?? "",
        detected_at:       payload.detected_at       ?? "",
      },
      android: {
        priority: "high",
        notification: {
          channelId: "scam_alerts",
          priority: "max",
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log(`[FCMQueue] Push sent successfully: ${response}`);

      // Mark as sent in FCMQueue
      await snap.ref.update({
        status: "sent",
        sent_at: admin.firestore.FieldValue.serverTimestamp(),
        fcm_response: response,
      });

      // Update the ScamAlert status to sent
      if (payload.alert_id) {
        await admin.firestore()
          .collection("ScamAlerts")
          .doc(payload.alert_id)
          .update({
            status: "sent",
            sent_at: admin.firestore.FieldValue.serverTimestamp(),
          });
      }

    } catch (error) {
      console.error(`[FCMQueue] Error sending push: ${error}`);
      await snap.ref.update({
        status: "failed",
        reason: error.message,
      });
    }
  });