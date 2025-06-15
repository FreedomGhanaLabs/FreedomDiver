import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/widgets/toaster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationService {
  StreamSubscription<Position>? _positionStream;

  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
  );

  // Handles permission check and shows appropriate toasts
  Future<bool> _handlePermission(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _showLocationError(context, 'Location services are disabled.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showLocationError(context, 'Location permissions are denied.');
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationError(
        context,
        'Location permissions are permanently denied.',
      );
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation(BuildContext context) async {
    if (!context.mounted) return null;
    final hasPermission = await _handlePermission(context);
    if (!hasPermission) {
      return Future.error('Location permission not granted.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    );
  }

  Future<void> sendCurrentLocationOnce(BuildContext context) async {
    if (!context.mounted) return;
    try {
      final position = await getCurrentLocation(context);
      await sendToBackend(context, position);
    } catch (e) {
      debugPrint('Error getting/sending location: $e');
    }
  }

  Future<void> startLiveLocationUpdates(BuildContext context) async {
    if (!context.mounted) return;
    if (!await _handlePermission(context)) return;

    _positionStream?.cancel(); // Prevent multiple listeners

    _positionStream = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).listen((position) {
      sendToBackend(context, position);
    });
  }

  void stopLiveLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> sendToBackend(BuildContext context, Position? position) async {
    debugPrint(
      'Couldn\'t send location: ${position?.latitude}, ${position?.longitude}',
    );
    if (position == null) return;
    debugPrint('Sending location: ${position.latitude}, ${position.longitude}');
    try {
      await context.read<DriverCubit>().updateDriverLocation(context, [
        position.longitude,
        position.latitude,
        // 6.736301,
        // 7.801245,
      ]);
      // lat -  7.801245,
      // long - 6.736301
    } catch (e) {
      debugPrint('Failed to send location to backend: $e');
    }
  }

  Future<Map<String, String>> getLocationFromCoordinates(
    List<double> coordinates,
  ) async {
    final latitude = coordinates[0];
    final longitude = coordinates[1];

    try {
      final placemark = await placemarkFromCoordinates(latitude, longitude);

      if (placemark.isNotEmpty) {
        final place = placemark.first;
        final placeData = {
          'country': place.country ?? '',
          'city':
              place.locality ??
              place.subAdministrativeArea ??
              place.administrativeArea ??
              '',
        };
        debugPrint('[GeoCoding] $placeData');
        return placeData;
      } else {
        final placeData = {'country': '', 'city': ''};
        return placeData;
      }
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
      return {'country': '', 'city': ''};
    }
  }

  void _showLocationError(BuildContext context, String message) {
    showToast(context, 'Location Error', message, toastType: ToastType.error);
  }
}
