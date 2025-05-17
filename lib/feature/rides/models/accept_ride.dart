class AcceptRide {
  AcceptRide({
    required this.rideId,
    required this.user,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.etaToPickup,
    required this.totalFare,
    required this.driverEarnings,
    required this.status,
    required this.paymentMethod,
  });

  factory AcceptRide.fromJson(Map<String, dynamic> json) => AcceptRide(
        rideId: json['rideId'].toString(),
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        pickupLocation:
            Location.fromJson(json['pickupLocation'] as Map<String, dynamic>),
        dropoffLocation:
            Location.fromJson(json['dropoffLocation'] as Map<String, dynamic>),
        estimatedDistance: Distance.fromJson(
            json['estimatedDistance'] as Map<String, dynamic>,),
        estimatedDuration: DurationInfo.fromJson(
            json['estimatedDuration'] as Map<String, dynamic>,),
        etaToPickup:
            DurationInfo.fromJson(json['etaToPickup'] as Map<String, dynamic>),
        totalFare: json['totalFare'] as int,
        driverEarnings: json['driverEarnings'] as int,
        status: json['status'].toString(),
        paymentMethod: json['paymentMethod'].toString(),
      );
  final String rideId;
  final User user;
  final Location pickupLocation;
  final Location dropoffLocation;
  final Distance estimatedDistance;
  final DurationInfo estimatedDuration;
  final DurationInfo etaToPickup;
  final int totalFare;
  final int driverEarnings;
  final String status;
  final String paymentMethod;

  Map<String, dynamic> toJson() => {
        'rideId': rideId,
        'user': user.toJson(),
        'pickupLocation': pickupLocation.toJson(),
        'dropoffLocation': dropoffLocation.toJson(),
        'estimatedDistance': estimatedDistance.toJson(),
        'estimatedDuration': estimatedDuration.toJson(),
        'etaToPickup': etaToPickup.toJson(),
        'totalFare': totalFare,
        'driverEarnings': driverEarnings,
        'status': status,
        'paymentMethod': paymentMethod,
      };

  AcceptRide copyWith({
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
  }) {
    return AcceptRide(
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
    );
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        name: json['name'].toString(),
        phone: json['phone'].toString(),
      );
  final String id;
  final String name;
  final String phone;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
      };

  User copyWith({
    String? id,
    String? name,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json['type'].toString(),
        coordinates: List<double>.from(json['coordinates'] as List<double>),
        address: json['address'].toString(),
      );
  final String type;
  final List<double> coordinates;
  final String address;

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
        'address': address,
      };

  Location copyWith({
    String? type,
    List<double>? coordinates,
    String? address,
  }) {
    return Location(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
    );
  }
}

class Distance {
  Distance({
    required this.value,
    required this.text,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        value: json['value'] as int,
        text: json['text'].toString(),
      );
  final int value;
  final String text;

  Map<String, dynamic> toJson() => {
        'value': value,
        'text': text,
      };

  Distance copyWith({
    int? value,
    String? text,
  }) {
    return Distance(
      value: value ?? this.value,
      text: text ?? this.text,
    );
  }
}

class DurationInfo {
  DurationInfo({
    required this.value,
    required this.text,
  });

  factory DurationInfo.fromJson(Map<String, dynamic> json) => DurationInfo(
        value: json['value'] as int,
        text: json['text'].toString(),
      );
  final int value;
  final String text;

  Map<String, dynamic> toJson() => {
        'value': value,
        'text': text,
      };

  DurationInfo copyWith({
    int? value,
    String? text,
  }) {
    return DurationInfo(
      value: value ?? this.value,
      text: text ?? this.text,
    );
  }
}
