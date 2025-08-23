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
}
