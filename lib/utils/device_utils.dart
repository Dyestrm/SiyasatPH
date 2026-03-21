import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// gets/creates device id
Future<String> getOrCreateDeviceId() async {
  final prefs = await SharedPreferences.getInstance();
  String? deviceId = prefs.getString('device_id');
  if (deviceId == null) {
    deviceId = const Uuid().v4(); // generates anonymous hash
    await prefs.setString('device_id', deviceId);
  }
  return deviceId;
}
