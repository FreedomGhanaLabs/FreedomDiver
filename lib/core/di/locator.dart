import 'package:freedom_driver/core/API/clients/base_api_clients.dart';
import 'package:freedom_driver/core/config/environment_config.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

 Future<void>locator()async{
   final freedomClient = BaseApiClients(
       baseUrl: EnvironmentConfig.instance.baseUrl);
   getIt.registerSingleton<BaseApiClients>(freedomClient);
 }

