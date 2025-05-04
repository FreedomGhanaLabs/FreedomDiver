import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/utilities/get_location_from_coordinates.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationService {
  DriverLocationService();

  StreamSubscription<Position>? _positionStream;

  Future<bool> _requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<void> sendCurrentLocationOnce(BuildContext context) async {
    final position = await getCurrentLocation(context);

    await _sendToBackend(context, position);
  }

  Future<void> startLiveLocationUpdates(
    BuildContext context, {
    int distanceFilterMeters = 10,
  }) async {
    if (!await _requestPermission()) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) => _sendToBackend(context, position));
  }

  void stopLiveLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _sendToBackend(BuildContext context, Position position) async {
    await context
        .read<DriverCubit>()
        .updateDriverLocation(context, [position.latitude, position.longitude]);
  }
}
