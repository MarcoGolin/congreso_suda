import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';

class TallerInscriptoRepository {
  final Api api;

  TallerInscriptoRepository(this.api);

  Future<GenericResponseEntity?> inscribir({
    required int? idUsuario,
    required int idTaller,
    required bool isJuntaDirectiva,
  }) async {
    try {
      final response = await api.post(
        '/tallerInscripto/inscribirListado',
        queryParameters: {
          'idUsuario': idUsuario,
          'idTaller': idTaller,
          'isJuntaDirectiva': isJuntaDirectiva,
        },
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> verificarInscripto({
    required int idTaller,
  }) async {
    try {
      final response = await api.get(
        '/tallerInscripto/verificarInscripto',
        queryParameters: {'idTaller': idTaller},
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultarTalleresPorUsuario({
    required int usuarioId,
  }) async {
    try {
      final response = await api.get(
        '/tallerInscripto/consultarTalleresPorUsuario',
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> consultaParticipantesDelTaller({
    required int idTaller,
    required int pageNr,
    required int pageSize,
  }) async {
    try {
      final response = await api.get(
        '/tallerInscripto/consultaParticipantesDelTaller',
        queryParameters: {
          'idTaller': idTaller,
          'pageNr': pageNr,
          'pageSize': pageSize,
        },
      );
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> remover({required int idInscripto}) async {
    try {
      final response = await api.delete(
        '/tallerInscripto/remover',
        queryParameters: {'idInscripto': idInscripto},
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
