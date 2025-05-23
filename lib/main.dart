import 'package:freedomdriver/feature/app/view/app.dart';
import 'package:freedomdriver/bootstrap.dart';
import 'package:freedomdriver/core/config/environment_config.dart';

void main() async {
  EnvironmentConfig.setEnvironment(Environment.production);
  await bootstrap(() => const App());
}
