import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/feature/rides/cubit/ride_history/ride_history_state.dart';
import 'package:freedom_driver/feature/rides/models/ride.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:get/get.dart';

class RideHistoryCubit extends Cubit<RideHistoryState> {
  RideHistoryCubit() : super(RideHistoryInitial());

  final ApiController apiController = ApiController('ride');

  static String errorMessage(String firstName) {
    return 'Sorry ${firstName.capitalize}! We could not retrieve your ride history at the moment. Please ensure that you have good internet connection or restart the app. If this difficulty persist please contact our support';
  }

  Ride? _cachedRide;
  DateTime? _cacheTimestamp;

  bool get _isCacheValid =>
      _cachedRide != null &&
      _cacheTimestamp != null &&
      DateTime.now().difference(_cacheTimestamp!).inMinutes < 60;

  Future<void> getAllRideHistories(
    BuildContext context, {
    String status = 'completed',
    int page = 1,
    int limit = 10,
    bool showOverlay = true,

  }) async {
    // If cache is valid, use it
    if (_isCacheValid) {
      emit(RideHistoryLoaded(_cachedRide!));
      log('[Ride History Cubit] using cached data' );
      return;
    }

    emit(RideHistoryLoading());
    try {
      await apiController.getData(
        context,
        'history?status=$status&page=$page&limit=$limit',
        (success, data) {
          if (success) {
            final ride = Ride.fromJson(data as Map<String, dynamic>);
            _cachedRide = ride;
            _cacheTimestamp = DateTime.now();
            emit(RideHistoryLoaded(ride));
            log('[Ride History Cubit] loaded ride history from api $data');
            
          } else {
            emit(
              RideHistoryError(
                errorMessage(context.driver?.firstName ?? 'Driver'),
              ),
            );
          }
        },
        showOverlay: showOverlay,
      );
    } catch (e) {
      emit(
        RideHistoryError(
          errorMessage(context.driver?.firstName ?? 'Driver'),
        ),
      );
    }
  }

  /// Forces cache invalidation and reloads ride history
  Future<void> refreshRideHistory(BuildContext context) async {
    _cachedRide = null;
    _cacheTimestamp = null;
    await getAllRideHistories(context);
  }

  void invalidateCache() {
    _cachedRide = null;
    _cacheTimestamp = null;
  }
}
