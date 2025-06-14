import 'dart:convert';

import 'package:freedomdriver/feature/rides_and_delivery/models/request_ride.dart';
import 'package:hive/hive.dart';

const String rideKey = 'ride';
const String rideBoxKey = 'rideRequest';

Future<RideRequest?> getRideRequestFromHive() async {
  final box = await Hive.openBox<String>(rideBoxKey);
  final jsonString = box.get(rideKey);
  if (jsonString == null) return null;
  try {
    final jsonMap = jsonDecode(jsonString);
    return RideRequest.fromJson(jsonMap);
  } catch (_) {
    return null;
  }
}

Future<void> addRideRequestToHive(RideRequest ride) async {
  final box = await Hive.openBox<String>(rideBoxKey);
  final jsonString = jsonEncode(ride.toJson());
  await box.put(rideKey, jsonString);
}

Future<void> deleteRideRequestFromHive() async {
  final box = await Hive.openBox<String>(rideBoxKey);
  await box.delete(rideKey);
}
