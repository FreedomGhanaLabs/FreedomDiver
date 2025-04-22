import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  ApiController apiController = ApiController('profile');

  Future<void> getDriverProfile(BuildContext context) async {
    emit(DriverLoading());
    try {
      await apiController.getData(context, '', (success, responseData) {
        if (success) {
          final driver =
              Driver.fromJson(responseData['data'] as Map<String, dynamic>);
          emit(DriverLoaded(driver));
        }
      });
    } catch (e) {
      debugPrint('Load Driver profile error: ${(e as dynamic).message}');
      emit(const DriverError('Failed to load driver profile'));
    }
  }
}
