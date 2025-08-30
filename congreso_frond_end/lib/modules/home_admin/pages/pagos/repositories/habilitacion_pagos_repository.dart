import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';

class HabilitacionPagosRepository {
  final Api api;

  HabilitacionPagosRepository(this.api);

  Future<GenericResponseEntity> habilitar(HabilitacionPagos habilitar) async {
    try {
      final response = await api.post(
        '/habilitacion_pagos/habilitar',
        data: habilitar.toJson(),
      );
      GenericResponseEntity genericResponse = GenericResponseEntity.fromJson(
        response.data,
      );
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultaHorarios({
    required int idUsuario,
  }) async {
    try {
      final response = await api.get(
        '/habilitacion_pagos/consultaHorarios',
        queryParameters: {'idUsuario': idUsuario},
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultarSiEstaHabilitado({
    required int idUsuario,
  }) async {
    try {
      final response = await api.get(
        '/habilitacion_pagos/consultarSiEstaHabilitado',
        queryParameters: {'idUsuario': idUsuario},
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }
}
