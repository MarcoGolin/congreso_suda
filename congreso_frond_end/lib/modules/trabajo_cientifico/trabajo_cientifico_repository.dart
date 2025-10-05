import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';

import '../../core/exception/repository_exception.dart';

class TrabajoCientificoRepository {
  final Api api;

  TrabajoCientificoRepository(this.api);

  Future<GenericResponseEntity> save(TrabajoCientifico data) async {
    try {
      final response = await api.post(
        '/trabajo_cientifico/save',
        data: data.toJson(),
      );
      GenericResponseEntity genericResponse = GenericResponseEntity.fromJson(
        response.data,
      );
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultaTrabajosPorUsuario({
    required int usuarioId,
  }) async {
    try {
      final response = await api.get(
        '/trabajo_cientifico/consultaTrabajosPorUsuario',
        // En tu backend uses @RequestAttribute Long idUsuario, así que el ID va en el header/token
        // Los query parameters no son necesarios ya que se obtiene del token
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  /// Consulta todos los trabajos científicos (para admin)
  Future<GenericResponseEntity?> consultaTodos() async {
    try {
      final response = await api.get('/trabajo_cientifico/consultaTodos');
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity> cancelar(int idTrabajo) async {
    try {
      final response = await api.put(
        '/trabajo_cientifico/cancelar',
        queryParameters: {'idTrabajo': idTrabajo},
      );

      if (response.data == null) {
        throw RepositoryException.toException(
          'No se recibió respuesta del servidor',
        );
      }
      return GenericResponseEntity.fromJson(response.data);
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity> cambiarEstado(int id, String estado) async {
    try {
      final response = await api.put(
        '/trabajo_cientifico/cambiarEstado',
        queryParameters: {'idTrabajo': id, 'estado': estado},
      );

      if (response.data == null) {
        throw RepositoryException.toException(
          'No se recibió respuesta del servidor',
        );
      }
      return GenericResponseEntity.fromJson(response.data);
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }
}
