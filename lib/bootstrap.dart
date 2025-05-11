import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freedom_driver/core/di/locator.dart';
import 'package:freedom_driver/utilities/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  
  await NotificationService.initializeNotifications();

  await locator();
  await Hive.initFlutter();
  await Hive.openBox<bool>('firstTimerUser');

  Bloc.observer = const AppBlocObserver();

  // FlutterError.onError = (details) {
  //   log(
  //     'FlutterError: ${details.exceptionAsString()}',
  //     stackTrace: details.stack,
  //   );
  //   FlutterError.presentError(details);
  //   runApp(CustomErrorScreen(errorDetails: details));
  // };

  runApp(await builder());
}
