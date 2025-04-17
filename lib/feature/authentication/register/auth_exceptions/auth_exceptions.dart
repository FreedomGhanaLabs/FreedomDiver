class AuthException implements Exception {

  AuthException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkAuthException extends AuthException {
  NetworkAuthException([super.message = 'Network error occurred']);
}

class ServerAuthException extends AuthException {
  ServerAuthException(int statusCode, super.message)
      : super(statusCode: statusCode);
}