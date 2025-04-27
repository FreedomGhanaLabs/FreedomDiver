import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';

extension DriverExtension on BuildContext {
  Driver? get driver {
    final state = read<DriverCubit>().state;
    if (state is DriverLoaded) {
      return state.driver;
    }
    return null;
  }
}
