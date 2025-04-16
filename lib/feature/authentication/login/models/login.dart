class LoginPhoneNumberVerificationResponse {
  LoginPhoneNumberVerificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginPhoneNumberVerificationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginPhoneNumberVerificationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: LoginPhoneData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
  final bool success;
  final String message;
  final LoginPhoneData data;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class LoginPhoneData {
  LoginPhoneData({
    required this.id,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.role,
    required this.token,
  });

  factory LoginPhoneData.fromJson(Map<String, dynamic> json) {
    return LoginPhoneData(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  final String id;
  final String firstName;
  final String email;
  final String phone;
  final String role;
  final String token;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'role': role,
      'token': token,
    };
  }
}
