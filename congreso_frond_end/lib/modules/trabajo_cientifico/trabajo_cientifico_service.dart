import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';

class TrabajoCientificoService {
  final TrabajoCientificoRepository repository;

  TrabajoCientificoService(this.repository);

  Future<({TrabajoCientifico? data, int code, String message})> save(
    TrabajoCientifico data,
  ) async {
    try {
      var response = await repository.save(data);
      TrabajoCientifico? p = response.object != null
          ? TrabajoCientifico.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
