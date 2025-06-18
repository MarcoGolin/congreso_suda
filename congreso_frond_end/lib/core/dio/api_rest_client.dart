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
    if (eX.response == null) {
      throw DioException(
        message: "Connection timedout",
        requestOptions: RequestOptions(),
        error: "Cannot established connection with server",
      );
    }
    if (eX.error != null) {
      if (eX.type == DioExceptionType.unknown) {
        debugPrint("Connection failed");
        // Sentry.captureException(
        //   eX,
        //   stackTrace: eX.error,
        // );
        Modular.to.pushNamedAndRemoveUntil('/error_conexion', (p0) => false);
        throw RestClientException(
          statusMessage: eX.error.toString(),
          statusCode: eX.response!.statusCode!,
          error: eX,
        );
      }
      if (eX.response?.statusCode == 500) {
        // Alert.show('No fue posible completar la operación', Alert.WARNING);

        throw RestClientException(
          statusMessage: eX.error.toString(),
          statusCode: eX.response!.statusCode!,
          error: eX,
        );
      }
      if (eX.response?.statusCode == 202) {
        throw RestClientResponse(
          data: eX.response!.data,
          statusCode: 202,
          statusMessage: eX.response!.data['message'],
        );
      }
      if (eX.response?.statusCode == 401) {
        debugPrint('Error de Autenticación!');
        // Alert.show(
        //   'Usuario o contraseña incorrectos',
        //   Alert.ERROR,
        // );
        if (Modular.to.path.toString().compareTo('/login') == 0) {
          // Modular.to.pop();
        } else {
          Modular.to.pushNamedAndRemoveUntil('/login', (p0) => false);
        }

        throw RestClientException(
          statusMessage: eX.error.toString(),
          statusCode: eX.response?.statusCode!,
          error: eX,
        );
      }
    }

    if (eX.error is String) {
      debugPrint("Connection failed");
      Modular.to.pushNamedAndRemoveUntil('/error_conexion', (p0) => false);
      throw RestClientException(
        statusMessage: eX.error.toString(),
        statusCode: eX.response!.statusCode!,
        error: eX,
      );
    } else {
      if (eX.response != null) {
        if (eX.response != null) {
          throw RestClientException(
            statusMessage: eX.response.data,
            statusCode: eX.response.statusCode,
            error: eX,
          );
        }
      }

      throw RestClientException(
        statusMessage: eX.message,
        statusCode: eX.response?.statusCode,
        error: eX,
      );
    }
  }

  RestClientResponse<T> _sucessManager<T>(Response<dynamic> response) {
    return RestClientResponse(
      data: response.data,
      statusCode: response.statusCode!,
      statusMessage: response.statusMessage!,
    );
  }
}
