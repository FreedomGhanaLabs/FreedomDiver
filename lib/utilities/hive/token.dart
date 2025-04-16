import 'package:hive/hive.dart';

const String authTokenKey = 'token';
const String authBoxKey = 'auth';

Future<String?> getTokenFromHive() async {
  final box = await Hive.openBox(authBoxKey);
  return box.get(authTokenKey) as String?;
}

Future<void> addTokenToHive(String token) async {
  final box = await Hive.openBox(authBoxKey);
  await box.put(authTokenKey, token);
}
Future<void> deleteTokenToHive(String token) async {
 await Hive.box(authBoxKey).delete(authTokenKey);
}
