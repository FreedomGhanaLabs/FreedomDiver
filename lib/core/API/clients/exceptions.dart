class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;
}

class BadRequestException extends NetworkException {
  BadRequestException(super.message);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends NetworkException {
  ForbiddenException(super.message);
}

class NotFoundException extends NetworkException {
  NotFoundException(super.message);
}

class InternalServerErrorException extends NetworkException {
  InternalServerErrorException(super.message);
}
