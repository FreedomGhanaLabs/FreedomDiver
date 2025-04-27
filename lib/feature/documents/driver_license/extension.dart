import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_cubit.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/driver_license_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';


extension DriverExtension on BuildContext {
  DriverLicense? get driverLicense {
    final state = read<DriverLicenseCubit>().state;
    if (state is DriverLicenseLoaded) {
      return state.driverLicense ; //as DriverLicense?
    }
    return null;
  }
}
