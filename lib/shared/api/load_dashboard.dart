import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';

Future<void> loadDashboard(BuildContext context) async {
  final driverCubit = context.read<DriverCubit>();
  final documentCubit = context.read<DocumentCubit>();
  final earningCubit = context.read<EarningCubit>();
  final rideHistoryCubit = context.read<RideHistoryCubit>();

  await Future.wait([
    driverCubit.getDriverProfile(context),
    driverCubit.toggleStatus(context, setAvailable: true, toggleOnlyApi: true),
    earningCubit.getPeriodicEarnings(context),
    rideHistoryCubit.getAllRideHistories(context, showOverlay: false),
    documentCubit.getDriverDocument(context),

  ]);
}
