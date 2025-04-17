import 'package:freedom_driver/app/app.dart';
import 'package:freedom_driver/bootstrap.dart';
import 'package:freedom_driver/core/config/environment_config.dart';

void main() {
  EnvironmentConfig.setEnvironment(Environment.staging);
  bootstrap(() => const App());
}
