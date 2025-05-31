import 'package:freedomdriver/feature/rides/models/accept_ride.dart';
import 'package:hive/hive.dart';

const String rideKey = 'ride';
const String rideBoxKey = 'ride_request';

Future<AcceptRide?> getRideFromHive() async {
  final box = await Hive.openBox(rideBoxKey);
  return box.get(rideKey) as AcceptRide?;
}

Future<void> addRideToHive(AcceptRide ride) async {
  final box = await Hive.openBox(rideBoxKey);
  await box.put(rideKey, ride);
}

Future<void> deleteRideFromHive() async {
  await Hive.box(rideBoxKey).delete(rideKey);
}
