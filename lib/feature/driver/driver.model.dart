enum DriverStatus {
  available,
  unavailable,
}

extension DriverStatusExtension on DriverStatus {
  String get name {
    switch (this) {
      case DriverStatus.available:
        return 'available';
      case DriverStatus.unavailable:
        return 'unavailable';
    }
  }

  static DriverStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return DriverStatus.available;
      case 'unavailable':
        return DriverStatus.unavailable;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }
}

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
    required this.insurance,
    required this.pendingNameUpdate,
    required this.notificationPreferences,
    required this.ridePreference,
    required this.ratings,
    required this.numOfReviews,
    required this.knownDevices,
    required this.suspended,
    required this.twoFactorEnabled,
    required this.isVerified,
    this.documentStatus,
    this.documentComments,
    this.status,
    this.location,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.token,
    this.socketId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      otherName: json['otherName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      motorcycleType: json['motorcycleType'] as String? ?? '',
      motorcycleColor: json['motorcycleColor'] as String? ?? '',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      motorcycleNumber: json['motorcycleNumber'] as String? ?? '',
      motorcycleYear: json['motorcycleYear'] as String? ?? '',
      address:
          Address.fromJson((json['address'] as Map<String, dynamic>?) ?? {}),
      insurance: Insurance.fromJson(
        (json['insurance'] as Map<String, dynamic>?) ?? {},
      ),
      pendingNameUpdate: PendingNameUpdate.fromJson(
        (json['pendingNameUpdate'] as Map<String, dynamic>?) ?? {},
      ),
      notificationPreferences: NotificationPreferences.fromJson(
        (json['notificationPreferences'] as Map<String, dynamic>?) ?? {},
      ),
      ridePreference: json['ridePreference'] as String? ?? '',
      ratings: (json['ratings'] as num? ?? 0).toDouble(),
      numOfReviews: json['numOfReviews'] as int? ?? 0,
      knownDevices: (json['knownDevices'] as List<dynamic>? ?? [])
          .map((e) => KnownDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
      suspended: json['suspended'] as bool? ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      documentStatus: json['documentStatus'] as String?,
      documentComments: json['documentComments'] as String?,
      status: json['status'] as String?,
      location: json['location'] != null
          ? DriverLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      role: json['role'] as String?,
      token: json['token'] as String?,
      socketId: json['socketId'] as String?,
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
  final Address address;
  final Insurance insurance;
  final PendingNameUpdate pendingNameUpdate;
  final NotificationPreferences notificationPreferences;
  final String ridePreference;
  final double ratings;
  final int numOfReviews;
  final List<KnownDevice> knownDevices;
  final bool suspended;
  final bool twoFactorEnabled;
  final bool isVerified;
  final String? documentStatus;
  final String? documentComments;
  final String? status;
  final DriverLocation? location;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? token;
  final String? socketId;
}

// Nested Models

class Address {
  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json['street'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
        country: json['country'] as String? ?? '',
        postalCode: json['postalCode'] as String? ?? '',
      );

  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
}

class Insurance {
  Insurance({required this.isVerified});

  factory Insurance.fromJson(Map<String, dynamic> json) =>
      Insurance(isVerified: json['isVerified'] as bool? ?? false);

  final bool isVerified;
}

class PendingNameUpdate {
  PendingNameUpdate({
    required this.status,
    required this.requestedAt,
  });

  factory PendingNameUpdate.fromJson(Map<String, dynamic> json) =>
      PendingNameUpdate(
        status: json['status'] as String? ?? '',
        requestedAt: DateTime.tryParse(json['requestedAt'] as String? ?? ''),
      );

  final String status;
  final DateTime? requestedAt;
}

class NotificationPreferences {
  NotificationPreferences({
    required this.loginAlerts,
    required this.securityAlerts,
    required this.marketingEmails,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        loginAlerts: json['loginAlerts'] as bool? ?? false,
        securityAlerts: json['securityAlerts'] as bool? ?? false,
        marketingEmails: json['marketingEmails'] as bool? ?? false,
      );

  final bool loginAlerts;
  final bool securityAlerts;
  final bool marketingEmails;
}

class KnownDevice {
  KnownDevice({
    required this.fingerprint,
    required this.browser,
    required this.os,
    required this.device,
    required this.firstLogin,
    required this.lastLogin,
    required this.id,
  });

  factory KnownDevice.fromJson(Map<String, dynamic> json) => KnownDevice(
        fingerprint: json['fingerprint'] as String? ?? '',
        browser: json['browser'] as String? ?? '',
        os: json['os'] as String? ?? '',
        device: json['device'] as String? ?? '',
        firstLogin: DateTime.tryParse(json['firstLogin'] as String? ?? ''),
        lastLogin: DateTime.tryParse(json['lastLogin'] as String? ?? ''),
        id: json['_id'] as String? ?? '',
      );

  final String fingerprint;
  final String browser;
  final String os;
  final String device;
  final DateTime? firstLogin;
  final DateTime? lastLogin;
  final String id;
}

class DriverLocation {
  DriverLocation({
    required this.type,
    required this.coordinates,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
        type: json['type'] as String? ?? '',
        coordinates: (json['coordinates'] as List<dynamic>? ?? [])
            .map((e) => (e as num).toDouble())
            .toList(),
      );

  final String type;
  final List<double> coordinates;
}
