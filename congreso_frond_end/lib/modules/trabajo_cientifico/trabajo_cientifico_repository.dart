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
}
