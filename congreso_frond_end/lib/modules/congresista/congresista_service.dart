import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/congresista/congresista_repository.dart';

class CongresistaService {
  final CongresistaRepository repository;

  CongresistaService(this.repository);

  Future<({Usuario? data, int code, String message})> save(
    Usuario congresista,
  ) async {
    try {
      var response = await repository.save(congresista);
      Usuario? p = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
