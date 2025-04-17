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
    required this.id,
    required this.role,
    required this.token,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String? ?? '',
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
      role: json['role'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
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
  final String role;
  final String token;

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
      'role': role,
      'token': token,
    };
  }
}
