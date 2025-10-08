import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';
import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';

class SorteoRepository {
  final Api api;

  SorteoRepository(this.api);

  Future<GenericResponseEntity> guardarGanador(
    Usuario usuario,
    Auspiciante auspiciante,
  ) async {
    try {
      final response = await api.post(
        '/sorteo/guardarGanador',
        queryParameters: {
          'idUsuario': usuario.id,
          'auspiciante': auspiciante.name,
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

  Future<GenericResponseEntity?> consultaCongresistaDisponiblesSorteo(
    String tipoSorteo,
  ) async {
    try {
      final response = await api.get(
        '/sorteo/consultaCongresistaDisponiblesSorteo',
        queryParameters: {'tipoSorteo': tipoSorteo},
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
