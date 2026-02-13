class CustomException implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final _message;
  // ignore: prefer_typing_uninitialized_variables
  final _prefix;

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
  BadRequestException(message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(message) : super(message, "Unauthorised: ");
}

class CancelLoginException extends CustomException {
  CancelLoginException(message) : super(message, "Cancel Login: ");
}

class ConflictException extends CustomException {
  ConflictException(message) : super(message, "Conflict: ");
}

class PayloadTooLargeException extends CustomException {
  PayloadTooLargeException(message) : super(message, "Payload Too Large: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}
