import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'hostname.dart';
import 'i_rest_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/date_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/lenguage_interceptor.dart';
import 'interceptors/no_auth_interceptor.dart';
import 'interceptors/retry_on_connection_change_interceptor.dart';
import 'interceptors/time_execution_interceptor.dart';
import 'rest_client_exception.dart';
import 'rest_client_response.dart';

class Api implements IRestClient {
  late Dio _dio;

  final _baseOptions = BaseOptions(
    baseUrl: Hostname.httpURL(),
    connectTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 120),
  );

  Api() {
    _dio = Dio(_baseOptions);
    _dio.interceptors.addAll([
      ErrorInterceptor(),
      LenguageInterceptor(),
      TimeExecutionInterceptor(),
      AuthInterceptor(),
      RetryOnConnectionChangeInterceptor(
        requestRetrier: ConnectivityInterceptor(
          dio: _dio,
          connectivity: Connectivity(),
        ),
      ),
    ]);
  }

  Api.withOutAuth() {
    _dio = Dio(_baseOptions);
    _dio.interceptors.addAll([
      ErrorInterceptor(),
      LenguageInterceptor(),
      TimeExecutionInterceptor(),
      DateInterceptor(),
      NoAuthInterceptor(),
      RetryOnConnectionChangeInterceptor(
        requestRetrier: ConnectivityInterceptor(
          dio: _dio,
          connectivity: Connectivity(),
        ),
      ),
    ]);
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      getFileReturnSize(responde);
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  void getFileReturnSize(Response<dynamic> responde) {
    String? contentLength = responde.headers.map['content-length']?.first;

    if (contentLength != null) {
      int bytes = int.tryParse(contentLength) ?? 0;
      double megabytes = bytes / 1048576; // 1024 * 1024
      double megabytesRedondeado = double.parse((megabytes).toStringAsFixed(2));
      debugPrint('$bytes bytes es igual a $megabytesRedondeado megabytes');
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.get(path, queryParameters: queryParameters);
      getFileReturnSize(responde);
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final responde = await _dio.request(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _sucessManager<T>(responde);
    } on DioException catch (e) {
      return _errorManager(e);
    }
  }

  _errorManager(eX) {
    // Sin respuesta -> problema de red
    if (eX.response == null) {
      throw DioException(
        message: "Connection timedout",
        requestOptions: RequestOptions(),
        error: "Cannot established connection with server",
      );
    }

    final status = eX.response?.statusCode;

    // === Manejo explícito de 400 / 409 / 404 ===
    if (status == 400 || status == 409 || status == 404) {
      final msg = _extractServerMessage(eX.response?.data);
      throw RestClientException(
        statusMessage: msg,
        statusCode: status,
        error: eX,
      );
    }

    // 401: mantener tu lógica actual de redirect a /login
    if (status == 401) {
      debugPrint('Error de Autenticación!');
      if (Modular.to.path.toString().compareTo('/login') != 0) {
        Modular.to.pushNamedAndRemoveUntil('/login', (p0) => false);
      }
      throw RestClientException(
        statusMessage: eX.error?.toString() ?? 'No autorizado',
        statusCode: status,
        error: eX,
      );
    }

    // 500 u otros: propagar mensaje (o uno genérico si viene vacío)
    if (status == 500) {
      final msg = _extractServerMessage(eX.response?.data);
      throw RestClientException(
        statusMessage: msg.isEmpty
            ? 'No fue posible completar la operación'
            : msg,
        statusCode: status,
        error: eX,
      );
    }

    // Desconocido / red
    if (eX.type == DioExceptionType.unknown) {
      Modular.to.pushNamedAndRemoveUntil('/error_conexion', (p0) => false);
      throw RestClientException(
        statusMessage: 'Falla de conexión',
        statusCode: status,
        error: eX,
      );
    }

    // Fallback genérico
    final fallback = _extractServerMessage(eX.response?.data);
    throw RestClientException(
      statusMessage: fallback,
      statusCode: status,
      error: eX,
    );
  }

  RestClientResponse<T> _sucessManager<T>(Response<dynamic> response) {
    return RestClientResponse(
      data: response.data,
      statusCode: response.statusCode!,
      statusMessage: response.statusMessage!,
    );
  }

  String _extractServerMessage(dynamic data) {
    if (data == null) return 'Ocurrió un error desconocido';

    // Si ya es Mapa (Dio suele decodificar JSON)
    if (data is Map) {
      // RFC 7807 -> "detail", o tu propio JSON -> "message"
      return data['detail']?.toString() ??
          data['message']?.toString() ??
          data['error_description']?.toString() ??
          data['error']?.toString() ??
          data.toString();
    }

    // Si viene String, intento parsear JSON
    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map) {
          return parsed['detail']?.toString() ??
              parsed['message']?.toString() ??
              parsed['error_description']?.toString() ??
              parsed['error']?.toString() ??
              data;
        }
      } catch (_) {
        /* no es json */
      }
      return data; // texto plano
    }

    // fallback
    return data.toString();
  }
}
