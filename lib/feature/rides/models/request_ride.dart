import 'package:hive/hive.dart';

T? safeParse<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
  if (json is Map<String, dynamic>) {
    return fromJson(json);
  }
  return null;
}

@HiveType(typeId: 0)
class RideRequest extends HiveObject {
  RideRequest({
    required this.rideId,
    this.user,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.etaToPickup,
    required this.totalFare,
    required this.driverEarnings,
    required this.status,
    required this.paymentMethod,
    required this.type,
    required this.estimatedFare,
    required this.currency,
    required this.isMultiStop,
    required this.rideType,
  });

  @HiveField(0)
  final String rideId;

  @HiveField(1)
  final User? user;

  @HiveField(2)
  final Location pickupLocation;

  @HiveField(3)
  final Location dropoffLocation;

  @HiveField(4)
  final Distance? estimatedDistance;

  @HiveField(5)
  final DurationInfo? estimatedDuration;

  @HiveField(6)
  final DurationInfo? etaToPickup;

  @HiveField(7)
  final int? totalFare;

  @HiveField(8)
  final int driverEarnings;

  @HiveField(9)
  final String status;

  @HiveField(10)
  final String paymentMethod;

  @HiveField(11)
  final String type;

  @HiveField(12)
  final double estimatedFare;

  @HiveField(13)
  final String currency;

  @HiveField(14)
  final bool isMultiStop;

  @HiveField(15)
  final String rideType;

  factory RideRequest.fromJson(Map<String, dynamic> json) => RideRequest(
    rideId: json['rideId'].toString(),
    user: safeParse(json['user'], User.fromJson),
    pickupLocation: Location.fromJson(json['pickupLocation']),
    dropoffLocation: Location.fromJson(json['dropoffLocation']),
    estimatedDistance: safeParse(json['estimatedDistance'], Distance.fromJson),
    estimatedDuration: safeParse(
      json['estimatedDuration'],
      DurationInfo.fromJson,
    ),
    etaToPickup: safeParse(json['etaToPickup'], DurationInfo.fromJson),
    totalFare: (json['totalFare'] as num?)?.toInt(),
    driverEarnings: (json['driverEarnings'] as num?)?.toInt() ?? 0,
    status: json['status']?.toString() ?? '',
    paymentMethod: json['paymentMethod']?.toString() ?? '',
    type: json['type'].toString(),
    estimatedFare: (json['estimatedFare'] as num?)?.toDouble() ?? 0.0,
    currency: json['currency'].toString(),
    isMultiStop: json['isMultiStop'] as bool? ?? false,
    rideType: json['rideType'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'rideId': rideId,
    'user': user?.toJson(),
    'pickupLocation': pickupLocation.toJson(),
    'dropoffLocation': dropoffLocation.toJson(),
    'estimatedDistance': estimatedDistance?.toJson(),
    'estimatedDuration': estimatedDuration?.toJson(),
    'etaToPickup': etaToPickup?.toJson(),
    'totalFare': totalFare,
    'driverEarnings': driverEarnings,
    'status': status,
    'paymentMethod': paymentMethod,
    'type': type,
    'estimatedFare': estimatedFare,
    'currency': currency,
    'isMultiStop': isMultiStop,
    'rideType': rideType,
  };

  RideRequest copyWith({
    String? rideId,
    User? user,
    Location? pickupLocation,
    Location? dropoffLocation,
    Distance? estimatedDistance,
    DurationInfo? estimatedDuration,
    DurationInfo? etaToPickup,
    int? totalFare,
    int? driverEarnings,
    String? status,
    String? paymentMethod,
    String? type,
    double? estimatedFare,
    String? currency,
    bool? isMultiStop,
    String? rideType,
  }) {
    return RideRequest(
      rideId: rideId ?? this.rideId,
      user: user ?? this.user,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      etaToPickup: etaToPickup ?? this.etaToPickup,
      totalFare: totalFare ?? this.totalFare,
      driverEarnings: driverEarnings ?? this.driverEarnings,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      type: type ?? this.type,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      currency: currency ?? this.currency,
      isMultiStop: isMultiStop ?? this.isMultiStop,
      rideType: rideType ?? this.rideType,
    );
  }
}

@HiveType(typeId: 1)
class User extends HiveObject {
  User({required this.id, required this.name, required this.phone});

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'].toString(),
    name: json['name'].toString(),
    phone: json['phone'].toString(),
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};
}

@HiveType(typeId: 2)
class Location extends HiveObject {
  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  @HiveField(0)
  final String type;

  @HiveField(1)
  final List<double> coordinates;

  @HiveField(2)
  final String address;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'].toString(),
    coordinates:
        (json['coordinates'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        [],
    address: json['address'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
    'address': address,
  };
}

@HiveType(typeId: 3)
class Distance extends HiveObject {
  Distance({required this.value, required this.text});

  @HiveField(0)
  final int value;

  @HiveField(1)
  final String text;

  factory Distance.fromJson(Map<String, dynamic> json) =>
      Distance(value: json['value'] as int, text: json['text'].toString());

  Map<String, dynamic> toJson() => {'value': value, 'text': text};
}

@HiveType(typeId: 4)
class DurationInfo extends HiveObject {
  DurationInfo({required this.value, required this.text});

  @HiveField(0)
  final int value;

  @HiveField(1)
  final String text;

  factory DurationInfo.fromJson(Map<String, dynamic> json) =>
      DurationInfo(value: json['value'] as int, text: json['text'].toString());

  Map<String, dynamic> toJson() => {'value': value, 'text': text};
}
