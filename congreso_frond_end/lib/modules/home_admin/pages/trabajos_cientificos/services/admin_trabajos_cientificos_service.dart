import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';

class AdminTrabajosCientificosService {
  final TrabajoCientificoRepository repository;

  AdminTrabajosCientificosService(this.repository);

  /// Consulta todos los trabajos científicos para la vista admin
  Future<({List<TrabajoCientifico> data, int code, String message})>
  consultarTodos() async {
    try {
      var response = await repository.consultaTodos();

      if (response?.object != null) {
        List<TrabajoCientifico> trabajos = [];

        if (response!.object is List) {
          trabajos = (response.object as List)
              .map(
                (item) =>
                    TrabajoCientifico.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }

        return (data: trabajos, code: response.code, message: response.message);
      }

      return (
        data: <TrabajoCientifico>[],
        code: response?.code ?? 404,
        message: response?.message ?? 'No se encontraron trabajos científicos',
      );
    } catch (e) {
      throw ServiceException(
        message: 'Error al consultar trabajos científicos: ${e.toString()}',
      );
    }
  }

  Future<({TrabajoCientifico? data, int code, String message})> cancelar(
    int idTrabajo,
  ) async {
    try {
      var response = await repository.cancelar(idTrabajo);
      TrabajoCientifico? p = response.object != null
          ? TrabajoCientifico.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({TrabajoCientifico? data, int code, String message})> cambiarEstado(
    int id,
    String nuevoEstado,
  ) async {
    try {
      var response = await repository.cambiarEstado(id, nuevoEstado);
      TrabajoCientifico? p = response.object != null
          ? TrabajoCientifico.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
