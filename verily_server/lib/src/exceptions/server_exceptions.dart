import 'package:serverpod/serverpod.dart';

/// Thrown when a user is not authenticated.
class AuthenticationRequiredException extends SerializableException {
  AuthenticationRequiredException([this.message = 'Authentication required']);
  final String message;
}

/// Thrown when a requested resource is not found.
class NotFoundException extends SerializableException {
  NotFoundException([this.message = 'Not found']);
  final String message;
}

/// Thrown when a user does not have permission.
class ForbiddenException extends SerializableException {
  ForbiddenException([this.message = 'Forbidden']);
  final String message;
}

/// Thrown for invalid input data.
class ValidationException extends SerializableException {
  ValidationException([this.message = 'Validation failed']);
  final String message;
}
