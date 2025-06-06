import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:hive/hive.dart';

const String rideKey = 'ride';
const String rideBoxKey = 'rideRequests';

Future<RideRequest?> getRideFromHive() async {
  final box = await Hive.openBox(rideBoxKey);
  return box.get(rideKey) as RideRequest?;
}

Future<void> addRideToHive(RideRequest ride) async {
  final box = await Hive.openBox(rideBoxKey);
  await box.put(rideKey, ride);
}

Future<void> deleteRideFromHive() async {
  await Hive.box(rideBoxKey).delete(rideKey);
}
