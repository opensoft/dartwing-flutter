class CustomException implements Exception {
  final String? _message;
  final String? _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException(String message)
    : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException(String message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

class CancelLoginException extends CustomException {
  CancelLoginException(String message) : super(message, "Cancel Login: ");
}

class ConflictException extends CustomException {
  ConflictException(String message) : super(message, "Conflict: ");
}

class PayloadTooLargeException extends CustomException {
  PayloadTooLargeException(String message)
    : super(message, "Payload Too Large: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}
