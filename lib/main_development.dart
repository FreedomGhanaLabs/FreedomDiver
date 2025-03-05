import 'package:freedom_driver/app/app.dart';
import 'package:freedom_driver/bootstrap.dart';
import 'package:freedom_driver/core/config/environment_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  EnvironmentConfig.setEnvironment(Environment.development);
  await Hive.initFlutter();
  await Hive.openBox<bool>('firstTimerUser');
  await bootstrap(() => const App());
}
