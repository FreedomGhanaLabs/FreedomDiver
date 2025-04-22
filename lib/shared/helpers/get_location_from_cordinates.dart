import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

Future<Map<String, String>> getLocationFromCoordinates(
  List<double> coordinates,
) async {
  final latitude = coordinates[0];
  final longitude = coordinates[1];

  try {
    final placemarks =
        await placemarkFromCoordinates(latitude, longitude);

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
