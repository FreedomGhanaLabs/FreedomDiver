import 'package:hive/hive.dart';

const String fcmTokenKey = 'fcm_token';
const String fcmBoxKey = 'fcm';

Future<String?> getFCMTokenFromHive() async {
  final box = await Hive.openBox(fcmBoxKey);
  return box.get(fcmTokenKey) as String?;
}

Future<void> addFCMTokenToHive(String token) async {
  final box = await Hive.openBox(fcmBoxKey);
  await box.put(fcmTokenKey, token);
}

Future<void> deleteFCMTokenFromHive() async {
  await Hive.box(fcmBoxKey).delete(fcmTokenKey);
}
