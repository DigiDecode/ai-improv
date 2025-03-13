class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? details;

  ApiException(this.message, this.statusCode, [this.details]);

  @override
  String toString() =>
      'API Exception: $message (Status Code: $statusCode${details != null ? ', Details: $details' : ''})';
}
