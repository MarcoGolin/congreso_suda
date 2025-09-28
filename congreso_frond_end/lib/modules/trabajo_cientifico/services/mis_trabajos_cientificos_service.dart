import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';

class MisTrabajosCientificosService {
  final TrabajoCientificoRepository repository;

  MisTrabajosCientificosService(this.repository);

  /// Consulta trabajos científicos por usuario ID usando endpoint real
  /// Corresponde al endpoint: GET /api/trabajo_cientifico/consultaTrabajosPorUsuario
  Future<({List<TrabajoCientifico> data, int code, String message})>
  findByUsuarioId(String usuarioId) async {
    try {
      // Llamada real al backend usando el repositorio existente
      var response = await repository.consultaTrabajosPorUsuario(
        usuarioId: int.parse(usuarioId),
      );

      List<TrabajoCientifico> list = response?.object != null
          ? (response?.object as List)
                .map((e) => TrabajoCientifico.fromJson(e))
                .toList()
          : [];

      return (
        data: list,
        code: response?.code ?? 0,
        message: response?.message ?? '',
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
