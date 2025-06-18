import 'package:flutter/material.dart';

import 'rest_client_exception.dart';

class RepositoryException implements Exception {
  String? message;
  int? code;

  RepositoryException.toException(Exception e) {
    if (e is RestClientException) {
      if (e.statusCode == 500) {
        message = 'Ocurrio un error desconocido';
        code = 500;
        return;
      }
      message = e.statusMessage;
      code = e.statusCode;
      return;
    }
    message = e.toString();
    code = 500;
  }

  @override
  String toString() {
    debugPrint('RepositoryException: ${message ?? ''} - ${code ?? ''}');
    return " ${message ?? ''}";
  }
}
