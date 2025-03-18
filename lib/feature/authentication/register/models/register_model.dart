class RegisterModel {
  RegisterModel({
    required this.phoneNumber,
    required this.driversName,
    required this.driversEmail,
    required this.motorcycleType,
    required this.motorcycleColor,
    required this.licenseNumber,
    required this.motorcycleNumber,
    required this.motorcycleYear,
    required this.address,
    required this.password,
    required this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        'phone': phoneNumber,
        'name': driversName,
        'email': driversEmail,
        'motorcycleType': motorcycleType,
        'motorcycleColor': motorcycleColor,
        'licenseNumber': licenseNumber,
        'motorcycleNumber': motorcycleNumber,
        'motorcycleYear': motorcycleYear,
        'address': address,
        'password': password,
        'profilePicture': profilePicture
      };

  final String phoneNumber;
  final String driversName;
  final String driversEmail;
  final String motorcycleType;
  final String motorcycleColor;
  final String licenseNumber;
  final String motorcycleNumber;
  final String motorcycleYear;
  final String address;
  final String password;
  final String profilePicture;
}

class RegisterResponse {
  RegisterResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        success: json["success"] as bool,
        message: json["message"] as String,
      );
}
