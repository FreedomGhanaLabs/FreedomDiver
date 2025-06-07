import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension DriverExtension on BuildContext {
  Driver? get driver {
    final state = read<DriverCubit>().state;
    if (state is DriverLoaded) {
      return state.driver;
    }
    return null;
  }

  LatLng? get driverLatLng {
    final coords = driver?.location?.coordinates;
    if (coords == null || coords.length < 2) return null;
    return LatLng(coords[1], coords[0]);
  }

  List<double>? get driverCords {
    return driver?.location?.coordinates;
  }
}
