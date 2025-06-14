T? safeParse<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
  if (json is Map<String, dynamic>) {
    return fromJson(json);
  }
  return null;
}

class RideRequest {

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
    etaToDropoff: safeParse(json['etaToDropoff'], DurationInfo.fromJson),
    totalFare: (json['totalFare'] as num?)?.toInt(),
    driverEarnings: (json['driverEarnings'] as num?)?.toInt() ?? 0,
    status: json['status']?.toString() ?? '',
    paymentMethod: json['paymentMethod']?.toString() ?? '',
    paymentStatus: json['paymentStatus']?.toString() ?? '',
    type: json['type'].toString(),
    estimatedFare: (json['estimatedFare'] as num?)?.toDouble() ?? 0.0,
    currency: json['currency'].toString(),
    isMultiStop: json['isMultiStop'] as bool? ?? false,
    rideType: json['rideType'].toString(),
  );
  RideRequest({
    required this.rideId,
    this.user,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.etaToPickup,
    required this.etaToDropoff,
    required this.totalFare,
    required this.driverEarnings,
    required this.status,
    required this.paymentMethod,
    this.paymentStatus,
    required this.type,
    required this.estimatedFare,
    required this.currency,
    required this.isMultiStop,
    required this.rideType,
  });

  final String rideId;
  final User? user;
  final Location pickupLocation;
  final Location dropoffLocation;
  final Distance? estimatedDistance;
  final DurationInfo? estimatedDuration;
  final DurationInfo? etaToPickup;
  final DurationInfo? etaToDropoff;
  final int? totalFare;
  final int driverEarnings;
  final String status;
  final String paymentMethod;
  final String? paymentStatus;
  final String type;
  final double estimatedFare;
  final String currency;
  final bool isMultiStop;
  final String rideType;

  Map<String, dynamic> toJson() => {
    'rideId': rideId,
    'user': user?.toJson(),
    'pickupLocation': pickupLocation.toJson(),
    'dropoffLocation': dropoffLocation.toJson(),
    'estimatedDistance': estimatedDistance?.toJson(),
    'estimatedDuration': estimatedDuration?.toJson(),
    'etaToPickup': etaToPickup?.toJson(),
    'etaToDropoff': etaToDropoff?.toJson(),
    'totalFare': totalFare,
    'driverEarnings': driverEarnings,
    'status': status,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
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
    DurationInfo? etaToDropoff,
    int? totalFare,
    int? driverEarnings,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
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
      etaToDropoff: etaToDropoff ?? this.etaToDropoff,
      totalFare: totalFare ?? this.totalFare,
      driverEarnings: driverEarnings ?? this.driverEarnings,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      type: type ?? this.type,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      currency: currency ?? this.currency,
      isMultiStop: isMultiStop ?? this.isMultiStop,
      rideType: rideType ?? this.rideType,
    );
  }
}

class User {

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'].toString(),
    name: json['name'].toString(),
    phone: json['phone'].toString(),
  );
  User({required this.id, required this.name, required this.phone});

  final String id;
  final String name;
  final String phone;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};
}

class Location {

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'].toString(),
    coordinates:
        (json['coordinates'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        [],
    address: json['address'].toString(),
  );
  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  final String type;
  final List<double> coordinates;
  final String address;

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
    'address': address,
  };
}

class Distance {

  factory Distance.fromJson(Map<String, dynamic> json) =>
      Distance(value: json['value'] as int, text: json['text'].toString());
  Distance({required this.value, required this.text});

  final int value;
  final String text;

  Map<String, dynamic> toJson() => {'value': value, 'text': text};
}

class DurationInfo {

  factory DurationInfo.fromJson(Map<String, dynamic> json) =>
      DurationInfo(value: json['value'] as int, text: json['text'].toString());
  DurationInfo({required this.value, required this.text});

  final int value;
  final String text;

  Map<String, dynamic> toJson() => {'value': value, 'text': text};
}
