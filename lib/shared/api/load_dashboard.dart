import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';

import '../../core/di/locator.dart';
import '../../feature/home/view/widgets/home_widgets.dart';
import '../../feature/rides/cubit/ride/ride_cubit.dart';
import '../../utilities/notification_service.dart';
import '../../utilities/socket_service.dart';
import 'load_document_histories.dart';

Future<void> loadDashboard(BuildContext context) async {
  final driverCubit = context.read<DriverCubit>();
  final documentCubit = context.read<DocumentCubit>();
  final earningCubit = context.read<EarningCubit>();
  final rideHistoryCubit = context.read<RideHistoryCubit>();
  final driverLocationService = getIt<DriverLocationService>();
  final driverSocketService = getIt<DriverSocketService>();

  await driverLocationService.requestPermission();
  await driverLocationService.sendCurrentLocationOnce(context);

  await Future.wait([
    NotificationService.initializeNotifications(),
    driverCubit.getDriverProfile(context),
    driverCubit.toggleStatus(context, setAvailable: true, toggleOnlyApi: true),
    earningCubit.getPeriodicEarnings(context),
    rideHistoryCubit.getAllRideHistories(context, showOverlay: false),
    documentCubit.getDriverDocument(context),
    loadDocumentHistories(context),
  ]);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    driverSocketService.connect(
      onNewRideRequest: (ride) async {
        log('[Socket Ride Request] ride request received');
        context.read<RideCubit>().foundRide(ride, context);
        buildRideFoundDialog(context);
      },
    );
  });
}
