
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
