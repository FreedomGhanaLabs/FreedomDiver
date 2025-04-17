import 'package:hive/hive.dart';

const String onboardingKey = 'onboardingKey';
const String onboardingBox = 'onboarding';

Future<bool?> getOnboardingFromHive() async {
  final box = await Hive.openBox(onboardingBox);
  return box.get(onboardingKey) as bool?;
}

Future<void> addOnboardingToHive(bool value) async {
  final box = await Hive.openBox(onboardingBox);
  await box.put(onboardingKey, value);
}

Future<void> deleteOnboardingToHive(bool value) async {
  await Hive.box(onboardingBox).delete(onboardingKey);
}
