import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';

class PagoRepository {
  final Api api;

  PagoRepository(this.api);

  Future<GenericResponseEntity> confirmar({
    required int idCongresista,
    required bool isExonerado,
  }) async {
    try {
      final response = await api.put(
        '/pago/confirmar',
        queryParameters: {
          'idCongresista': idCongresista,
          'isExonerado': isExonerado,
        },
      );
      GenericResponseEntity genericResponse = GenericResponseEntity.fromJson(
        response.data,
      );
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity> anularPago({required int idCongresista}) async {
    try {
      final response = await api.delete(
        '/pago/anular',
        queryParameters: {'idCongresista': idCongresista},
      );
      GenericResponseEntity genericResponse = GenericResponseEntity.fromJson(
        response.data,
      );
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultaConFiltros({
    String? nombre,
    String? registroAcademico,
    required String estado, // "TODOS"|"PAGOS"|"EXONERADOS"|"PENDIENTES"
    DateTime? desde,
    DateTime? hasta,
    required int pageNr,
    required int pageSize,
  }) async {
    try {
      final response = await api.get(
        '/congresista/consultaConFiltros',
        queryParameters: {
          'nombre': nombre,
          'registroAcademico': registroAcademico,
          'estado': estado,
          'desde': desde?.toIso8601String(),
          'hasta': hasta?.toIso8601String(),
          'pageNr': pageNr,
          'pageSize': pageSize,
        },
      );
      return response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
    } catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> resumenCobradorTurno({
    DateTime? desde,
    DateTime? hasta,
  }) async {
    try {
      final response = await api.get(
        '/congresista/resumenCobradorTurno',
        queryParameters: {
          'desde': desde?.toIso8601String(),
          'hasta': hasta?.toIso8601String(),
        },
      );
      return response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
    } catch (e) {
      throw RepositoryException.toException(e);
    }
  }
}
