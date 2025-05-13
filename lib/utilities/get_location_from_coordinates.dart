import 'package:flutter/material.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/widgets/toaster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation(BuildContext context) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showToast(
      context,
      'Error',
      'Location services are disabled.',
      toastType: ToastType.error,
    );
    return Future.error('Location services are disabled.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showToast(
        context,
        'Error',
        'Location permissions are denied',
        toastType: ToastType.error,
      );
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showToast(
      context,
      'Error',
      'Location permissions are permanently denied',
      toastType: ToastType.error,
    );
    return Future.error('Location permissions are permanently denied');
  }

  final position = Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
  return position;
}

Future<Map<String, String>> getLocationFromCoordinates(
  List<double> coordinates,
) async {
  final latitude = coordinates[0];
  final longitude = coordinates[1];

  try {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return {
        'country': place.country ?? '',
        'city': place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            '',
      };
    } else {
      return {'country': '', 'city': ''};
    }
  } catch (e) {
    debugPrint('Reverse geocoding failed: $e');
    return {'country': '', 'city': ''};
  }
}
