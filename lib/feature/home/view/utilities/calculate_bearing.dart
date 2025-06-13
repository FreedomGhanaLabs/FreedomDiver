import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateBearing(LatLng from, LatLng to) {
  final lat1 = _degreeToRadian(from.latitude);
  final lon1 = _degreeToRadian(from.longitude);
  final lat2 = _degreeToRadian(to.latitude);
  final lon2 = _degreeToRadian(to.longitude);

  final dLon = lon2 - lon1;
  final y = sin(dLon) * cos(lat2);
  final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

  final bearing = atan2(y, x);
  return (_radianToDegree(bearing) + 360) % 360; // Normalize to 0-360°
}

double _degreeToRadian(double degree) => degree * pi / 180;
double _radianToDegree(double radian) => radian * 180 / pi;
