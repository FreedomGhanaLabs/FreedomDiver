class AuthenticationEndpoint {
  static const String login = '/login';
  static const String register = '/api/auth/register/driver';
  static const String profile = '/api/drivers/profile';
  static const String preference = '/api/drivers/preference';
  static const String status = '/api/drivers/status';
  static const String location = '/api/drivers/location';
  static const String wallet = '/api/drivers/wallet';
  static const String earnings = '/api/drivers/earnings';
  static const String earningsReport = '/api/drivers/earnings/report';
  static const String uploadDocs = '/api/drivers/upload-docs';
  static const String verifyDocs = '/api/drivers/verify-docs/:driverId';
}
