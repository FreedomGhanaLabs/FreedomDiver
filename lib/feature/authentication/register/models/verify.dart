class DriverVerificationResponse {
  DriverVerificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DriverVerificationResponse.fromJson(Map<String, dynamic> json) {
    return DriverVerificationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data:
          DriverVerificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final DriverVerificationData data;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DriverVerificationData {
  DriverVerificationData({
    required this.id,
    required this.firstName,
    required this.email,
    required this.token,
  });

  factory DriverVerificationData.fromJson(Map<String, dynamic> json) {
    return DriverVerificationData(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }
  final String id;
  final String firstName;
  final String email;
  final String token;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'email': email,
      'token': token,
    };
  }
}
