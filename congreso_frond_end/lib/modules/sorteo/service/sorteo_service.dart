import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/sorteo/repositories/sorteo_repository.dart';

class SorteoService {
  final SorteoRepository repository;

  SorteoService(this.repository);

  Future<void> guardarGanador(
    Usuario congresista,
    Auspiciante auspiciante,
  ) async {
    try {
      await repository.guardarGanador(congresista, auspiciante);
      return;
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({List<Usuario> data, int code, String message})>
  consultaCongresistaDisponiblesSorteo(String tipoSorteo) async {
    try {
      var response = await repository.consultaCongresistaDisponiblesSorteo(
        tipoSorteo,
      );
      if (response == null) {
        throw ServiceException(
          message: 'No se encontró información del congresista',
        );
      }
      List<Usuario> usuarios = response.object != null
          ? (response.object as List).map((e) => Usuario.fromJson(e)).toList()
          : [];
      return (data: usuarios, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
