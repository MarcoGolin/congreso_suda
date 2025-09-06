import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';

class OrganizadoresRepository {
  final Api api;

  OrganizadoresRepository(this.api);

  Future<GenericResponseEntity?> consultaTodos() async {
    try {
      final response = await api.get('/organizadores/consultaTodos');
      GenericResponseEntity? genericResponse = response.data != null
          ? GenericResponseEntity.fromJson(response.data)
          : null;
      return genericResponse;
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }
}
