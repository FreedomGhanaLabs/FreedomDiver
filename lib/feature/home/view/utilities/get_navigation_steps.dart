import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import '../../../../shared/app_config.dart';

Future<List<String>> getNavigationSteps({
  required LatLng origin,
  required LatLng destination,
}) async {
  final dio = Dio();

  final url =
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=driving'
      '&key=$mapsAPIKey';

  final response = await dio.get(url);

  if (response.statusCode == 200) {
    final data = response.data is String ? json.decode(response.data) : response.data;
    final steps = data['routes'][0]['legs'][0]['steps'];

    return steps.map<String>((step) {
      final htmlInstruction = step['html_instructions'] as String;
      final plainText = htmlInstruction.replaceAll(RegExp(r'<[^>]*>'), '');
      return plainText;
    }).toList();
  } else {
    throw Exception('Failed to get directions: ${response.data}');
  }
}
