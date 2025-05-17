class Ride {

  Ride({
    required this.success,
    required this.count,
    required this.totalPages,
    required this.currentPage,
    required this.data,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      success: json['success'] as bool,
      count: json['count'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      data: (json['data'] as List).map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
  final bool success;
  final int count;
  final int totalPages;
  final int currentPage;
  final List<RideModel> data;

  Map<String, dynamic> toJson() => {
        'success': success,
        'count': count,
        'totalPages': totalPages,
        'currentPage': currentPage,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class RideModel {

  RideModel({
    required this.id,
    required this.user,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.status,
    required this.totalFare,
    required this.driverEarnings,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.requestedAt,
    required this.completedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['_id'] as String,
      user: UserModel.fromJson(json['user']  as Map<String, dynamic>),
      pickupLocation: RideLocation.fromJson(json['pickupLocation']  as Map<String, dynamic>),
      dropoffLocation: RideLocation.fromJson(json['dropoffLocation'] as Map<String, dynamic> ) ,
      status: json['status'] as String,
      totalFare: (json['totalFare'] as num).toDouble(),
      driverEarnings: (json['driverEarnings'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      requestedAt: DateTime.parse(json['requestedAt'].toString()),
      completedAt: DateTime.parse(json['completedAt'].toString()),
    );
  }
  final String id;
  final UserModel user;
  final RideLocation pickupLocation;
  final RideLocation dropoffLocation;
  final String status;
  final double totalFare;
  final double driverEarnings;
  final String currency;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime requestedAt;
  final DateTime completedAt;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user.toJson(),
        'pickupLocation': pickupLocation.toJson(),
        'dropoffLocation': dropoffLocation.toJson(),
        'status': status,
        'totalFare': totalFare,
        'driverEarnings': driverEarnings,
        'currency': currency,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'requestedAt': requestedAt.toIso8601String(),
        'completedAt': completedAt.toIso8601String(),
      };
}

class UserModel {

  UserModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String,
      phone: json['phone'] as String,
    );
  }
  final String id;
  final String name;
  final String profilePicture;
  final String phone;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profilePicture': profilePicture,
        'phone': phone,
      };
}

class RideLocation {

  RideLocation({
    required this.coordinates,
    required this.address,
  });

  factory RideLocation.fromJson(Map<String, dynamic> json) {
    return RideLocation(
      coordinates: (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] as String,
    );
  }
  final List<double> coordinates;
  final String address;

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'address': address,
      };
}
