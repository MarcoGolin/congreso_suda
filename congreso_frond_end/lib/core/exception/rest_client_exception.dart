class RestClientException implements Exception {
  final String? statusMessage;
  final int? statusCode;
  final dynamic error;

  RestClientException({this.statusMessage, this.statusCode, this.error});
}
