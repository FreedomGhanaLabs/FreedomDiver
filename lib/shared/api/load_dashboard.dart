import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/core/di/locator.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/shared/api/load_document_histories.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/notification_service.dart';

Future<void> loadDashboard(BuildContext context, {bool loadAll = true}) async {
  if (!context.mounted) return;
  final driverCubit = context.read<DriverCubit>();
  final documentCubit = context.read<DocumentCubit>();
  final earningCubit = context.read<EarningCubit>();
  final rideHistoryCubit = context.read<RideHistoryCubit>();
  final rideCubit = context.read<RideCubit>();
  final driverLocationService = getIt<DriverLocationService>();

  if (loadAll) {
    await driverLocationService.sendCurrentLocationOnce(context);
  }

  await Future.wait([
    if (loadAll) NotificationService.initializeNotifications(),
    driverCubit.getDriverProfile(context),
    driverCubit.toggleStatus(context, setAvailable: true, toggleOnlyApi: true),
    rideCubit.checkForActiveRide(context),
    earningCubit.getPeriodicEarnings(context),
    rideHistoryCubit.getAllRideHistories(context, showOverlay: false),
    context.read<FinancialCubit>().getWalletBalance(context),
    documentCubit.getDriverDocument(context),
    loadDocumentHistories(context),
  ]);
}
