import 'package:freedomdriver/core/API/clients/base_api_clients.dart';
import 'package:freedomdriver/core/config/environment_config.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:get_it/get_it.dart';

import '../../utilities/socket_service.dart';

final getIt = GetIt.instance;

Future<void> locator() async {
  final freedomClient = BaseApiClients(
    baseUrl: EnvironmentConfig.instance.baseUrl,
  );
  getIt
    ..registerSingleton<BaseApiClients>(freedomClient)
    ..registerSingleton<DriverLocationService>(DriverLocationService())
    ..registerSingleton<DriverSocketService>(DriverSocketService());
}
