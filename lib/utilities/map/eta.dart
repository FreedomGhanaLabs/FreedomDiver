import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:freedomdriver/shared/app_config.dart';

Future<Map<String, String>> getETA(
  LatLng? driverLocation,
  LatLng? pickupLocation,
) async {
  final dio = Dio();
  const apiKey = mapsAPIKey;
  final originLat = driverLocation!.latitude;
  final originLng = driverLocation.longitude;
  final destLat = pickupLocation!.latitude;
  final destLng = pickupLocation.longitude;

  final url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey';

  try {
    final response = await dio.get(url);

    if (response.statusCode == 200 &&
        response.data['routes'].isNotEmpty as bool) {
      // debugPrint('${response.data['routes'][0]}');
      final duration =
          response.data['routes'][0]['legs'][0]['duration']['text'];
      final distance =
          response.data['routes'][0]['legs'][0]['distance']['text'];
      return {'duration': duration as String, 'distance': distance.toString()};
    } else {
      throw Exception('No routes found or bad response.');
    }
  } catch (e) {
    throw Exception('Failed to load ETA: $e');
  }
}
