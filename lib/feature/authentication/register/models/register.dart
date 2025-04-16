class Driver {
  Driver({
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
    required this.password,
    required this.confirmPassword,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
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
      address: json['address'] as String? ?? '',
      password: json['password'] as String? ?? '',
      confirmPassword: json['confirmPassword'] as String? ?? '',
    );
  }

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
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
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
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class DriverRegistrationResponse {
  DriverRegistrationResponse({
    required this.success,
    required this.message,
    required this.driverId,
  });

  factory DriverRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return DriverRegistrationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      driverId: json['driverId'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
  final String driverId;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'driverId': driverId,
    };
  }
}
