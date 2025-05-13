import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/earnings/cubit/earnings_state.dart';
import 'package:freedom_driver/feature/earnings/models/earning.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';

class EarningCubit extends Cubit<EarningState> {
  EarningCubit() : super(EarningInitial());

  final _apiController = ApiController('ride');

  static String errorMessage(String firstName) {
    return 'Sorry $firstName! We could not retrieve your earnings at the moment. Please ensure that you have good internet connection or restart the app. If this difficulty persist please contact our support team';
  }

  Earning? _cachedEarning;
  DateTime? _cacheTimestamp;

  bool get _isCacheValid =>
      _cachedEarning != null &&
      _cacheTimestamp != null &&
      DateTime.now().difference(_cacheTimestamp!).inMinutes < 60;

  Future<void> getPeriodicEarnings(
    BuildContext context, {
    String period = 'weekly',
  }) async {
    emit(EarningLoading());
    // If cache is valid, use it
    if (_isCacheValid) {
      emit(EarningLoaded(_cachedEarning!));
      log('[Ride History Cubit] using cached earning data');
      return;
    }

    try {
      await _apiController.getData(context, 'earnings?period=$period',
          (success, data) {
        if (success) {
          log('${data['data']} data from earning api');
          final earning =
              Earning.fromJson(data['data'] as Map<String, dynamic>);
          _cachedEarning = earning;
          emit(EarningLoaded(earning));
        } else {
          emit(const EarningError('Failed to load earnings'));
        }
      });
    } catch (e, stack) {
      log('[EarningCubit] error: $e', stackTrace: stack);
      emit(const EarningError('An error occurred while fetching earnings'));
    }
  }

  /// Forces cache invalidation and reloads ride history
  Future<void> refreshEarnings(BuildContext context) async {
    _cachedEarning = null;
    _cacheTimestamp = null;
    await getPeriodicEarnings(context);
  }
}
