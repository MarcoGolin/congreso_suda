import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';

class TallerRepository {
  final Api api;

  TallerRepository(this.api);

  Future<GenericResponseEntity?> consultaTodos() async {
    try {
      final response = await api.get('/taller/consultaTodos');
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?> inscribir({required int idTaller}) async {
    try {
      final response = await api.post(
        '/tallerInscripto/inscribir',
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
}
