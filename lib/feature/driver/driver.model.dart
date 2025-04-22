class Driver {
  Driver({
    required this.id,
    required this.firstName,
    required this.surname,
    required this.otherName,
    required this.email,
    required this.phone,
    required this.motorcycleType,
    required this.motorcycleColor,
    required this.licenseNumber,
    required this.motorcycleNumber,
    required this.motorcycleYear,
    required this.address,
    this.status,
    this.location,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.token,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) => (value is String) ? value : '';
    return Driver(
      id: safeString(json['id']),
      firstName: safeString(json['firstName']),
      surname: safeString(json['surname']),
      otherName: safeString(json['otherName']),
      email: safeString(json['email']),
      phone: safeString(json['phone']),
      motorcycleType: safeString(json['motorcycleType']),
      motorcycleColor: safeString(json['motorcycleColor']),
      licenseNumber: safeString(json['licenseNumber']),
      motorcycleNumber: safeString(json['motorcycleNumber']),
      motorcycleYear: safeString(json['motorcycleYear']),
      address: safeString(json['address']),
      status: safeString(json['status']),
      location: json['location'] != null &&
              json['location'] is Map<String, dynamic>
          ? DriverLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(safeString(json['lastActiveAt']))
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(safeString(json['createdAt']))
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(safeString(json['updatedAt']))
          : null,
      role: safeString(json['role']),
      token: safeString(json['token']),
    );
  }

  String get fullName {
    return [
      firstName.trim(),
      // if (otherName.isNotEmpty) otherName.trim(),
      surname.trim(),
    ].join(' ');
  }

  final String id;
  final String firstName;
  final String surname;
  final String otherName;
  final String email;
  final String phone;
  final String motorcycleType;
  final String motorcycleColor;
  final String licenseNumber;
  final String motorcycleNumber;
  final String motorcycleYear;
  final String address;
  final String? status;
  final DriverLocation? location;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? token;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'surname': surname,
      'otherName': otherName,
      'email': email,
      'phone': phone,
      'motorcycleType': motorcycleType,
      'motorcycleColor': motorcycleColor,
      'licenseNumber': licenseNumber,
      'motorcycleNumber': motorcycleNumber,
      'motorcycleYear': motorcycleYear,
      'address': address,
      'status': status,
      'location': location?.toJson(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'role': role,
      'token': token,
    };
  }
}

class DriverLocation {
  DriverLocation({
    required this.type,
    required this.coordinates,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      type: json['type'].toString(),
      coordinates: json['coordinates'] as List<double>,
    );
  }

  final String type;
  final List<double> coordinates;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
