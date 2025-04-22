import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  final ApiController apiController = ApiController('');
  Driver? _cachedDriver;

  Future<void> getDriverProfile(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    if (_cachedDriver != null && !forceRefresh) {
      log('Using cached driver data');
      emit(DriverLoaded(_cachedDriver!));
      return;
    }

    emit(DriverLoading());
    try {
      await apiController.getData(context, 'profile', (success, responseData) {
        if (success) {
          final driver =
              Driver.fromJson(responseData['data'] as Map<String, dynamic>);
          _cachedDriver = driver;
          log('Driver to emit: ${driver.fullName}');
          emit(DriverLoaded(driver));
        }
      });
    } catch (e) {
      debugPrint('Load Driver profile error: ${(e as dynamic).message}');
      emit(const DriverError('Failed to load driver profile'));
    }
  }

  Future<void> toggleStatus(BuildContext context) async {
    try {
      final currentStatus = _cachedDriver?.status ?? 'unavailable';
      final newStatus =
          currentStatus == 'available' ? 'unavailable' : 'available';

      await apiController.put(context, 'status', {'status': newStatus},
          (success, responseData) {
        log(responseData.toString());

        final updatedDriver = _cachedDriver?.copyWith(status: newStatus);
        _cachedDriver = updatedDriver;

        // Emit the updated driver state
        emit(DriverLoaded(updatedDriver!));
      });
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }

  void resetDriverCache() {
    _cachedDriver = null;
  }
}
