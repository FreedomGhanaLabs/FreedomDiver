import 'package:freedom_driver/app/app.dart';
import 'package:freedom_driver/bootstrap.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<bool>('firstTimerUser');
  await bootstrap(() => const App());
}
