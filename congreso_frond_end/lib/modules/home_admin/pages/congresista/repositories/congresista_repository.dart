import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';

class CongresistaRepository {
  final Api api;

  CongresistaRepository(this.api);

  Future<GenericResponseEntity> save(Usuario usuario) async {
    try {
      final response = await Api.withOutAuth().post(
        '/congresista/save',
        data: usuario.toJson(),
      );
      GenericResponseEntity genericResponse = GenericResponseEntity.fromJson(
        response.data,
      );
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }

  Future<GenericResponseEntity?>
  consultaCongresistaPorNombreORegistroAcademico({
    String? nombre,
    String? registroAcademico,
    required int pageNr,
    required int pageSize,
  }) async {
    try {
      final response = await api.get(
        '/congresista/consultaCongresistaPorNombreORegistroAcademico',
        queryParameters: {
          'nombre': nombre,
          'registroAcademico': registroAcademico,
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
}
